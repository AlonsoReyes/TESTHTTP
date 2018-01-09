#!/bin/bash


OML_FILE=""
CSV_DIR=""
INIT_EPOCH=0
END_EPOCH=0
W=0
M=0
#clean_file -a RawNext -b RawAct -c FilAct -d CSVFile -e CSVBase

while getopts f:b:e:d:w:m: opt
do
	case "${opt}"
	in
		f) OML_FILE=${OPTARG};;
		b) INIT_EPOCH=${OPTARG};;
		e) END_EPOCH=${OPTARG};;
		d) CSV_DIR=${OPTARG};;
		w) W=${OPTARG};;
		m) M=${OPTARG};;
	esac
done

CSV_FILE="${CSV_DIR}W${W}_M${M}.csv"
#echo "$CSV_DIR"
 echo "			W${W}_M${M} INIT_EPOCH=$INIT_EPOCH -- END_EPOCH=$END_EPOCH			"

SEARCH=$(awk -F $'\t' -v a="$END_EPOCH" '$4>=a' $OML_FILE)

while [[ -z $SEARCH ]] ; do
	echo "			File still not updated... Retrying...			"
	sleep 15
	SEARCH=$(awk -F $'\t' -v a="$END_EPOCH" '$4>=a' $OML_FILE)
done

TEMPFILE="/senslab/users/reyes/A8/results/consumption/tmpcopy.tmp"

cp $OML_FILE $TEMPFILE 

sed -e '/^[^0-9]/d;s/\t/,/g;' "$TEMPFILE" > "$CSV_FILE"  && \
awk -F ',' -v a="$INIT_EPOCH" -v b="$END_EPOCH" '$4>=a && $4<=b' "$CSV_FILE" > "tmpfile.tmp" && \
mv "tmpfile.tmp" "$CSV_FILE" 
cut -d, -f1,3,6-8  "$CSV_FILE" > "tmpfile.tmp" && \
mv "tmpfile.tmp" "$CSV_FILE" && \
sed -i '1s/^/time,iteration,power,current,voltage\n/' "$CSV_FILE" && \
sed -i '$ d' "$CSV_FILE" && \
sed -i '/^\s*$/d' "$CSV_FILE"
