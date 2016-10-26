#!/bin/bash

METEOR_RELEASE=${METEOR_RELEASE:=""}
METEOR_INSTALL_RETRIES=${METEOR_INSTALL_RETRIES:="3"}

install_retries="0"

try_install () {
	tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
	curl -sSL https://install.meteor.com -o $tmpfile

	check_503=$(cat $tmpfile | grep '503 Service Unavailable')
	if [[ $check_503 == '' ]]; then
		if [[ $METEOR_RELEASE ]]; then
			sed -i 's/^RELEASE=.*$/RELEASE="'${METEOR_RELEASE}'"/g' $tmpfile;
		fi

		sed -i 's/PREFIX=.*/PREFIX="${HOME}"/g' $tmpfile

		chmod +x $tmpfile
		$tmpfile

		rm $tmpfile
	elif [[ "$install_retries" -gt "$METEOR_INSTALL_RETRIES" ]]; then
		echo "installation failed"
		rm $tmpfile
		exit 1
	else
		rm $tmpfile
		install_retries=$(($install_retries + 1))
	fi
}

try_install

unset try_install
