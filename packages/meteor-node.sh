#!/bin/bash

METEOR_RELEASE=${METEOR_RELEASE:="1.4.2"}

meteor_major=$(echo $test | cut -d'.' -f1)
meteor_minor=$(echo $test | cut -d'.' -f2)

node_version="0.10.46"

echo "$meteor_major"
echo "$meteor_minor"

if [[ "$meteor_major" -ge "1" ]]; then
	echo "test"
	if [[ "$meteor_minor" -ge "3" ]]; then
		echo "test2s"
		node_version="4.6.1"
	fi
fi

echo $node_version
