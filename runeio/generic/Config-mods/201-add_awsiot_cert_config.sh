#!/bin/sh
cat <<EOF  >> .config
#
# Configuration
#
CONFIG_AWS_IOT_ROOT_CA_FILENAME="Rune-ROOT-CA-cert.pem"
CONFIG_AWS_IOT_CERTIFICATE_FILENAME="Rune-EndDevice-cert.pem"
CONFIG_AWS_IOT_PRIVATE_KEY_FILENAME="Rune-EndDevice-prikey.pem"
EOF
