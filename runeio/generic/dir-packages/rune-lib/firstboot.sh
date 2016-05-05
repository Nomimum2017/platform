#!/bin/sh

cd /lib/rune/

ofile="/tmp/firstbootdata.dump"
if [ -f ${ofile} ]; then
	echo "File: ${ofile} exists"
	exit 1
fi

# Generate data as soon as system started.  Posting may be delayed until Networks are up

./waitconnectivity.sh
./waitntptimeadjusted.sh
./data.firstboot.sh

if [ ! -f ${ofile} ]; then
	exit 2
fi

./post_aws_iot.sh ${ofile} 
echo "post_aws_iot.sh  returned $? called from $0"

# Kick off other Rune System activities
echo "$0: Starting rune_manager.sh"
./rune_manager.sh
echo "$0:  Done with rune_manager.sh RC: $?"
exit 0
