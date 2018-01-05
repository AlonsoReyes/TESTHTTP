#!/bin/bash

nIP="$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
nPORT=8080
nFILE="index.html"
nDIR="/home/root/A8/nghttp2-1.28.0/src/"
serverDIR="/home/root/A8/test_server/"
resultsDIR="/home/root/A8/results/"
nW=8
nM=100
nN=10
ADDRESS="http://${nIP}:${nPORT}/${nFILE}"

while getopts p:f:d:w:m:n:s: opt
do
	case "${opt}"
	in
		p) nPORT=${OPTARG};;
		d) nDIR=${OPTARG};;
		f) nFILE=${OPTARG};;
		w) nW=${OPTARG};;
		m) nM=${OPTARG};;
		n) nN=${OPTARG};;
		s) serverDIR=${OPTARG};;
	esac
done


if ! [ -z "$(netstat -an | grep ${nPORT})" ]
then
	fuser -k ${nPORT}/tcp
	fuser -k ${nPORT}/udp
	echo "There was a server running. Killed."
fi

cd $serverDIR

echo "			--- Starting server ---				"

topDir="${resultsDIR}srv_top/W${nW}_M${nM}/run_1.csv"
echo "			--- Starting server TOP ---				"
#top -b -d 0.1 | grep -v grep | grep "nghttpd" | sed -n '{s/,/\./g;s/^ *//;s/ *$//;s/  */,/gp;}' > $topDir &
top -b -d 0.1 > $topDir &
TOP_PID=$!
echo "			--- Top pid: $TOP_PID ---			"
echo "			--- Starting server ---			"

${nDIR}nghttpd --no-tls -v -w ${nW} -W ${nW} -m ${nM} -a ${nIP} ${nPORT}

echo "			--- Server Killed ---			"

kill $TOP_PID

sed -ni 's/,/\./g;s/^ *//;s/ *$//;s/  */,/g;/nghttpd/p' ${topDir}

echo "			--- Killed Top pid: $TOP_PID ---				"
