#!/bin/sh

sqm-split-conf.sh
rm /tmp/sqm.eth0
cp ${1} /tmp/sqm.eth0

sqm-rebuild-conf.sh
