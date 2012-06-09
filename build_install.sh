#!/bin/bash -x
#
# build_install.sh -- Driver for the travis-ci install process
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#


# help function
function display_help() {
	echo "$(basename $0) -c "
	echo " -c if present, clone the buildCI repository: git://github.com/dalehenrich/buildCI.git"
}

# default BUILDER_CI_HOME locations
export BUILDER_CI_HOME="$(pwd)"
export TESTS_PATH="$BUILDER_CI_HOME/tests"

# parse options
while getopts ":c:?" OPT ; do
	case "$OPT" in

		g) 
      git clone git://github.com/dalehenrich/buildCI.git
      if [ $? -ne 0 ]; then
       echo "error cloning buildCI" 
       exit 1; 
      fi
      BUILDER_CI_HOME="$GIT_PATH/buildCI"
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
