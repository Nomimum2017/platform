#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_libstdcpp is not set.*//g' .config
echo "CONFIG_PACKAGE_libstdcpp=y" >> .config
