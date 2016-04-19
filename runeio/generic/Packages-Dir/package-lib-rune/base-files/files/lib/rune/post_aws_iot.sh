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

fileurl=`cat /tmp/wget.s3.posturl`

./publish_aws_iot_fileurl.sh "${fileurl}
rc=$?

if [ ${rc} -ne 0 ]; then
        echo "Failed to AWS-IOT publish of S3 URL. Ret-code: ${rc}"
        exit 5;
fi
exit 0
