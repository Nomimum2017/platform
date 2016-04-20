#!/bin/sh

donothing () {
}

firmware_upgrade () {

}

hids_signature_upgrade () {

}

av_signature_upgrade () {

}

dns_whitelist_upgrade () {

}

change_firmware_build_epoch () {

}

change_firmware_path () {
	firmware_upgrade
}

change_firmware_md5 () {
	donothing
}

change_devfinger_interval () {

}

change_netfinger_interval () {

}

change_hids_signature () {
        donothing
}

change_hids_sig_path () {
	hids_signature_upgrade
}

change_hids_sig_md5 () {
        donothing
}

change_hids_interval () {

}

change_fw_interval () {

}

change_proxy_interval () {

}

change_av_signature () {
        donothing
}

change_av_sig_path () {
	av_signature_upgrade
}

change_av_sig_md5 () {
        donothing
}

change_av_interval () {

}

change_dns_interval () {

}

change_dns_whitelist_path () {
	dns_whitelist_upgrade
}

change_flow_interval () {

}

compare_process_param_change () {
	old_val=${${1}}
	new_val=${new_${1}}
	call_func=change_${1}
	msg=${3}

	if [ ${new_val} != ${old_val} ]; then
		echo "$0: Desired State param ${msg} changed to ${new_val} from ${old_val}"
		${1}=${new_val}
		${call_func}
	fi
}

. /lib/rune/parse_desired_state.sh
parse_desiredstatedoc_params

params_list=( firmware_build_epoch firmware_path firmware_md5 devfinger_interval netfinger_interval hids_signature hids_sig_path hids_sig_md5 hids_interval fw_interval proxy_interval av_signature av_sig_path av_sig_md5 av_interval dns_interval flow_interval )

params_names_list=( 'Firmware Build epoch' 'Firmware Build path' 'Firmware md5' 'DevFinger interval' 'NetFinger interval' 'HIDS signature' 'HIDS signature path' 'HIDS signature md5' 'HIDS interval' 'FW interval' 'Proxy interval' 'AV signature' 'AV signature path' 'AV signature md5' 'AV interval' 'DNS interval' 'Flow interval' )

params_list_len=${#params_list[@]}
params_names_list_len=$(#params_names_list[$]}

if [ ${params_list_len} != ${params_names_list_len} ]; then
	echo "Mismatched array sizes.  params_list:${params_list_len}  and params_names_list:${params_names_list_len}"
	exit 1
fi

for (( i=0; i<${params_list_len}; i++ ));
do
  compare_process_param_change ${params_list[$i]} ${params_names_list[$i]}
done
