#!/bin/sh

if [ "X${1}X" == "XX" ]; then
	echo "No filename 1st param"
	exit 1;
fi

if [ ! -f ${1} ]; then
	echo "NO such file  ${1}"
	exit 2;
fi

echo "Compressing ${1} via gzip"
ls -al ${1}
gzip -f ${1}
echo "gzip RC: $?"
lfile=${1}.gz
ls -al ${lfile}
rfile=`basename ${lfile}`
./s3-upload-wget.sh -f ${lfile} -r ${rfile}
rc=$?
if [ ${rc} -ne 0 ]; then
	echo "Failed to do S3 upload. RC: ${rc}"
	exit 3;
fi

if [ ! -f /tmp/wget.s3.posturl ]; then
	echo "S3 Posted URL file at /tmp/wget.s3.posturl is Missing"
	exit 4;
fi

if [ ! -f /usr/certs/AWS_CONFIG_FILE ]; then
        echo "Credentials file  AWS_CONFIG_FILE in /usr/certs is Missing"
        exit 5;
fi

./publish_aws_iot_S3_posted_fileurl.sh
rc=$?
if [ ${rc} -ne 0 ]; then
        echo "Failed to AWS-IOT publish of S3 URL. Ret-code: ${rc}"
        exit 6;
fi
exit 0
