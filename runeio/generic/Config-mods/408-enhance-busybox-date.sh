#!/usr/bin/sh

sed -i 's/.*CONFIG_BUSYBOX_DEFAULT_FEATURE_DATE_NANO.*//g' .config
echo "CONFIG_BUSYBOX_DEFAULT_FEATURE_DATE_NANO=y" >> .config
