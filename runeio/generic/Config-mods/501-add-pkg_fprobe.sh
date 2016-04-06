#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_fprobe is not set.*//g' .config
echo "CONFIG_PACKAGE_fprobe=y" >> .config

