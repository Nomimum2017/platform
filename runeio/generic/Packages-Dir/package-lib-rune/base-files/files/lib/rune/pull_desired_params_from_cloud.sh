#!/bin/sh

if [ ! -f /usr/certs/AWS_CONFIG_FILE ]; then
        echo "$0: Credentials file  AWS_CONFIG_FILE in /usr/certs is Missing"
        exit 1;
fi

source /usr/certs/AWS_CONFIG_FILE
subtopic="$aws/things/<thing-name>/shadow/get/accepted"
pubtopic="$aws/things/<thing-name>/shadow/get"
tmpfilename=/tmp/desired_state.tmp

msg="{\"msg\":\"\"}"
/usr/bin/appsopenssl/subscribe_publish_sample  -S ${subtopic} -I ${AWS_DEVICE_ID}  -h ${AWS_PUBLISH_HOST} -p 8883 -c /usr/certs -x 10 -m ${msg} &> ${tmpfilename} &
subpid=$!
sleep 1
/usr/bin/appsopenssl/subscribe_publish_sample  -P ${pubtopic} -I ${AWS_DEVICE_ID}  -h ${AWS_PUBLISH_HOST} -p 8883 -c /usr/certs -x 1 -m ${msg}
if [ $? -ne 0 ]; then
	echo "$0: Failed to publish Get-Req on Topic: ${pubtopic}."
	exit 2
fi
sleep 1
kill ${subpid}
sleep 1

/bin/grep firmware ${tmpfilename}
if [ $? -ne 0 ]; then
	echo "$0: Failed to retreive Device-Desired-Parameters from Cloud-Server. Failed file in ${tmpfilename}"
	exit 3
fi
filename=/tmp/desired_state.$(($(date +%s%N)/1000000)) 
linkfile=/tmp/desired_state.curr

rm -f ${linkfile}
rm -f ${filename}.prev
mv -f ${filename} ${filename}.prev
mv -f ${tmpfilename} ${filename}
ln -sf ${filename} ${linkfile}
echo "Desired state document is in ${linkfile} -- ${filename}"
exit 0
