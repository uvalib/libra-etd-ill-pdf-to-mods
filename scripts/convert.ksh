#
# Helper to convert the CSV fsaved from Excel to something useful
#

# some definitions
INPUT_DIR=01_Interlibrary_Ingest
INPUT_NAME=Ill_Batchload.csv
INPUT_FILE=$INPUT_DIR/$INPUT_NAME
OUTPUT_FILE=$INPUT_DIR/$INPUT_NAME.converted

cat $INPUT_FILE | tr "\r" "\n" | sed 1d > $OUTPUT_FILE
echo "Converted file in $OUTPUT_FILE"
