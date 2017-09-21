#
# Helper to convert the CSV fsaved from Excel to something useful
#

if [ $# -ne 1 ]; then
   echo "use: $0 <input file>"
   exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$INPUT_FILE.converted

if [ ! -f $INPUT_FILE ]; then
   echo "ERROR: $INPUT_FILE does not exist or is not readable, aborting"
   exit 1
fi

cat $INPUT_FILE | tr "\r" "\n" | sed 1d > $OUTPUT_FILE
echo "Converted file in $OUTPUT_FILE"
