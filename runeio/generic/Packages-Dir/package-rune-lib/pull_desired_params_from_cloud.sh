#!/bin/sh

if [ ! -f /usr/certs/AWS_CONFIG_FILE ]; then
        echo "$0: Credentials file  AWS_CONFIG_FILE in /usr/certs is Missing"
        exit 1;
fi

source /usr/certs/AWS_CONFIG_FILE
subtopic="\$aws/things/${AWS_DEVICE_ID}/shadow/get/accepted"
pubtopic="\$aws/things/${AWS_DEVICE_ID}/shadow/get"
tmpfilename=/tmp/desired_device_state.json.tmp
finalfilename=/tmp/desired_device_state.json

msg=\"\"
/usr/bin/appsopenssl/subscribe_publish_sample  -S ${subtopic}  -P ${pubtopic}  \
	 -I ${AWS_DEVICE_ID}.listener -o ${tmpfilename} -h ${AWS_PUBLISH_HOST} \
	-p 8883 -c /usr/certs -x 1 -m ${msg}
rc=$?
if [ $? -ne 0 ]; then
	echo "$0: Failed to receive Desired-Device-State params from Cloud. AWS-IOT-Err: ${rc}"
	exit 2
fi
if [ ! -e ${tmpfilename} ]; then
	echo "$0: No output json doc in ${tmpfilename} found"
	exit 3 
fi
/bin/grep -q firmware ${tmpfilename}
if [ $? -ne 0 ]; then
        echo "$0: Invalid / missing parameters in ${tmpfilename}"
        exit 4
fi
rm -f ${finalfilename}.prev
mv -f ${finalfilename} ${finalfilename}.prev
mv -f ${tmpfilename} ${finalfilename}
echo "$0: Desired-Device-State json doc in: ${finalfilename}"
exit 0
