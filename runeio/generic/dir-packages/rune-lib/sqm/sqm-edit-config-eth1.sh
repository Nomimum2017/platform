#!/bin/sh

sqm-split-conf.sh
rm /tmp/sqm.eth1
cp ${1} /tmp/sqm.eth1
