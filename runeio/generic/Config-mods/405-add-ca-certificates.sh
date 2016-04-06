#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_ca-certificates is not set.*//g' .config
echo "CONFIG_PACKAGE_ca-certificates=y" >> .config
