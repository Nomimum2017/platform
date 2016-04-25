include $(TOPDIR)/rules.mk

PKG_NAME:=aws-iot-sdk
PKG_VERSION:=1.1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=linux_mqtt_mbedtls-$(PKG_VERSION).tar
PKG_SOURCE_URL:=https://s3.amazonaws.com/aws-iot-device-sdk-embedded-c/

UNPACK_CMD=cat "$(DL_DIR)/$(PKG_SOURCE)" | tar -C "$(PKG_BUILD_DIR)" -xf -

include $(INCLUDE_DIR)/package.mk

define Package/aws-iot-sdk-apps
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+aws-iot-sdk
  TITLE+=AWS IoT Embedded-C SDK Sample Applications
endef

define Package/aws-iot-sdk
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libc +librt +libpthread +libopenssl
  TITLE:=AWS IoT Embedded-C SDK
  URL:=https://s3.amazonaws.com/aws-iot-device-sdk-embedded-c/
endef

define Package/aws-iot-sdk/description
 The AWS IoT device SDK for embedded C is a collection of C source files which
 can be used in embedded applications to securely connect to the AWS IoT platform.
 It includes transport clients (MQTT), TLS implementations and examples for their use.
 It also supports AWS IoT specific features such as Thing Shadow.
endef

define Package/aws-iot-sdk/config
	source "$(SOURCE)/Config-sdk.in"
endef

define Package/aws-iot-sdk-apps/config
	source "$(SOURCE)/Config-app.in"
endef

define Build/Prepare
    $(Build/Prepare/Default)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

TARGET_CFLAGS += -DAWS_IOT_MQTT_HOST=\\\"$(CONFIG_AWS_IOT_MQTT_HOST)\\\"
TARGET_CFLAGS += -DAWS_IOT_MQTT_PORT=$(CONFIG_AWS_IOT_MQTT_PORT)
TARGET_CFLAGS += -DAWS_IOT_MQTT_CLIENT_ID=\\\"$(CONFIG_AWS_IOT_MQTT_CLIENT_ID)\\\"
TARGET_CFLAGS += -DAWS_IOT_MY_THING_NAME=\\\"$(CONFIG_AWS_IOT_MY_THING_NAME)\\\"

TARGET_CFLAGS += -DAWS_IOT_MQTT_TX_BUF_LEN=$(CONFIG_AWS_IOT_MQTT_TX_BUF_LEN)
TARGET_CFLAGS += -DAWS_IOT_MQTT_RX_BUF_LEN=$(CONFIG_AWS_IOT_MQTT_RX_BUF_LEN)
TARGET_CFLAGS += -DAWS_IOT_MQTT_NUM_SUBSCRIBE_HANDLERS=$(CONFIG_AWS_IOT_MQTT_NUM_SUBSCRIBE_HANDLERS)
TARGET_CFLAGS += -DSHADOW_MAX_SIZE_OF_RX_BUFFER=$(CONFIG_SHADOW_MAX_SIZE_OF_RX_BUFFER)
TARGET_CFLAGS += -DMAX_SIZE_OF_UNIQUE_CLIENT_ID_BYTES=$(CONFIG_MAX_SIZE_OF_UNIQUE_CLIENT_ID_BYTES)
TARGET_CFLAGS += -DMAX_SIZE_CLIENT_ID_WITH_SEQUENCE=$(CONFIG_MAX_SIZE_CLIENT_ID_WITH_SEQUENCE)
TARGET_CFLAGS += -DMAX_SIZE_CLIENT_TOKEN_CLIENT_SEQUENCE=$(CONFIG_MAX_SIZE_CLIENT_TOKEN_CLIENT_SEQUENCE)
TARGET_CFLAGS += -DMAX_ACKS_TO_COMEIN_AT_ANY_GIVEN_TIME=$(CONFIG_MAX_ACKS_TO_COMEIN_AT_ANY_GIVEN_TIME)
TARGET_CFLAGS += -DMAX_THINGNAME_HANDLED_AT_ANY_GIVEN_TIME=$(CONFIG_MAX_THINGNAME_HANDLED_AT_ANY_GIVEN_TIME)
TARGET_CFLAGS += -DMAX_JSON_TOKEN_EXPECTED=$(CONFIG_MAX_JSON_TOKEN_EXPECTED)
TARGET_CFLAGS += -DMAX_SHADOW_TOPIC_LENGTH_WITHOUT_THINGNAME=$(CONFIG_MAX_SHADOW_TOPIC_LENGTH_WITHOUT_THINGNAME)
TARGET_CFLAGS += -DMAX_SIZE_OF_THING_NAME=$(CONFIG_MAX_SIZE_OF_THING_NAME)
TARGET_CFLAGS += -DMAX_SHADOW_TOPIC_LENGTH_BYTES=$(CONFIG_MAX_SHADOW_TOPIC_LENGTH_BYTES)

TARGET_CFLAGS += -DAWS_IOT_ROOT_CA_FILENAME=\\\"$(CONFIG_AWS_IOT_ROOT_CA_FILENAME)\\\"
TARGET_CFLAGS += -DAWS_IOT_CERTIFICATE_FILENAME=\\\"$(CONFIG_AWS_IOT_CERTIFICATE_FILENAME)\\\"
TARGET_CFLAGS += -DAWS_IOT_PRIVATE_KEY_FILENAME=\\\"$(CONFIG_AWS_IOT_PRIVATE_KEY_FILENAME)\\\"
TARGET_CFLAGS += -DAWS_IOT_MQTT_MAX_RECONNECT_WAIT_INTERVAL=$(CONFIG_AWS_IOT_MQTT_MAX_RECONNECT_WAIT_INTERVAL)
TARGET_CFLAGS += -DAWS_IOT_MQTT_MIN_RECONNECT_WAIT_INTERVAL=$(CONFIG_AWS_IOT_MQTT_MIN_RECONNECT_WAIT_INTERVAL)
TARGET_CFLAGS += -DREVERSED

define Build/Compile
	echo "Building  $(PKG_NAME) in $(PKG_BUILD_DIR)"
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/bin/include/* $(1)/usr/include/
	mkdir -p $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/bin/*.a $(1)/usr/lib/
endef

define Package/aws-iot-sdk-apps/install
	$(INSTALL_DIR) $(1)/usr/bin/appsmbedtls
	$(INSTALL_DIR) $(1)/usr/bin/appsopenssl
	$(CP) $(PKG_BUILD_DIR)/bin/appsmbedtls/* $(1)/usr/bin/appsmbedtls
	$(CP) $(PKG_BUILD_DIR)/bin/appsopenssl/* $(1)/usr/bin/appsopenssl
endef

$(eval $(call BuildPackage,aws-iot-sdk-apps))
$(eval $(call BuildPackage,aws-iot-sdk))
