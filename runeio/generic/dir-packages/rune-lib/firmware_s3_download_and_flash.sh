#!/bin/sh


usage() {
	echo "Usage: $0  -p <image-s3-path> -m <md5>"
	exit 1
}

if [ $# -lt 4 ]; then
	usage
fi

while [ $# -gt 1 ]; do
	case $1 in
		-p)	images3path="$2" ;;
		-m)	md5="$2" ;;
		-h)	usage ;;
		*)	usage ;;
	esac
	shift; shift
done

if [ -z ${images3path} ]; then
        echo "$0:  No image s3 path specified. Use: -i <image-s3-path>"
        exit 2
fi

if [ -z ${md5} ]; then
	echo "$0:  No md5 specified. Use: -m <md5>"
	exit 3
fi

pathprefix=$(echo ${images3path} | cut -f-2 -d'/')
pathsuffix=$(echo ${images3path} | cut -f2- -d'/')
awss3path=https://s3.amazonaws.com
if [ ${pathprefix} == "s3:/" ]; then
	images3path="${awss3path}${pathsuffix}"
fi
pathprefix=$(echo ${images3path} |  cut -f1-3 -d'/')
if [ ${pathprefix} != ${awss3path} ]; then
	echo "Non Amazon S3 URL"
	exit 4
fi


new_fw_image_file="/tmp/s3_downloaded_fw_image"
rm -f ${new_fw_image_file}
./s3-download-wget.sh -f ${new_fw_image_file} -u ${images3path}
rc=$?
if [ ${rc} -ne 0 ]; then
	echo "$0:  s3 download failed. code: ${rc}"
	exit ${rc}
fi

if [ ! -e ${new_fw_image_file} ]; then
	echo "$0:  unable to find downloaded firmware file: ${new_fw_image_file}"
	exit 5
fi

echo "File downloaded from s3:  `ls -al ${new_fw_image_file}`"

# flash it
./firmware_validate_and_flash.sh -i ${new_fw_image_file} -m ${md5}

exit $?
