#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_luci is not set.*//g' .config
echo "CONFIG_PACKAGE_luci=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_luci-base is not set.*//g' .config
echo "CONFIG_PACKAGE_luci-base=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_luci-mod-admin-full is not set.*//g' .config
echo "CONFIG_PACKAGE_luci-mod-admin-full=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_luci-app-firewall is not set.*//g' .config
echo "CONFIG_PACKAGE_luci-app-firewall=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_luci-theme-bootstrap is not set.*//g' .config
echo "CONFIG_PACKAGE_luci-theme-bootstrap=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_luci-proto-ipv6 is not set.*//g' .config
echo "CONFIG_PACKAGE_luci-proto-ipv6=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_luci-proto-ppp is not set.*//g' .config
echo "CONFIG_PACKAGE_luci-proto-ppp=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_luci-lib-ip is not set.*//g' .config
echo "CONFIG_PACKAGE_luci-lib-ip=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_luci-lib-nixio is not set.*//g' .config
echo "CONFIG_PACKAGE_luci-lib-nixio=y" >> .config
