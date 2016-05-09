#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_libiwinfo-lua is not set.*//g' .config
echo "CONFIG_PACKAGE_libiwinfo-lua=y" >> .config
