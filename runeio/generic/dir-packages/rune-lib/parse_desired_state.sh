#!/bin/sh
# This file is expected to be 'source''ed from caller script

. /usr/share/libubox/jshn.sh

parse_desiredstatedoc_params () {
	json_select state
	json_select desired

	json_select firmware
	json_get_var new_firmware_build_epoch	build
	json_get_var new_firmware_path		path
	json_get_var new_firmware_md5		md5
	json_select ..

	json_select devfinger
	json_get_var new_devfinger_interval	interval
	json_select ..

	json_select netfinger
	json_get_var new_netfinger_interval	interval
	json_select ..

	json_select userconfig
	json_get_var new_userconfig_config	config
	json_get_var new_userconfig_interval	interval
	json_select ..

	json_select hids
	json_get_var new_hids_signature		signature
	json_get_var new_hids_sig_path		path
	json_get_var new_hids_sig_md5		md5
	json_get_var new_hids_interval		interval
	json_select ..

	json_select fw
	json_get_var new_fw_interval		interval
	json_select ..

	json_select proxy
	json_get_var new_proxy_interval		interval
	json_select ..

	json_select av
	json_get_var new_av_signature		signature
	json_get_var new_av_sig_path		path
	json_get_var new_av_sig_md5		md5
	json_get_var new_av_interval		interval
	json_select ..

	json_select dns
	json_get_var new_dns_interval		interval
	json_select ..

	json_select flow
	json_get_var new_flow_interval		interval
	json_select ..
}


desiredstatedoc="/tmp/desired_device_state.json"
if [ ! -e ${desiredstatedoc} ]; then
	echo "$0: Desired state doc: ${desiredstatedoc} not found"
	exit 1
fi
MSG=`cat ${desiredstatedoc}`
json_load "$MSG"

# parse_desiredstatedoc_params
