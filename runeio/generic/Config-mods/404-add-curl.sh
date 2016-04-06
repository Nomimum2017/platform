#!/usr/bin/sh

sed -i 's/.*CONFIG_PACKAGE_curl is not set.*//g' .config
echo "CONFIG_PACKAGE_curl=y" >> .config
sed -i 's/.*CONFIG_PACKAGE_libcurl is not set.*//g' .config
echo "CONFIG_PACKAGE_libcurl=y" >> .config
echo "CONFIG_LIBCURL_OPENSSL=y" >> .config
echo "CONFIG_LIBCURL_VERBOSE=y" >> .config
echo "CONFIG_LIBCURL_CRYPTO_AUTH=y" >> .config
echo "CONFIG_LIBCURL_HTTP=y" >> .config
