#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_libopenssl is not set.*//g' .config
sed -i 's/.*CONFIG_PACKAGE_openssl-util is not set.*//g' .config
echo "CONFIG_PACKAGE_libopenssl=y" >> .config
echo "CONFIG_OPENSSL_WITH_EC=y" >> .config
echo "CONFIG_PACKAGE_openssl-util=y" >> .config
