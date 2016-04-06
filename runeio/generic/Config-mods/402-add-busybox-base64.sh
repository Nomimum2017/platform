#!/usr/bin/sh

sed -i 's/.*CONFIG_BUSYBOX_DEFAULT_BASE64 is not set.*//g' .config
echo "CONFIG_BUSYBOX_DEFAULT_BASE64=y" >> .config
