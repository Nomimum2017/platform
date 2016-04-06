#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_ip is not set.*//g' .config
echo "CONFIG_PACKAGE_ip=y" >> .config
