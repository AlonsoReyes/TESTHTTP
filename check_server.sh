#!/bin/bash


nIP="10.0.12.100"
nPORT=8080
nFILE="index.html"
nDIR="/home/root/A8/nghttp2-1.28.0/src/"

while getopts i:p:f:d: opt
do
	case "${opt}"
	in
		i) nIP=${OPTARG};;
		p) nPORT=${OPTARG};;
		d) nDIR=${OPTARG};;
		f) nFILE=${OPTARG};;
	esac
done

#SERVER DOWN -> NO
#SERVER UP -> YES

testCommand="${nDIR}nghttp -n http://${nIP}:${nPORT}/${nFILE} 2>&1"
result="$(eval $testCommand)"

while ! [[ -z $result  ]]
do
	sleep 3
	echo "			Failed to connect to $nIP. Retrying...			"
	result="$(eval $testCommand)"
done

echo "			Server is UP!			"

