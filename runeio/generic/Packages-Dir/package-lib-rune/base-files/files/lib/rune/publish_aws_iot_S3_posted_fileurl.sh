#!/bin/sh

if [ ! -f /tmp/wget.s3.posturl ]; then
        echo "S3 Posted URL file at /tmp/wget.s3.posturl is Missing"
        exit 1;
fi

if [ ! -f /usr/certs/AWS_CONFIG_FILE ]; then
        echo "Credentials file  AWS_CONFIG_FILE in /usr/certs is Missing"
        exit 2;
fi

source /usr/certs/AWS_CONFIG_FILE
pubtopic="device/upload"
msg="{\"msg\":\"`cat /tmp/wget.s3.posturl`\"}"
/usr/bin/appsopenssl/subscribe_publish_sample  -P ${pubtopic} -I ${AWS_DEVICE_ID}  -h ${AWS_PUBLISH_HOST} -p 8883 -c /usr/certs -x 2 -m ${msg}
rc=$?
if [ ${rc} -ne 0 ]; then
        echo "Failed to do AWS Topic Publish to topic: ${2}. RC: ${rc}"
fi
exit ${rc}
