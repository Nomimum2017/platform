
Rune.io  Platform Software README

Clone via:

git clone --recursive https://github.com/runeio/platform.git

This repository contains Rune.io Platform Software and it includes a
fetched copy of OpenWRT (locked to particular commit tag).

Rune.io Platform software brings in generic software as well as platform
dependent changes. The build script pulls these into the correct OpenWRT
tree locations, and fires off the build.

OpenWRT README file can be found in openwrt/README.


Commits:
There should be no changes made and committed in the openwrt subdir heirarchy.
All needed changes should be achieved via adding Packages, Patches
and Config scripts in the runeio  generic and platform directories.

This means, while committing,  only the specific  files, subdirectories
in platform directory and runeio subdirectory should be added.
'git add foo'

While carefully ignoring / excluding transient/side-effect changes
under openwrt directory.

Build:

   Build pre-requisites:

   Build script

   Inovke via  ./build.sh

	The script will end up starting a 'make' job inside openwrt directory with -j6.

	The resulting binaries should be found under openwrt/bin/... path
	e.g. For gl-ar150:  openwrt/bin/ar71xx/openwrt-ar71xx-generic-gl_ar150-squashfs-sysupgrade.bin

	A build log is captured and saved in build_log.txt

