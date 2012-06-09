#!/bin/bash -x
#
# build_image.sh -- Downloads and installs the desired Smalltalk
#   installation: PharoCore-1-3 or Squeak4.3
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#

# Environment variables defined in .travis.yml

case "$ST" in

  # PharoCore-1.3
  PharoCore-1.3)
    cd $IMAGES_PATH
    wget https://gforge.inria.fr/frs/download.php/30567/PharoCore-1.3-13328.zip
    unzip PharoCore-1.3-13328.zip
    cd PharoCore-1.3
    mv *.sources $SOURCES_PATH
    mv *.changes ..
    mv *.image ..
  ;;
  # Squeak4.3
  # unknown
  \?) echo "Unknown Smalltalk version ${ST}"
    exit 1
  ;;
  esac

# success
exit 0
