#!/usr/bin/sh

# Remove package QOS
sed -i 's/.*CONFIG_PACKAGE_qos-scripts=y.*//g' .config
echo "# CONFIG_PACKAGE_qos-scripts is not set" >> .config

# Remove package luci-app-QOS
sed -i 's/.*CONFIG_PACKAGE_luci-app-qos=y.*//g' .config
echo "# CONFIG_PACKAGE_luci-app-qos is not set" >> .config

# Add package SQM
sed -i 's/.*CONFIG_PACKAGE_sqm-scripts is not set.*//g' .config
echo "CONFIG_PACKAGE_sqm-scripts=y" >> .config
