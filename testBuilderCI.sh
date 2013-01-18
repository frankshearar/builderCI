#!/bin/bash -x
#
# Test driver script for builderCI itself
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#
./build.sh -i $ST -m -f "$BUILDER_CI_HOME/tests/travisCI.st" -o travisCI || exit $?
cd "${BUILD_PATH}/travisCI/"
$BUILDER_CI_HOME/buildImageErrorCheck.sh || exit $?
$BUILDER_CI_HOME/buildTravisStatusCheck.sh || exit $?
cat TravisTranscript.txt
cd $BUILDER_CI_HOME
./build.sh -i $ST -X -f "$BUILDER_CI_HOME/tests/skipMetacelloBootstrap.st" -o travisCI || exit $?
cd "${BUILD_PATH}/travisCI/"
$BUILDER_CI_HOME/buildImageErrorCheck.sh || exit $?
$BUILDER_CI_HOME/buildTravisStatusCheck.sh || exit $?
cat TravisTranscript.txt
