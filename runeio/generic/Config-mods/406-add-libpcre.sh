#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_libpcre is not set.*//g' .config
echo "CONFIG_PACKAGE_libpcre=y" >> .config
