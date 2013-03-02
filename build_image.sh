#!/bin/bash -x
#
# build_image.sh -- Downloads and installs the desired Smalltalk
#
# Copyright (c) 2012,2013 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#

# Environment variables defined in .travis.yml
#
# Copyright (c) 2012,2013 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#

case "$ST" in

  PharoCore-1.0|PharoCore-1.1|PharoCore-1.2|PharoCore-1.3|Pharo-1.4|Pharo-2.0|Squeak-4.3|Squeak4.3|Squeak-4.4|Squeak-4.5)
	./build_client_image.sh
	if [[ $? != 0 ]] ; then exit 1; fi
        exit 0
  ;;
  GemStone-2.4.4.1)
        ./installGemstone.sh 2.4.4.1
	if [[ $? != 0 ]] ; then exit 1; fi
  ;;
  GemStone-2.4.4.7)
        ./installGemstone.sh 2.4.4.7
        if [[ $? != 0 ]] ; then exit 1; fi
  ;;
  GemStone-2.4.5)
        ./installGemstone.sh 2.4.5
        if [[ $? != 0 ]] ; then exit 1; fi
  ;;
  GemStone-2.4.5)
        ./installGemstone.sh 2.4.5.1
        if [[ $? != 0 ]] ; then exit 1; fi
  ;;
  GemStone-3.0.1)
        ./installGemstone.sh 3.0.1
        if [[ $? != 0 ]] ; then exit 1; fi
  ;;
  GemStone-3.1.0.2)
        ./installGemstone.sh 3.1.0.2
        if [[ $? != 0 ]] ; then exit 1; fi
  ;;


  # unknown
  *) echo "Unknown Smalltalk version ${ST}"
    exit 1
  ;;
esac

# only GemStone gets here
uname -a 
source /opt/gemstone/product/seaside/defSeaside #set GemStone environment variables
taskset -c 0,1 startGemstone
gslist -lc

