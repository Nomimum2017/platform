#!/bin/sh

while true; do
	./checkwannetworkready.sh
	if [ $? -eq 0 ]; then
		break
	fi
	sleep 15
done
exit 0
