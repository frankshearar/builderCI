#!/bin/bash -x
#
# build_install.sh -- Driver for the travis-ci install process
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#


# help function
function display_help() {
	echo "$(basename $0) -c "
	echo " -c grab tests from ../tests"
}

# default BUILDER_CI_HOME locations
export TESTS_PATH="$BUILDER_CI_HOME/tests"

# parse options
while getopts ":c:?" OPT ; do
	case "$OPT" in

		c) export TESTS_PATH="$BUILDER_CI_HOME/../tests"
    ;;
		# show help
		\?)	display_help
			exit 1
		;;

	esac
done

./build_export.sh 
./build_clone.sh -g "-b pharo1.3 git://github.com/dalehenrich/filetree.git"
./build_clone.sh -g "git://github.com/dalehenrich/metacello-work.git"
./build_image.sh

# success
exit 0
