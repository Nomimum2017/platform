#!/usr/bin/sh

exit 0
sed -i 's/.*CONFIG_PACKAGE_coreutils is not set.*//g' .config
echo "CONFIG_PACKAGE_coreutils=y" >> .config
