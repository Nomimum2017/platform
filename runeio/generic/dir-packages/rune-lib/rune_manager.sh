#!/bin/sh

# this device (glar150) system has 'bourne' shell.
# the system runs 'ash' which is a busybox implementation of 'sh'

# as opposed to 'bash',  'sh' does not have arrays.



initialize_sys_var_from_system() {
	firmware_build_epoch=`./versionBuildDate.sh | cut -d' ' -f4`
}

donothing() {
	echo "donothing"
}

action_firmware_upgrade_check() {
	donothing
	echo "Firmware upgrade check and process"
	if [ ${new_firmware_build_epoch} -gt ${firmware_build_epoch} ]; then
		echo "Flashing"

#		./firmware_s3_download_and_flash.sh \
#			${new_firmware_path} ${new_firmware_md5}

	fi
	echo "Done Firmware upgrade"
}

action_scan_arp() {
	donothing
}

action_scan_nmap() {
	donothing
}

action_scan_hids_signature_check() {
	donothing
}

action_scan_hids_log_push() {
	donothing
}

action_scan_fw_log_push() {
	donothing
}

action_scan_fw_log_push() {
	donothing
}

action_scan_proxy_log_push() {
	donothing
}

action_scan_av_signature_check() {
	donothing
}

action_scan_av_log_push() {
	donothing
}

action_scan_dns_log_push() {
	donothing
}

action_scan_flow_log_push() {
	donothing
}

check_each_desired_device_param() {
	for i in `seq 1 ${params_list_len}`; do
		a=param_$i
		b=param_name_$i
		pvar=$(eval echo \$$a)
		pname=$(eval echo \$$b)
		compare_process_param_change $pvar "$pname"
	done
}

compare_process_param_change () {
	old_val=$(eval echo \$$1)
#	echo "$1 : $old_val"
	a=new_${1}
	new_val=$(eval echo \$$a)
#	echo "$a : $new_val"
#	call_func=change_${1}
	msg=${2}

	if [ ${new_val} != ${old_val} ]; then
		echo "$0: Desired State param ${msg} changed to ${new_val} from ${old_val}"
#		eval ${1}=${new_val}
		# We save changes here in tmp_params_reload file
		#   will read-in values into core variables at end of proc loop
		echo "${1}=${new_val}" >> ${rune_params_reload}
#		echo "var: $1 is now set to $(eval echo \$$1)"
	fi
}



# Task 0 pull_device_params  is a special case. It is hard-coded to be
#     spawned at each loop entry.  feature list is checked from index 1 onwards

feature_0=update_device_desired_params
feature_0_name="rune-update-device-desired-params-download"
feature_0_interval_str="device_checkin_interval"

feature_1=firmware_upgrade_check
feature_1_name="rune-firmware-upgrade-check"
feature_1_interval_str="firmware_upgrade_check_interval"

feature_2=scan_arp
feature_2_name="arp-scan-finger"
feature_2_interval_str="devfinger_interval"

feature_3=scan_nmap
feature_3_name="net-scan-nmap"
feature_3_interval_str="netfinger_interval"

feature_4=hids_signature_check
feature_4_name="rune-hids-signature-check"
feature_4_interval_str="hids_signature_upgrade_interval"

feature_5=hids_log_push
feature_5_name="rune-hids-log-report-push"
feature_5_interval_str="hids_interval"

feature_6=fw_log_push
feature_6_name="rune-firewall-log-report-push"
feature_6_interval_str="fw_interval"

feature_7=proxy_log_push
feature_7_name="rune-proxy-log-report-push"
feature_7_interval_str="proxy_interval"

feature_8=av_signature_check
feature_8_name="rune-av-signature-check"
feature_8_interval_str="av_signature_upgrade_interval"

feature_9=av_log_push
feature_9_name="rune-av-log-report-push"
feature_9_interval_str="av_interval"

feature_11=dns_log_push
feature_11_name="rune-dns-log-report-push"
feature_11_interval_str="dns_interval"

feature_12=flow_log_push
feature_12_name="rune-netflow-log-report-push"
feature_12_interval_str="flow_interval"

let num_feature=3
let periodic_sleep_secs=10


