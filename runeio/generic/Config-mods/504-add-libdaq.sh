#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_libdaq is not set.*//g' .config
echo "CONFIG_PACKAGE_libdaq=y" >> .config
