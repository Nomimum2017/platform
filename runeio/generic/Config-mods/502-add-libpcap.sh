#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_libpcap is not set.*//g' .config
echo "CONFIG_PACKAGE_libpcap=y" >> .config
