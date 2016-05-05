#!/bin/sh

usage() {
	echo "Usage: $0  -i <image-file> -m <md5>"
	exit 1
}

uncompress() {
	infile=$1
	outfile=$2
	gunzip -c ${infile} > ${outfile}
	if [ $? -ne 0 ]; then
		echo "Unable to uncompress ${infile} to ${outfile}"
		exit 5
	fi
	if [ ! -e ${outfile} ]; then
		echo "Unable to find uncompressed file ${outfile}"
		exit 6
	fi
}


if [ $# -lt 4 ]; then
	usage
fi

while [ $# -gt 1 ]; do
	case $1 in
		-i)	imagefile="$2" ;;
		-m)	md5="$2" ;;
		-h)	usage ;;
		*)	usage ;;
	esac
	shift; shift
done

if [ -z ${imagefile} ]; then
        echo "$0:  No filename specified. Use: -i <imagefile>"
        exit 2
fi

if [ -z ${md5} ]; then
	echo "$0:  No md5 specified. Use: -m <md5>"
	exit 3
fi

if [ ! -e ${imagefile} ]; then
        echo "$0:  unable to find image file ${imagefile}"
        exit 4
fi

case "${imagefile}" in
	*.gz)  # it's gzipped;
		echo "Decompressing Firmware file ${imagefile} is compressed"
		uncmpfile=/tmp/$(basename ${imagefile}).uncomp
		uncompress ${imagefile}  ${uncmpfile}
		imagefile=${uncmpfile}
		;;

	*.bin) # it is a bin file;
		echo "Image file is a .bin file"
		;;
	*)	# something else
		filehdr=$(dd if=${imagefile} bs=1 count=3)
		gziphdr=$(echo -n -e "\x1f\x8b\x08")
		if [ ${filehdr} != ${gziphdr} ]; then
			echo "Only gzip compressed firmware file or .bin file are allowed for flashing"
			exit 7
		fi
		uncmpfile=/tmp/$(basename ${imagefile}).uncomp
		uncompress ${imagefile} ${uncmpfile}
		imagefile=${uncmpfile}
		;;
esac

imagemd5=$(md5sum ${imagefile} | cut -d' ' -f1)
if [ ${md5} != ${imagemd5} ]; then
	echo "$0: md5 mismatch.  image ${imagefile} md5: ${imagemd5}   Param md5: ${md5}"
	exit 8
fi

# sanity check the image file

# 	Get machine type
boardname=$(cat /tmp/sysinfo/board_name)
boardmodel=$(cat /tmp/sysinfo/model)

#	Get image header bytes
magic_word=$(dd if=${imagefile} bs=2 count=1 | hexdump -v -n 2 -e '1/1 "%02x"') 2> /dev/null
magic_long=$(dd if=${imagefile} bs=4 count=1 | hexdump -v -n 4 -e '1/1 "%02x"') 2> /dev/null
let imagesize=$(wc -c ${imagefile} | cut -f1 -d' ')

#	Verify this platform string is supported, and image header is sane
case ${boardname} in
	gl_ar150 | \
	nothingelse )
		if [ "${magic_word}" != "2705" ]; then
			echo "Invalid image type."
			exit 10
		fi
		if [ ${imagesize} -lt 7400000 ]; then
			echo "Invalid image size. ${imagesize} should be greater than 7400000"
			exit 11
		fi	
		if [ ${imagesize} -gt 9000000 ]; then
			echo "Invalid image size. ${imagesize} should be less than 9000000"
			exit 12
		fi
		;;
	*)
		echo "Unsupported platform ${boardname}"
		exit 13
		;;
esac

# flash it
echo "$0: Flashing file: ${imagefile}"

set -x
mtd -r write ${imagefile} firmware
rc=$?
set - -x
echo "$0: Done Flashing"
exit ${rc}
