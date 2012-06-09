#!/bin/bash
#
# build_image.sh -- Downloads and installs the desired Smalltalk
#   installation: PharoCore-1-3 or Squeak4.3
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#

# Environment variables defined in .travis.yml

# help function
function display_help() {
	echo "$(basename $0) -s smalltalk "
	echo " -s name of Smalltalk version to be downloaded and installed"
}

# parse options
while getopts ":i:o:s:?" OPT ; do
	case "$OPT" in

		# smalltalk version
		s)	
    ;;
		# show help
		\?)	display_help
			exit 1
		;;

	esac
done

# success
exit 0
