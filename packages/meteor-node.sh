#!/bin/bash

METEOR_RELEASE=${METEOR_RELEASE:="1.4.2"}

meteor_major=$(echo $test | cut -d'.' -f1)
meteor_minor=$(echo $test | cut -d'.' -f2)

node_version="0.10.46"

if [[ "$meteor_major" -ge "1" ]]; then
	if [[ "$meteor_minor" -ge "3" ]]; then
		node_version="4.6.1"
	fi
fi

nvm install $node_version
nvm use $node_version
nvm alias default $node_version
