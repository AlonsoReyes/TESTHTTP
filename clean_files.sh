#!/bin/bash


OML_FILE=""
CSV_DIR=""
INIT_EPOCH=0
END_EPOCH=0
W=0
M=0
#clean_file -a RawNext -b RawAct -c FilAct -d CSVFile -e CSVBase

while getopts f:b:e:d: opt
do
	case "${opt}"
	in
		f) OML_FILE=${OPTARG};;
		b) INIT_EPOCH=${OPTARG};;
		e) END_EPOCH=${OPTARG};;
		d) CSV_DIR=${OPTARG};;
	esac
done


if [[ "$OML_FILE" =~ W([0-9]+)\_ ]] ; then
	W=${BASH_REMATCH[1]}
fi

if [[ "$OML_FILE" =~ M([0-9]+)\. ]] ; then
	M=${BASH_REMATCH[1]}
fi

CSV_FILE="${CSV_DIR}W${W}_M${M}.csv"

sed -e '/^[^0-9]/d;s/\t/,/g;' "$OML_FILE" > "$CSV_FILE"  && \
awk -F ',' -v a="$INIT_EPOCH" -v b="$END_EPOCH" '$4>=a && $4<=b' "$CSV_FILE" > "tmpfile.tmp" && \
mv "tmpfile.tmp" "$CSV_FILE" 
cut -d, -f1,3,6-8  "$CSV_FILE" > "tmpfile.tmp" && \
mv "tmpfile.tmp" "$CSV_FILE" && \
sed -i '1s/^/time,iteration,power,current,voltage\n/' "$CSV_FILE" && \
sed -i '$ d' "$CSV_FILE" && \
sed -i '/^\s*$/d' "$CSV_FILE"
