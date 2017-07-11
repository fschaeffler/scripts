#!/bin/bash

# FIX FOR FAILING SELENIUM SERVER SESSION
rm -rf node_modules
meteor npm install

# PIPELINE ENVIRONMENT
npm install -g nightwatch

# METEOR ENVIRONMENT
TEST_BUILD=1 VELOCITY=0 IMPORT_TEST_DATA=1 meteor --port 30001 2>&1 &
sleep 180

# TESTING
export RUN_LEVELS=$(grep -R 'runLevel' tests/nightwatch/cases/ | cut -d"'" -f4 | sort | uniq)
if [[ $RUN_LEVELS != '' ]]; then
	temp=$(jq '.test_workers.enabled = true' tests/nightwatch/nightwatch.json);
	echo "$temp" > tests/nightwatch/nightwatch.json;

	rm -rf ../db
	cp -rf .meteor/local/db ..
	sleep 3

	for runLevel in "${RUN_LEVELS[@]}"; do
		nightwatch -c tests/nightwatch/nightwatch.json --suiteRetries 3 --tag $runLevel

		if [[ $runLevel == *"Reset"* ]]; then
			rm -rf .meteor/local/db
			sleep 3
			cp -rf ../db .meteor/local
			sleep 3
		fi
	done
else
	nightwatch -c tests/nightwatch/nightwatch.json --suiteRetries 3;
fi