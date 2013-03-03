#!/bin/bash
#
# build_gemstone.sh -- Run Gemstone instance
#
# Copyright (c) 2013 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#

# build configuration
BEFORE_SCRIPTS=("$SCRIPTS_PATH/before.st")

# help function
function display_help() {
	echo "$(basename $0) -i input -o output {-m} {-s script} {-f full-path-to-script} {-X}"
  echo " -f one or more scripts (full path) to build the image, can be intermixed with -m and -s options"
	echo " -i input product name, image from images-directory, or successful jenkins build"
	echo " -m use Metacello test harness: FileTree, Metacello, travisCIHarness.st, can be intermixed with -f and -s options"
	echo " -o output product name"
	echo " -s one or more scripts from the scripts-directory to build the image, can be intermixed with -m and -f options"
  echo " -X do not bootstrap metacello into the image"
}

echo "PROCESSING OPTIONS"

# parse options
BOOTSTRAP_METACELLO=include
while getopts ":i:mXo:f:s:?" OPT ; do
	case "$OPT" in

		# full path to script
	  	f)	if [ -f "$OPTARG" ] ; then
                	SCRIPTS=("${SCRIPTS[@]}" "$OPTARG")
			else
				echo "$(basename $0): invalid script ($OPTARG)"
				exit 1
			fi
			;;

		# input
		i)
			GEMSTONE_VERSION="$OPTARG"
			;;

    		# include standard Metacello test harness
    		m) SCRIPTS=("${SCRIPTS[@]}" "$SCRIPTS_PATH/travisCIHarness.st" )
    			;; 

		# output
		o)	OUTPUT_NAME="$OPTARG"
			OUTPUT_PATH="$BUILD_PATH/$OUTPUT_NAME"
			OUTPUT_ZIP="$BUILD_PATH/$OUTPUT_NAME.zip"
			OUTPUT_SCRIPT="$OUTPUT_PATH/$OUTPUT_NAME.st"
			OUTPUT_IMAGE="$OUTPUT_PATH/$OUTPUT_NAME.image"
			OUTPUT_CHANGES="$OUTPUT_PATH/$OUTPUT_NAME.changes"
			OUTPUT_CACHE="$OUTPUT_PATH/package-cache"
      			case "$ST" in
        			Squeak*) 
          				OUTPUT_DEBUG="$OUTPUT_PATH/SqueakDebug.log"
          			;; 
        			Pharo*) 
          				OUTPUT_DEBUG="$OUTPUT_PATH/PharoDebug.log" 
          			;;
      			esac
			OUTPUT_DUMP="$OUTPUT_PATH/crash.dmp"
			;;

		# script
		s)	
			if [ -f "$SCRIPTS_PATH/$OPTARG" ] ; then
                		SCRIPTS=("${SCRIPTS[@]}" "$SCRIPTS_PATH/$OPTARG")
			else
				echo "$(basename $0): invalid script ($OPTARG)"
				exit 1
			fi
			;;

    		X) BOOTSTRAP_METACELLO=exclude
    			;;

		# show help
		\?)	display_help
			exit 1
		;;

	esac
done

echo "preparing script files"

# prepare output path
if [ -d "$OUTPUT_PATH" ] ; then
	rm -rf "$OUTPUT_PATH"
fi
mkdir -p "$OUTPUT_PATH"

# hook up the git_cache, Metacello bootstrap and mcz repo

ln -sf "$GIT_PATH" "$OUTPUT_PATH/"
ln -sf "$BUILDER_CI_HOME/mcz" "$OUTPUT_PATH/"
ln -sf "$BUI:LDER_CI_HOME/scripts/Metacello-Base.st" "$OUTPUT_PATH/"
ln -sf "$BUILDER_CI_HOME/scripts/FileStream-show.st" "$OUTPUT_PATH/"
ln -sf "$BUILDER_CI_HOME/scripts/MetacelloBuilderTravisCI.st" "$OUTPUT_PATH/"

# prepare script file
if [ "$BOOTSTRAP_METACELLO" == include ] ; then
  BEFORE_SCRIPTS=("${BEFORE_SCRIPTS[@]}" "$SCRIPTS_PATH/bootstrapMetacello.st")
else
  BEFORE_SCRIPTS=("${BEFORE_SCRIPTS[@]}" "$SCRIPTS_PATH/bootstrapGofer.st")
fi
SCRIPTS=("${BEFORE_SCRIPTS[@]}" "${SCRIPTS[@]}" "$SCRIPTS_PATH/after.st")

for FILE in "${SCRIPTS[@]}" ; do
	echo "run" >> "$OUTPUT_SCRIPT"
  echo "\"builderCI file: $FILE\"" >> "$OUTPUT_SCRIPT"
	cat "$FILE" >> "$OUTPUT_SCRIPT"
	echo "%" >> "$OUTPUT_SCRIPT"
done

cd ${BUILD_PATH}/travisCI
source /opt/gemstone/product/seaside/defSeaside #set GemStone environment variables
# gslist -lc
echo "RUNNING TESTS..."

while true; do echo "travis ... be patient PLEASE: https://github.com/dalehenrich/builderCI/issues/38"; sleep 60; done &

topaz -l -q -T50000 <<EOF
output push travis.log only
set gemstone seaside
set user DataCurator pass swordfish
iferr 1 stk
iferr 2 stack
iferr 3 exit 1
status
login
input $OUTPUT_SCRIPT
exit 0
EOF

kill %1

if [[ $? != 0 ]] ; then
  cat travis.log
  exit 1; 
fi

rm -rf travis.log

# remove cache link
rm -rf "$OUTPUT_CACHE" "$OUTPUT_ZIP"
(
	cd "$OUTPUT_PATH"
)

# success
exit 0
