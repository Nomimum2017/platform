#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_nmap is not set.*//g' .config
echo "CONFIG_PACKAGE_nmap=y" >> .config
sed -i 's/.*CONFIG_PACKAGE_nmap-ssl is not set.*//g' .config
echo "CONFIG_PACKAGE_nmap-ssl=y" >> .config
