#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_kmod-sched is not set.*//g' .config
echo "CONFIG_PACKAGE_kmod-sched=y" >> .config

sed -i 's/.*CONFIG_PACKAGE_kmod-sched-core is not set.*//g' .config
echo "CONFIG_PACKAGE_kmod-sched-core=y" >> .config
