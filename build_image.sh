#!/bin/bash
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
        GEMSTONE_VERSION_NAME="2.4.4.1"
 ;;
  GemStone-2.4.4.7)
        GEMSTONE_VERSION_NAME="2.4.4.7"
 ;;
  GemStone-2.4.5)
        GEMSTONE_VERSION_NAME="2.4.5"
 ;;
  GemStone-2.4.5)
        GEMSTONE_VERSION_NAME="2.4.5.1"
 ;;
  GemStone-3.0.1)
        GEMSTONE_VERSION_NAME="3.0.1"
 ;;
  GemStone-3.1.0.2)
        GEMSTONE_VERSION_NAME="3.1.0.2"
        KEY_PATH="./gemstone/etc/maglev.demo.key-Linux-x86_64"
 ;;


  # unknown
  *) echo "Unknown Smalltalk version ${ST}"
    exit 1
  ;;
esac

# only GemStone gets here
# uname -a 
./installGemstone.sh $GEMSTONE_VERSION_NAME
if [[ $? != 0 ]] ; then exit 1; fi
source /opt/gemstone/product/seaside/defSeaside #set GemStone environment variables
chmod +w  /opt/gemstone/product/seaside/etc/gemstone.key
cp $KEY_PATH /opt/gemstone/product/seaside/etc/gemstone.key
startGemstone
# gslist -lc
# cat /opt/gemstone/log/seaside.log


