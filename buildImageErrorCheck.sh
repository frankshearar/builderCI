#!/bin/bash
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#
if ( test -e PharoDebug.log ); then 
  cat TravisTranscript.txt
  cat PharoDebug.log
  exit 1
fi
if ( test -e SqueakDebug.log ); then 
  cat TravisTranscript.txt
  cat SqueakDebug.log
  exit 1
fi
exit 0
