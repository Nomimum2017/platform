#!/bin/sh
#
# Upload a file to Amazon AWS S3 using Signature Version 4
#

usage() {
	echo "Usage:  $0  [ -f <Local-File> ]  -u <AWS-URL>"
	echo "            [ -k <AWS-key> -s <AWS-secret> -b <AWS-bucket> ]"
	exit 1
}

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

fileLocal="/tmp/temps3downloadedfile"
#geturl="https://s3.amazonaws.com/rune-alpha-firmware/1461729710/firmware.gz"

while [ $# -gt 1 ]; do
	case $1 in
		-f)     fileLocal="$2" ;;
		-u)     geturl="$2" ;;
                -k)     awsAccess="$2" ;;
                -s)     awsSecret="$2" ;;
                -b)     awsBucket="$2" ;;
		-h)	usage ;;
                *)      usage ;;
        esac
        shift; shift
done

if [ -z ${geturl} ]; then
        echo "$0: ** No remote URL specified.  Use -u url"
        usage
        exit 3
fi

echo "GetURL = ${geturl}"
amzFile=`echo ${geturl} | cut -d'/' -f4-`
amzHost=`echo ${geturl} | cut -d'/' -f-3`
echo "S3 File path: ${amzFile}"
echo "S3 Host-Bucket: ${amzHost}"
if [ ${amzHost} != "https://s3.amazonaws.com" ]; then
	echo "$0: ** Bad S3 URL.  Unable to handle non-Amazon non-S3 urls"
	exit 4
fi
resource="/${amzFile}"
contentType="application/x-compressed-tar"
dateValue=`date -R`
stringToSign="GET\n\n${contentType}\n${dateValue}\n${resource}"
awsAccess=${AWS_ACCESS_KEY}
awsSecret="${AWS_SECRET_KEY}"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${awsSecret} -binary | base64`

wget	--verbose \
	--method=GET \
	--header="Expect: 100-continue" \
	--header="Date: ${dateValue}" \
	--header="Content-Type: ${contentType}" \
	--header="Authorization: AWS ${awsAccess}:${signature}" \
	-O ${fileLocal} \
	${geturl}

rc=$?
echo -e "\n$0:  Return code is: ${rc}"
exit ${rc}

#curl	-H "Host: s3.amazonaws.com" \
#	-H "Date: ${dateValue}" \
#	-H "Content-Type: ${contentType}" \
#	-H "Authorization: AWS ${awsAccess}:${signature}" \
#	${geturl} -o ${fileLocal}
#
