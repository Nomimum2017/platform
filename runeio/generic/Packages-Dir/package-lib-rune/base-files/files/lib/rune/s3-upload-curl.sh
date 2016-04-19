#!/bin/sh
#
# Upload a file to Amazon AWS S3 using Signature Version 4
#

usage() {
	echo "$0  -f <Local-File> -r <remote-File> -k <AWS-key> -s <AWS-secret> -b <AWS-bucket> -d <device-id>"
	exit 1
}

AWS_CONFIG_FILE=AWS_CONFIG_FILE
AWS_CONFIG_FILE=AWS_CONFIG_FILE
if [ -e "/usr/certs/${AWS_CONFIG_FILE}" ] ; then
	source "/usr/certs/${AWS_CONFIG_FILE}"
else
	if [ -e "/usr/${AWS_CONFIG_FILE}" ] ; then
		source "/usr/${AWS_CONFIG_FILE}"
	else
		if [ -e "./${AWS_CONFIG_FILE}" ] ; then
			source "./${AWS_CONFIG_FILE}"
		fi
	fi
fi

awsAccess="${AWS_ACCESS_KEY}"
awsSecret="${AWS_SECRET_KEY}"
awsBucket="${AWS_BUCKET}"
awsDeviceName="${AWS_DEVICE_ID}"
fileLocal=""
fileRemote=""

while [ $# -gt 1 ]; do
	case $1 in
		-f)	fileLocal="$2" ;;
		-r)	fileRemote="$2" ;;
		-k)	awsAccess="$2" ;;
		-s)	awsSecret="$2" ;;
		-b)	awsBucket="$2" ;;
		-d)	awsDeviceName="$2" ;;
		*)	usage; exit 1 ;;
	esac
	shift; shift
done

if [ -z ${fileLocal} ]; then
	echo "No Local File specified"
	usage
	exit 2
fi

if [ ! -e ${fileLocal} ]; then
        echo "Local file: ${fileLocal} not found"
        usage
        exit 2
fi

if [ -z ${fileRemote} ]; then
	fileRemote=${fileLocal}
fi

#echo "Key ${awsAccess}"
#echo "Secret ${awsSecret}"
#echo "Bucket ${awsBucket}"
#echo "Device ${awsDeviceName}"
#echo "File ${fileLocal} ${fileRemote}"

epochVal=$(($(date +%s%N)/1000000))
resource="/${awsBucket}/${awsDeviceName}/${epochVal}/${fileRemote}"
contentType="application/x-compressed-tar"
dateValue=`date -R`
echo "Uploading gzip-compressed File: " "${fileLocal}" "-> " "${resource}"

stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${awsSecret} -binary | base64`

posturl=https://${awsBucket}.s3.amazonaws.com/${awsDeviceName}/${epochVal}/${fileRemote}
echo "${posturl}" > /tmp/curl.s3.posturl
# Upload


curl -L -X PUT -T "${fileLocal}" \
  -H "Host: ${awsBucket}.s3.amazonaws.com" \
  -H "Date: ${dateValue}" \
  -H "Content-Type: ${contentType}" \
  -H "Authorization: AWS ${awsAccess}:${signature}" \
  -H "x-amz-acl: bucket-owner-full-control" \
  ${posturl}

echo -e "\nReturn code is: $?"
