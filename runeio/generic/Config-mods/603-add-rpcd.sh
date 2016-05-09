#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_rpcd is not set.*//g' .config
echo "CONFIG_PACKAGE_rpcd=y" >> .config
