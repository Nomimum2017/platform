#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_libzlib is not set.*//g' .config
sed -i 's/.*CONFIG_PACKAGE_zlib is not set.*//g' .config
echo "CONFIG_PACKAGE_libzlib=y" >> .config
echo "CONFIG_PACKAGE_zlib=y" >> .config
