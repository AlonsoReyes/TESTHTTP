#!/bin/bash


nIP="10.0.12.100"
nPORT=8080
nFILE="index.html"
nDIR="/home/root/A8/nghttp2-1.28.0/src/"
resultsDIR="/home/root/A8/results/"
nW=8
nM=100
nN=10

while getopts i:p:f:d:w:m:n: opt
do
	case "${opt}"
	in
		i) nIP=${OPTARG};;
		p) nPORT=${OPTARG};;
		d) nDIR=${OPTARG};;
		f) nFILE=${OPTARG};;
		w) nW=${OPTARG};;
		m) nM=${OPTARG};;
		n) nN=${OPTARG};;
	esac
done

ADDRESS="http://${nIP}:${nPORT}/${nFILE}"

./check_server.sh -i ${nIP} -p ${nPORT} -d ${nDIR}

echo "			--- Starting tests. Number of iteration: $nN ---			"

echo "			--- Configuration W=${nW} M=${nM} ---			"

for (( i=1; i<=$nN; i++ ))
do
	sleep 3
	echo "			--- Iteration $i Start ---			"
	topDir="${resultsDIR}cl_top/W${nW}_M${nM}/run_${i}.csv"
	clientDir="${resultsDIR}cl_req/W${nW}_M${nM}/run_${i}.csv"
	top -b -d 0.1 -n ${nN} | grep -v grep | grep "nghttp" | sed -n '{s/,/\./g;s/^ *//;s/ *$//;s/  */,/gp;}' > $topDir &
	${nDIR}/nghttp -nas --no-dep --no-push -w ${nW} -W ${nW} -M ${nM} ${ADDRESS} | grep " \+[0-9]"  | sed -n '{s/^ *//;s/ *$//;s/  */,/gp;}' > $clientDir &
	for job in $(ps -o pid= -o cmd= | grep -v grep | grep "nghttp" | awk '{ print $1 }')
	do
		echo "			  *Waiting for last client pid: $job			   "
		wait $job
	done
	echo "			--- Iteration $i Finished ---			"
done

echo "			---Test for configuration W=$nW and M=$nM. DONE---			"

NODE="$(echo $nIP | cut -d'.' -f4)"
kill_server="fuser -k ${nPORT}/tcp; exit"

echo "			--- Killing server ---			"
ssh root@node-a8-${NODE}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$kill_server" > /dev/null 2>&1
echo -e "			--- Server Down and conf test ended ---				\n" 



