#!/bin/sh

/bin/echo -n "NTP Hotplug Time adjusted action ${1} - ${ACTION} at " > /tmp/ntp_time_adjusted.log
/bin/date >> /tmp/ntp_time_adjusted.log
exit 0
