#!/usr/bin/env bash
#
# Scripting to process a batch from ILL and convert to MODS records so they can be ingested into L2
#

function exit_on_error {
   local RES=$1
   if [ $RES -ne 0 ]; then
      echo "Terminating with error $RES"
      exit $RES
   fi
   return
}

# the default input assets
INPUT_ASSETS=../01_Interlibrary_Ingest

# the default input file
INPUT_FILE=$INPUT_ASSETS/Ill_Batchload.csv

# the default output results
OUTPUT_RESULTS=../results

# check argument count
if [ $# -ne 0 ]; then
   if [ $# -ge 1 ]; then
      INPUT_ASSETS=$1
   fi
   if [ $# -ge 2 ]; then
      INPUT_FILE=$2
   fi
   if [ $# -ge 3 ]; then
      OUTPUT_RESULTS=$3
   fi
fi

# check for the existance of the input assets directory
if [ ! -d $INPUT_ASSETS ]; then
   echo "ERROR: $INPUT_ASSETS does not exist or is not readable, aborting"
   exit_on_error 1
fi

# check for the existance of the input file
if [ ! -f $INPUT_FILE ]; then
   echo "ERROR: $INPUT_FILE does not exist or is not readable, aborting"
   exit_on_error 1
fi

echo "Processing input from $INPUT_FILE (assets $INPUT_ASSETS)"
echo "Output to $OUTPUT_RESULTS"

# clean the results directory
rm -fr $OUTPUT_RESULTS/* > /dev/null 2>&1

# define the temp file and clean
TMPFILE=/tmp/assets.$$
rm -fr $TMPFILE > /dev/null 2>&1

# define the logfile name and clean
LOGFILE=logfile.log
rm -fr $LOGFILE > /dev/null 2>&1

# the actual conversion task
CONVERSION=createmodsforpdf_ill

# create the list of files
cat $INPUT_FILE | awk -F, -v asset_dir=$INPUT_ASSETS '{printf "%s:%s/%s.pdf\n", $2, asset_dir, $1}' > $TMPFILE

# check it is not empty
COUNT=$(wc -l $TMPFILE | awk '{print $1}')
if [ "$COUNT" == "0" ]; then
   echo "ERROR: $INPUT_FILE does not contain any items, aborting"
   exit_on_error 1
fi

echo "Processing $COUNT files"

# define and create the results directory
rd=$OUTPUT_RESULTS
mkdir -p $rd > /dev/null 2>&1

# go through the list of input files
for line in $(<$TMPFILE); do

   # get the interesting parts
   id=$(echo $line | awk -F: '{print $1}')
   fn=$(echo $line | awk -F: '{print $2}')
   bn=$(basename $fn)

   echo "" >> $LOGFILE
   echo "$id ($fn)" >> $LOGFILE
   echo -n "."

   # do the conversion and abort if we error 
   ./$CONVERSION -v $fn $id - > $rd/$bn.xml 2>>$LOGFILE
   exit_on_error $?

   # copy the input asset to the results directory
   FULLNAME=$(realpath $fn)
   cp $FULLNAME $rd
   exit_on_error $?
done

# cleanup
rm -fr $TMPFILE >/dev/null 2>&1

# give the good news
echo ""
echo "Results available in $OUTPUT_RESULTS"
echo "Logfile available $LOGFILE"

# all over
exit 0

#
# end of file
#
