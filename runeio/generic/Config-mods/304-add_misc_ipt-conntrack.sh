#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_iptables-mod-ipopt is not set.*//g' .config
echo "CONFIG_PACKAGE_iptables-mod-ipopt=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_iptables-mod-conntrack-extra is not set.*//g' .config
echo "CONFIG_PACKAGE_iptables-mod-conntrack-extra=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_kmod-ipt-ipopt is not set.*//g' .config
echo "CONFIG_PACKAGE_kmod-ipt-ipopt=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_kmod-ipt-conntrack-extra is not set.*//g' .config
echo "CONFIG_PACKAGE_kmod-ipt-conntrack-extra=y" >> .config
