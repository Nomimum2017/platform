#!/usr/bin/sh


check_expand_tarball_packages () {
	if [ -e ${1} ]; then
		if [[ ${1} != *.tgz ]]; then
			echo "Skipping ${1} in tarball dir"
			return 0
		fi
		echo "Expanding tarball package ${1}"
		tar xfz ${1}
		if [ $? != 0 ]; then
			echo "**: FAILED: to untar tarball: ${1}"
			exit 1
		fi
		return 0
	fi
	return 1
}

check_place_directory () {
        if [ -d ${1} ]; then
		mkdir -p ${2}
                cp -rf ${1}/* ${2}/
        fi
}

check_patch_file () {
	if [ -e ${1} ]; then
		echo "Patching ${1}"
		patch -p1 < ${1}
		if [ $? != 0 ]; then
			echo "**: FAILED: to correctly patch file: ${1}"
			exit 2
		fi
		return 0 
	fi
	echo "**: FAILED: to find patch file: ${1}"
	return 1
}

check_run_shell_script () {
	if [ -x ${1} ]; then
		echo "Executing script ${1}"
		${1}
#		if [ $? != 0 ]; then
#			echo "**: FAILED: to correctly run shell script: ${1}"
#			exit 3
#		fi
		return 0 
	fi
	echo "**: FAILED: to find shell script: ${1}"
	return 1
}

set_ow_build_timestamps () {
# ensure we are in openwrt/ directory
	touch package/base-files/files/etc/init.d/sysfixtime
	export KBUILD_BUILD_TIMESTAMP=`date "+%F %H:%M:%S"; date +"%s"`
}

build_openwrt () {
	echo "Starting build job in openwrt with -j6 threads at `date`"
	echo "You may check the build progress in file ../build_log.txt"
	time make V=s -j6 &>> ../build_log.txt
	retval=$?
	echo "OpenWRT build exit code ${retval}"
	return ${retval}
}

build_all () {
	set_ow_build_timestamps
	build_openwrt
	ret=$?
	echo "$0: finished at `date`"
	exit ${ret}
}

############################### START ##########################

set -x

echo "$0 Starting at `date`"
cd openwrt

if [ -e setup_done ]; then
	build_all
fi

touch setup_inprogress
touch .config.old
cp ../runeio/gl-ar150/CONFIG_PLATFORM_gl-ar150 .config

# Skip the normal OpenWRT feeds scripts, by force copying/untarring here
check_expand_tarball_packages ../runeio/misc/feeds-misc.tgz

# See if we have cached dl/ directory in tarball. Saves quite a bit of downloads during build
check_expand_tarball_packages ../dl_packages.tgz
if [ $? -ne 0 ]; then
	check_expand_tarball_packages ../../dl_packages.tgz
	if [ $? -ne 0 ]; then
		check_expand_tarball_packages ../../../dl_packages.tgz
		if [ $? -ne 0 ]; then
			echo "cached dl_packages.tgz could not be located"
		fi
	fi
fi

# Add platform tarball packages
for i in `ls ../runeio/gl-ar150/tarball-packages/* 2> /dev/null`; do
	check_expand_tarball_packages ${i}
done

# Add runeio generic packages
for i in `ls ../runeio/generic/tarball-packages/* 2> /dev/null`; do
	check_expand_tarball_packages ${i}
done

# Add select directory packages
check_place_directory ../runeio/generic/dir-packages/rune-lib package/base-files/files/lib/rune
check_place_directory ../runeio/generic/dir-packages/rune-etc package/base-files/files/etc
check_place_directory ../runeio/generic/dir-packages/rune-aws-iot-sdk package/utils/aws-iot/
check_place_directory ../runeio/generic/dir-packages/aws-iot-certificates-and-ID package/base-files/files/usr/certs

# Patch platform patches
for i in `ls ../runeio/gl-ar150/Patches/* 2> /dev/null`; do
	check_patch_file ${i}
done

# Patch runeio generic patches
for i in `ls ../runeio/generic/Patches/* 2> /dev/null`; do
	check_patch_file ${i}
done

# Run scripts to modify configs related to particular platform
for i in `ls ../runeio/gl-ar150/Config-mods/* 2> /dev/null`; do
	check_run_shell_script ${i}
done

# Run scripts to modify configs related to generic features / SW
for i in `ls ../runeio/generic/Config-mods/* 2> /dev/null`; do
	check_run_shell_script ${i}
done

echo "Build workspace setup at: `date`"
touch setup_done
rm -f setup_inprogress
set - -x
build_all
