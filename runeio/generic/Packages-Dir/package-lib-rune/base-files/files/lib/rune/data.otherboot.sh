#!/bin/sh

. /usr/share/libubox/jshn.sh
. /lib/rune/jshn.sh

ofile="/tmp/otherbootdata.dump"

json_init
json_add_string "Topic" "OtherBoot Data"
StringVal=`./macaddress.sh`
json_add_string "macaddr" "${StringVal}"
StringVal=`./versionBuildDate.sh`
json_add_string "BuildDate" "${StringVal}"
StringVal=`./versionBuilder.sh`
json_add_string "Built-By" ${StringVal}
StringVal=`./versionKernel.sh`
json_add_string "Kernel" "${StringVal}"
StringVal=`./wanipaddress.sh`
json_add_string "WAN IP address" ${StringVal}

msg1=`json_dump`
msg2=`ubus call system board`
jshn_append_json_struct "$msg1" "$msg2"
msg1=`json_dump`
msg2=`ubus call system info`
jshn_append_json_struct "$msg1" "$msg2"
json_dump > ${ofile}
echo "" >> ${ofile}
echo "Final json is: `json_dump`"
exit 0
