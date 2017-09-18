#!/usr/bin/env bash
#
# Scripting to generate the ingest worksets
#

#set -x

function exit_on_error {
   local RES=$1
   if [ $RES -ne 0 ]; then
      echo "Terminating with error $RES"
      exit $RES
   fi
   return
}

# the default input directory
INPUT_DIR=results

# the default mapping file
MAPPING_FILE=01_Interlibrary_Ingest/Ill_Batchload.csv.converted

# the ruby script to generate the work sets
GENERATE_SCRIPT=generateworkset/generateworkset.rb

# check argument count
if [ $# -ne 0 ]; then
   if [ $# -ge 1 ]; then
      INPUT_DIR=$1
   fi
   if [ $# -ge 2 ]; then
      MAPPING_FILE=$2
   fi
fi

# check for the existance of the input directory
if [ ! -d $INPUT_DIR ]; then
   echo "ERROR: $INPUT_DIR does not exist or is not readable, aborting"
   exit_on_error 1
fi

# check for the existance of the mapping file
if [ ! -f $MAPPING_FILE ]; then
   echo "ERROR: $MAPPING_FILE does not exist or is not readable, aborting"
   exit_on_error 1
fi

# generate the files
ruby $GENERATE_SCRIPT $MAPPING_FILE $INPUT_DIR
exit_on_error $?

# give the good news
echo "Completed successfully"

# all over
exit 0

#
# end of file
#
