#!/bin/bash
if ( test -e TravisCISuccess.txt); then 
  cat TravisCISuccess.txt
fi
if ( test -e TravisCIFailure.txt ); then 
  cat TravisCIFailure.txt
  exit 1
fi
exit 0
