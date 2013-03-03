#!/bin/bash -x
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#
echo `pwd`
ls -altr *
if ( test -e TravisCISuccess.txt); then 
  cat TravisCISuccess.txt
fi
if ( test -e TravisCIFailure.txt ); then 
  cat TravisTranscript.txt
  cat TravisCIFailure.txt
  exit 1
fi
exit 0
