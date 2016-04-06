#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_tc is not set.*//g' .config
echo "CONFIG_PACKAGE_tc=y" >> .config
