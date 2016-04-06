#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_kmod-ifb is not set.*//g' .config
echo "CONFIG_PACKAGE_kmod-ifb=y" >> .config
