#!/bin/bash -x
#
# build_export.sh -- Define all of the global variables used by
#   builderCI
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#

# Environment variables defined in .travis.yml

export BASE_PATH="$BUILDER_CI_HOME"
export BUILD_PATH="${WORKSPACE:=$BASE_PATH/builds}"
export IMAGES_PATH="$BASE_PATH/images"
export SCRIPTS_PATH="$BASE_PATH/scripts"
export SOURCES_PATH="$BASE_PATH/sources"
export VM_PATH="$BASE_PATH/oneclick/Contents"
export BUILD_CACHE="$BASE_PATH/cache"
export GIT_PATH="$IMAGES_PATH/git_cache"

# success
exit 0
