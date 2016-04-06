#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_sqm-scripts is not set.*//g' .config
echo "CONFIG_PACKAGE_sqm-scripts=y" >> .config
