#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_uhttpd is not set.*//g' .config
echo "CONFIG_PACKAGE_uhttpd=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_uhttpd-mod-ubus is not set.*//g' .config
echo "CONFIG_PACKAGE_uhttpd-mod-ubus=y" >> .config
