
vpath %.c aws_iot_src/shadow
vpath %.c aws_iot_src/utils
vpath %.c aws_iot_src/protocol/mqtt/aws_iot_embedded_client_wrapper
vpath %.c aws_iot_src/protocol/mqtt/aws_iot_embedded_client_wrapper/platform_linux/common
vpath %.c aws_iot_src/protocol/mqtt/aws_iot_embedded_client_wrapper/platform_linux/openssl
vpath %.c aws_iot_src/protocol/mqtt/aws_iot_embedded_client_wrapper/platform_linux/mbedtls
vpath %.c aws_mqtt_embedded_client_lib/MQTTPacket/src
vpath %.c aws_mqtt_embedded_client_lib/MQTTClient-C/src

OBJ_COMMON=	aws_iot_shadow.o \
			aws_iot_shadow_records.o \
			aws_iot_shadow_json.o \
			aws_iot_shadow_actions.o \
			jsmn.o \
			aws_iot_json_utils.o \
			aws_iot_mqtt_embedded_client_wrapper.o \
			timer.o \

OBJ_OPENSSL=hostname_compare.o \
			network_openssl_wrapper.o \
			rawstr.o \
			openssl_hostname_validation.o \

OBJ_MBEDTLS=network_mbedtls_wrapper.o

OBJ_MQTT=	MQTTConnectClient.o \
			MQTTSerializePublish.o \
			MQTTDeserializePublish.o \
			MQTTPacket.o \
			MQTTUnsubscribeClient.o \
			MQTTSubscribeClient.o \
			MQTTClient.o \

OBJS_OPENSSL=$(addprefix bin/objopenssl/, $(OBJ_COMMON) $(OBJ_OPENSSL) $(OBJ_MQTT))

OBJS_MBEDTLS=$(addprefix bin/objmbedtls/, $(OBJ_COMMON) $(OBJ_MBEDTLS) $(OBJ_MQTT))

INCLUDE=	-I config \
			-I aws_iot_src/utils \
			-I aws_iot_src/protocol/mqtt \
			-I aws_iot_src/protocol/mqtt/aws_iot_embedded_client_wrapper \
			-I aws_iot_src/protocol/mqtt/aws_iot_embedded_client_wrapper/platform_linux/common \
			-I aws_mqtt_embedded_client_lib/MQTTPacket/src \
			-I aws_mqtt_embedded_client_lib/MQTTClient-C/src \

TLSINCL=	-I mbedtls_lib/include

all: libs apps

libs: prepare $(OBJS_OPENSSL) $(OBJS_MBEDTLS) static

prepare:
	mkdir -p bin/objopenssl bin/objmbedtls bin/appsopenssl bin/appsmbedtls bin/include
	cp -f $(shell find aws_iot_src -name *.h) bin/include

bin/objopenssl/%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $< $(INCLUDE)

bin/objmbedtls/%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $< $(INCLUDE) $(TLSINCL)

static: bin/awsiotsdkopenssl.a bin/awsiotsdkmbedtls.a

bin/awsiotsdkopenssl.a: $(OBJS_OPENSSL)
	$(AR) rc $@ bin/objopenssl/*.o
	$(AR) s $@

bin/awsiotsdkmbedtls.a: $(OBJS_MBEDTLS)
	make -C mbedtls_lib/library
	cp -f mbedtls_lib/library/*.o bin/objmbedtls
	$(AR) rc $@ bin/objmbedtls/*.o
	$(AR) s $@

# Logging level control
LOG_FLAGS += -DIOT_DEBUG
LOG_FLAGS += -DIOT_INFO
LOG_FLAGS += -DIOT_WARN
LOG_FLAGS += -DIOT_ERROR

APPS=shadow_sample shadow_console_echo subscribe_publish_sample

APPS_OPENSSL=$(addprefix bin/appsopenssl/, $(APPS))

APPS_MBEDTLS=$(addprefix bin/appsmbedtls/, $(APPS))

apps: libs $(APPS_OPENSSL) $(APPS_MBEDTLS)

bin/appsopenssl/%: sample_apps/*/%.c
	$(CC) $(CFLAGS) $(LOG_FLAGS) -g -o $@ $< -I bin/include bin/awsiotsdkopenssl.a -ldl -lssl -lcrypto

bin/appsmbedtls/%: sample_apps/*/%.c
	$(CC) $(CFLAGS) $(LOG_FLAGS) -g -o $@ $< -I bin/include bin/awsiotsdkmbedtls.a

clean:
	rm -rf bin

