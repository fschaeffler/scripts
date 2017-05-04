#!/bin/bash
# Check a whether a port is open or not
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/utilities/free_port.sh > ${HOME}/bin/free_port && chmod u+x ${HOME}/bin/free_port
#
# then use the script in your tests like
# free_port 4444 65000

function free_port() {
	local portRangeStart=${1} && shift
	local portRangeEnd=${1} && shift

	for port in $(seq $portRangeStart $portRangeEnd); do
		echo -ne "\035" | telnet 127.0.0.1 $port > /dev/null 2>&1; [ $? -eq 1 ] && echo $port  && break;
	done
}

free_port "$@"
