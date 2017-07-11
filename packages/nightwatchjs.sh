#!/bin/bash

## OLD SETTINGS

# FIX FOR FAILING SELENIUM SERVER SESSION
# rm -rf node_modules
# meteor npm install
# PIPELINE ENVIRONMENT
# npm install -g nightwatch
# METEOR ENVIRONMENT
# TEST_BUILD=1 VELOCITY=0 IMPORT_TEST_DATA=1 meteor --port 30001 2>&1 &
# sleep 180
# export WAIT_FOR_ONLINE="5"
# WGET_OPTIONS="--output-document=/dev/null -t $WAIT_FOR_ONLINE --timeout=$WAIT_FOR_ONLINE --read-timeout=$WAIT_FOR_ONLINE --connect-timeout=$WAIT_FOR_ONLINE -t 1" check_url -t 120 -w $WAIT_FOR_ONLINE "http://localhost:30001"
# TESTING
# nightwatch --config tests/nightwatch/nightwatch.json
# nightwatch --config tests/nightwatch/nightwatch.json --suiteRetries 3
# export RUN_LEVELS=$(grep -R 'runLevel' tests/nightwatch/cases/ | cut -d"'" -f4 | sort | uniq)
# if [[ $RUN_LEVELS != '' ]]; then temp=$(jq '.test_workers.enabled = true' tests/nightwatch/nightwatch.json); echo "$temp" > tests/nightwatch/nightwatch.json; fi
# if [[ $RUN_LEVELS != '' ]]; then grep -R 'runLevel' tests/nightwatch/cases/ | cut -d"'" -f4 | sort | uniq | xargs -L 1 nightwatch -c tests/nightwatch/nightwatch.json --suiteRetries 3 --tag; fi
# if [[ $RUN_LEVELS == '' ]]; then nightwatch -c tests/nightwatch/nightwatch.json --suiteRetries 3; fi

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

	for runLevel in $(grep -R 'runLevel' tests/nightwatch/cases/ | cut -d"'" -f4 | sort | uniq); do
		echo $runLevel
		nightwatch -c tests/nightwatch/nightwatch.json --suiteRetries 3 --tag "$runLevel"

		if [[ $? != 0 ]]; then
			exit $?
		fi

		rm -rf .meteor/local/db
		sleep 3
		cp -rf ../db .meteor/local
		sleep 3
	done
else
	nightwatch -c tests/nightwatch/nightwatch.json --suiteRetries 3;
fi