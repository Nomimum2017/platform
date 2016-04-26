#!/bin/sh

globalhost="8.8.8.8"
runehost=""
echo "$0: checking for WAN to be ready"
date
echo "$0: Pinging ${globalhost}"
/bin/ping -c2 ${globalhost} &> /dev/null
if [ $? -eq 0 ]; then
	echo "$0: Host ${globalhost} is reachable"
	if [ "X${runehost}X" == "XX" ]; then
		exit 0
	else
		echo "$0: Pinging ${runehost}"
		/bin/ping -c2 ${runehost} &> /dev/null
		if [ $? -eq 0 ]; then
			echo "$0: Host ${runehost} is reachable"
			date
			exit 0
		else
			echo "Ping to ${runehost} failed"
		fi
	fi
else
	echo "Ping to ${globalhost} failed"
fi
exit 1
