#!/bin/bash
#
# GemStone GCI Test driver script for builderCI. Use with templates gci_travis.yml
#
#      -verbose flag causes unconditional transcript display
#
# Copyright (c) 2013 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#
echo "Starting GemStone: $GemStone"
ST="$GemStone"
./build.sh -i $ST -m -n -f "$PROJECT_HOME/tests/gemstoneGCI.st" -o travisCI
if [[ $? != 0 ]] ; then 
  echo "ERROR: $(basename $0)"
  cd "${BUILD_PATH}/travisCI/"
  $BUILDER_CI_HOME/buildImageErrorCheck.sh # dump Transcript on error and exit
  if [[ $? != 0 ]] ; then exit 1; fi
  $BUILDER_CI_HOME/dumpTranscript.sh
  exit 1
fi
echo "Starting Client: $CLIENT"
cd $BUILDER_CI_HOME
ST="$CLIENT"
./build.sh -i $ST -m -f "$PROJECT_HOME/tests/clientGCI.st" -o travisCI
if [[ $? != 0 ]] ; then 
  echo "ERROR: $(basename $0)"
  ls -altr $BUILD_PATH
  ls -altr $BUILD_PATH/travisCI
  ls -altr $BUILD_PATH/builds/
  ls -altr $BUILD_PATH/builds/travisCI
  cd "${BUILD_PATH}/travisCI/"
  $BUILDER_CI_HOME/buildImageErrorCheck.sh # dump Transcript on error and exit
  if [[ $? != 0 ]] ; then exit 1; fi
  $BUILDER_CI_HOME/dumpTranscript.sh
  exit 1
fi
cd "${BUILD_PATH}/travisCI/"
$BUILDER_CI_HOME/buildImageErrorCheck.sh # dump Transcript on error and exit
if [[ $? != 0 ]] ; then exit 1; fi
$BUILDER_CI_HOME/buildTravisStatusCheck.sh "$@" # dump Transcript on failed tests and exit
if [[ $? != 0 ]] ; then exit 1; fi
