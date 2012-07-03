#!/bin/bash -x
#
# build_image.sh -- Downloads and installs the desired Smalltalk
#   installation: PharoCore-1-3, Pharo-1.4 or Squeak4.3
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
    IMAGE_BASE_NAME=PharoCore-1.3
    IMAGE_TARGET_NAME=$IMAGE_BASE_NAME
  ;;
  # Pharo-1.4
  Pharo-1.4)
    cd $IMAGES_PATH
    wget https://gforge.inria.fr/frs/download.php/30620/Pharo-1.4-14438.zip
    unzip Pharo-1.4-14438.zip
    cd Pharo-1.4-14438
    IMAGE_BASE_NAME=Pharo-1.4
    IMAGE_TARGET_NAME=$IMAGE_BASE_NAME
  ;;
  # Squeak-4.3 ... allow Squeak4.3 for backwards compatibility
  Squeak-4.3|Squeak4.3)
    cd $IMAGES_PATH
    wget http://ftp.squeak.org/4.3/Squeak4.3.zip
    unzip Squeak4.3.zip
    cd Squeak4.3
    wget http://ftp.squeak.org/4.1/SqueakV41.sources.gz
    gunzip SqueakV41.sources.gz
    IMAGE_BASE_NAME=Squeak4.3
    IMAGE_TARGET_NAME=Squeak-4.3
  ;;

  # unknown
  \?) echo "Unknown Smalltalk version ${ST}"
    exit 1
  ;;
  esac

# move the image components into the correct location
mv *.sources $SOURCES_PATH
mv ${IMAGE_BASE_NAME}.changes ../${IMAGE_TARGET_NAME}.changes
mv ${IMAGE_BASE_NAME}.image ../${IMAGE_TARGET_NAME}.image

# success
exit 0
