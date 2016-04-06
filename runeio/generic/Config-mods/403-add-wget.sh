#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_wget is not set.*//g' .config
sed -i 's/.*CONFIG_BUSYBOX_DEFAULT_WGET=y.*//g' .config
sed -i 's/.*CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_STATUSBAR=y.*//g' .config
sed -i 's/.*CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_AUTHENTICATION=y.*//g' .config
sed -i 's/.*CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_LONG_OPTIONS=y.*//g' .config

echo "CONFIG_PACKAGE_wget=y" >> .config
echo "#CONFIG_BUSYBOX_DEFAULT_WGET is not set" >> .config
echo "#CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_STATUSBAR is not set" >> .config
echo "#CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_AUTHENTICATION is not set" >> .config
echo "#CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_LONG_OPTIONS is not set" >> .config
