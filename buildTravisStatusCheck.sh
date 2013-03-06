#!/bin/bash
#
# checks for build success/failure and dumps appropriate file to stdou
#
#      -verbose flag causes unconditional transcript display
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#
if ( test -e TravisCISuccess.txt); then 
  if [ "$1" = "-verbose" ] ; then
    ls -altr TravisTranscript.txt
    cat TravisTranscript.txt
  fi
  cat TravisCISuccess.txt
fi
if ( test -e TravisCIFailure.txt ); then 
  cat TravisTranscript.txt
  cat TravisCIFailure.txt
  exit 1
fi
exit 0
