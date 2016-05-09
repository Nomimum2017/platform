#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_lua is not set.*//g' .config
echo "CONFIG_PACKAGE_lua=y" >> .config

echo "# CONFIG_PACKAGE_lua-examples is not set" >> .config

sed -i 's/.*CONFIG_PACKAGE_liblua is not set.*//g' .config
echo "CONFIG_PACKAGE_liblua=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_libubus-lua is not set.*//g' .config
echo "CONFIG_PACKAGE_libubus-lua=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_libuci-lua is not set.*//g' .config
echo "CONFIG_PACKAGE_libuci-lua=y" >> .config