param_1=firmware_build_epoch
param_2=firmware_path
param_3=firmware_md5
param_4=devfinger_interval
param_5=netfinger_interval
param_6=hids_signature
param_7=hids_sig_path
param_8=hids_sig_md5
param_9=hids_interval
param_10=fw_interval
param_11=proxy_interval
param_12=av_signature
param_13=av_sig_path
param_14=av_sig_md5
param_15=av_interval
param_16=dns_interval
param_17=flow_interval

param_name_1='Firmware Build epoch'
param_name_2='Firmware Build path'
param_name_3='Firmware md5'
param_name_4='DevFinger interval'
param_name_5='NetFinger interval'
param_name_6='HIDS signature'
param_name_7='HIDS signature path'
param_name_8='HIDS signature md5'
param_name_9='HIDS interval'
param_name_10='FW interval'
param_name_11='Proxy interval'
param_name_12='AV signature'
param_name_13='AV signature path'
param_name_14='AV signature md5'
param_name_15='AV interval'
param_name_16='DNS interval'
param_name_17='Flow interval'

let params_list_len=4
let params_names_list_len=4

if [ ${params_list_len} != ${params_names_list_len} ]; then
	echo "Mismatched array sizes.  params_list:${params_list_len}  and params_names_list:${params_names_list}"
	exit 1
fi


rune_config_defaults=/etc/config/rune/defaults
. ${rune_config_defaults}


. /lib/rune/parse_desired_state.sh



# Initialize xxx-slept counters, and xxx-changed flags for all features
for i in `seq 1 ${num_feature}`; do
	slept_var_str=feature_${i}_slept
	eval let ${slept_var_str}=0
	feature_str=feature_${i}
	feature=$(eval echo \$$feature_str)
done


rune_params_reload=/tmp/rune_params_reload

echo "Rune-System Manager starting"
while (true); do

	sleep ${periodic_sleep_secs}

	let loop_start_secs=$(date +"%s")

	# recompute system vars from system data
	initialize_sys_var_from_system

	# Pull down desired device params (config), store in tmp json doc
	./pull_desired_params_from_cloud.sh

	# Parse JSON doc and convert to new_xxx variables
	parse_desiredstatedoc_params
	
	# Process desired device params. Convert incoming params to new_{foo}
	check_each_desired_device_param

	# Timers/intervals are handled by comparing total sleep time
	# Parameter changes, Actions are handled by acting immediate.

	# loop through all features (tasks) and check if they should be awakened

	for i in `seq 1 ${num_feature}`; do
		feature_str=feature_${i}
		feature=$(eval echo \$$feature_str)
		feature_name_str=feature_${i}_name
		feature_name=$(eval echo \$$feature_name_str)
		# echo "Feature num: ${i} ${feature_name}"
		slept_var_str=feature_${i}_slept
		let prev_slept_val=0
		prev_slept_val=$(eval echo \$$slept_var_str)
		let now_slept_secs=${prev_slept_val}+${periodic_sleep_secs}
		# echo "Prev: ${prev_slept_val} Total now ${now_slept_secs}"

		# Check if total sleep time is now greater than config ?
		config_sleep_var_str=feature_${i}_interval_str
		let config_sleep=$(eval echo \$${config_sleep_var_str})
		if [ ${config_sleep} -eq 0 ]; then
			config_sleep=${periodic_sleep_secs}
		fi
		echo "Config: ${config_sleep}  Slept: ${now_slept_secs}"

		if [ ${now_slept_secs} -ge ${config_sleep} ]; then
			feature_cmd_str=action_${feature}
			echo "Running feature-${i}: ${feature_name} after ${now_slept_secs} secs. Cmd: ${feature_cmd_str}"
			${feature_cmd_str}
			# eval echo \$$feature_cmd_str

			eval let ${slept_var_str}=0
		fi

	done

	# Load previous round parameters as current variable values
	echo "Here1"
	if [ -e ${rune_params_reload} ]; then
		. ${rune_params_reload}
	fi
	sleep 5
	rm -f ${rune_params_reload}
	echo "Here2"
	
	let loop_end_secs=$(date +"%s")

	# increment slept times, but compensate for loop lengthening error
	let loop_slack_secs=${loop_end_secs}-${loop_start_secs}
	for i in `seq 1 ${num_feature}`; do
		slept_var_str=feature_${i}_slept
                let prev_slept_val=$(eval echo \$$slept_var_str)
		eval let ${slept_var_str}=${prev_slept_val}+${periodic_sleep_secs}+${loop_slack_secs}
	done

done
