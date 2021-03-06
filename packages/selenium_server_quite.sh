#!/bin/bash
# Install Selenium server, http://www.seleniumhq.org
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * SELENIUM_VERSION
# * SELENIUM_PORT
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/selenium_server.sh | bash -s
SELENIUM_VERSION=${SELENIUM_VERSION:="3.4.0"}
SELENIUM_PORT=${SELENIUM_PORT:="4444"}
SELENIUM_OPTIONS=${SELENIUM_OPTIONS:=""}
SELENIUM_WAIT_TIME=${SELENIUM_WAIT_TIME:="10"}
SELENIUM_JAVA_OPTIONS=${SELENIUM_JAVA_OPTIONS:=""}

set -e

MINOR_VERSION=${SELENIUM_VERSION%.*}
CACHED_DOWNLOAD="${HOME}/cache/selenium-server-standalone-${SELENIUM_VERSION}.jar"

wget --continue --output-document "${CACHED_DOWNLOAD}" "http://selenium-release.storage.googleapis.com/${MINOR_VERSION}/selenium-server-standalone-${SELENIUM_VERSION}.jar"
java ${SELENIUM_JAVA_OPTIONS} -jar "${CACHED_DOWNLOAD}" -log selenium-server.log -port "${SELENIUM_PORT}" ${SELENIUM_OPTIONS} &
sleep "${SELENIUM_WAIT_TIME}"
echo "Selenium ${SELENIUM_VERSION} is now ready to connect on port ${SELENIUM_PORT}..."

sleep 15

selenium_check=$(curl 'http://localhost:4444/wd/hub/status' | grep '"state":"success"')
echo $selenium_check
if [[ $selenium_check == '' ]]; then
	selenium_check=$(curl 'http://localhost:4444/wd/hub/status' | grep '"state":"success"')
	echo $selenium_check

	if [[ $selenium_check == '' ]]; then
		script_location="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
		exec "$script_location/selenium_server.sh"
	fi
fi