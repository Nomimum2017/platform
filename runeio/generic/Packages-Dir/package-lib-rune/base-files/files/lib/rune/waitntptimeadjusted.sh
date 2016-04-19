#!/bin/sh

echo "$0: waiting for NTP to set/adjust time"
date
while true; do
	if [ -f /tmp/ntp_time_adjusted.log ]; then
		break
	fi
	sleep 10
done
echo "$0: NTP has set/adjusted time"
date
rm -f /tmp/ntp_time_adjusted.log
exit 0
