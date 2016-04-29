#!/bin/sh

# Task 0 pull_device_params  is a special case. It is hard-coded to be
#     spawned at each loop entry.  feature list is checked from index 1 onwards

feature_0=pull_device_params
feature_0_name="rune-device-desired-params-download"
feature_0_interval_str=device_checkin_interval

feature_1=firmware_upgrade_check
feature_1_name="rune-firmware-upgrade-check"
feature_1_interval_str="firmware_upgrade_check_interval"

feature_2=scan_finger
feature_2_name="net-scan-finger"
feature_2_interval_str="devfinger_interval"

feature_3=scan_nmap
feature_3_name="net-scan-nmap"
feature_3_interval_str="netfinger_interval"

feature_4=hids_signature_check
feature_4_name="rune-hids-signature-check"
feature_4_interval_str="hids_signature_upgrade_interval"

feature_5=hids_log_push
feature_5_name="rune-hids-log-report-push"
feature_5_interval_str=hids_interval

feature_6=fw_log_push
feature_6_name="rune-firewall-log-report-push"
feature_6_interval_str=fw_interval

feature_7=proxy_log_push
feature_7_name="rune-proxy-log-report-push"
feature_7_interval_str=proxy_interval

feature_8=av_signature_check
feature_8_name="rune-av-signature-check"
feature_8_interval_str="av_signature_upgrade_interval"

feature_9=av_log_push
feature_9_name="rune-av-log-report-push"
feature_9_interval_str=av_interval

feature_11=dns_log_push
feature_11_name="rune-dns-log-report-push"
feature_11_interval_str=dns_interval

feature_12=flow_log_push
feature_12_name="rune-netflow-log-report-push"
feature_12_interval_str=flow_interval

let num_feature=12
let periodic_sleep_secs=30

#rune_config_current="/etc/config/rune/current"
rune_config_current=./current

if [ ! -e ${rune_config_current} ]; then
	echo "$0:  current config file: ${rune_config_current} missing"
	exit 1
fi


# Initialize xxx-slept counters, and xxx-changed flags for all features
for i in `seq 1 ${num_feature}`; do
	slept_var_str=feature_${i}_slept
	eval let ${slept_var_str}=0
	feature_str=feature_${i}
	feature=$(eval echo \$$feature_str)
	feature_changed_str=${feature}_Changed
	eval let ${feature_changed_str}=0
done



while (true); do

	sleep ${periodic_sleep_secs}

	let loop_start_secs=0   # FIXME

	# Pull down desired device params (config), store in current file
	./pull_device_params.sh

	# Read-in current / modified params from current file
	source ${rune_config_current}

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
		config_sleep_var=feature_${i}_interval_str
		let config_sleep=$(eval echo \$${config_sleep_var})
		if [ ${config_sleep} -eq 0 ]; then
			config_sleep=${periodic_sleep_secs}
		fi
		echo "Config: ${config_sleep}  Slept: ${now_slept_secs}"
		feature_changed_str=feature_${i}_Changed
		let feature_changed=$(eval let ${feature_changed_str})
		if [ ${feature_changed} -eq 1 ]; then
			let config_sleep=0	# Force immediate launch
		fi

		if [ ${now_slept_secs} -ge ${config_sleep} ]; then
			feature_cmd=/lib/rune/${feature}.sh
			echo "Running feature: ${feature_name} after ${now_slept_secs} secs. Cmd: ${feature_cmd}"
			# Spawn off the launch command
			#     collect output in log file
			if [ -x ${feature_cmd} ]; then

				# launch feature_cmd
				echo "$0: Launching ${feature_cmd}"

				#  Send logged output to AWS
			else
				echo "$0: ** launch command for ${feature_cmd} not found. SKIP"
			fi

			eval let ${slept_var_str}=0
		fi

	done

	let loop_end_secs=0   # FIXME

	# increment slept times, but compensate for loop lengthening error
	let loop_slack_secs=${loop_end_secs}-${loop_start_secs}
	for i in `seq 1 ${num_feature}`; do
		slept_var_str=feature_${i}_slept
                let prev_slept_val=$(eval echo \$$slept_var_str)
		eval let ${slept_var_str}=${prev_slept_val}+${periodic_sleep_secs}+${loop_slack_secs}
	done

	sleep ${periodic_sleep_secs}
done
