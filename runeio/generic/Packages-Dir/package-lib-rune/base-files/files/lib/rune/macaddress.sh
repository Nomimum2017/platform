#!/bin/sh
/sbin/ifconfig eth0 | /bin/grep -e 'eth0.*HWaddr' | /usr/bin/cut -f11 -d' '
