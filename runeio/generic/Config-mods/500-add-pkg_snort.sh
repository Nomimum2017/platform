#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_snort is not set.*//g' .config
echo "CONFIG_PACKAGE_snort=y" >> .config

