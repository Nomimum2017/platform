#!/bin/sh

check_epoch_file () {
	if [ ! -e ${1} ]; then
		echo "$0: epoch file: ${1} Not found"
		exit 1
	fi
}

sqmconf=/etc/config/sqm

rm -f ${sqmconf}

sqm0epoch=/tmp/sqm.config.epoch.eth0
sqm1epoch=/tmp/sqm.config.epoch.eth1
sqm0conf=/tmp/config.sqm.eth0
sqm1conf=/tmp/config.sqm.eth1

if [ -e ${sqm0conf} ]; then
	check_epoch_file ${sqm0epoch}
	echo -n "#  " >> ${sqmconf}
	cat ${sqm0epoch} >> ${sqmconf}
	echo " " >> ${sqmconf}
	cat ${sqm0conf} >> ${sqmconf}
	echo " " >> ${sqmconf}
else
	if [ ! -e ${sqm1conf} ]; then
		echo "$0: Neither of SQM configs for eth0 or eth1 exist"
		exit 2
	fi
fi

if [ -e ${sqm1conf} ]; then
	check_epoch_file ${sqm1epoch}
	echo -n "#  " >> ${sqmconf}
	cat ${sqm1epoch} >> ${sqmconf}
	echo " " >> ${sqmconf}
	cat ${sqm1conf} >> ${sqmconf}
	echo " " >> ${sqmconf}
fi
