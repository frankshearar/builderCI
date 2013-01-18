#!/bin/bash
#
# Test driver script for buildCI itself
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#
./build.sh -i $ST -m -f "$BUILDER_CI_HOME/tests/travisCI.st" -o travisCI
cd "${BUILD_PATH}/travisCI/"
$BUILDER_CI_HOME/buildImageErrorCheck.sh
$BUILDER_CI_HOME/buildTravisStatusCheck.sh
cat TravisTranscript.txt
cd $BUILDER_CI_HOME
./build.sh -i $ST -X -f "$BUILDER_CI_HOME/tests/skipMetacelloBootstrap.st" -o travisCI
cd "${BUILD_PATH}/travisCI/"
$BUILDER_CI_HOME/buildImageErrorCheck.sh
$BUILDER_CI_HOME/buildTravisStatusCheck.sh
cat TravisTranscript.txt
