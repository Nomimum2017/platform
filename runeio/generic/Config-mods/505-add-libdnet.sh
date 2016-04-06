#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_libdnet is not set.*//g' .config
echo "CONFIG_PACKAGE_libdnet=y" >> .config
