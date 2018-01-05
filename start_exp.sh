#!/bin/bash

#nodes path
resultsDIR="/home/root/A8/results/"
#main server path
grenobleDIR="/senslab/users/reyes/A8/results/"
serverPort=8080

. ./available_nodes.sh

if [[ ${#NODES[@]} -lt 2 ]] ; then
	echo "Need more than 2 A8 nodes to run tests."
	exit 1
fi

echo 

clientIP="10.0.12.${NODES[0]}"
serverIP="10.0.12.${NODES[1]}"


while getopts p: opt
do
	case "${opt}"
	in
		p) serverPort=${OPTARG};;
	esac
done

echo "			Client IP: ${clientIP}			"
echo "			Server IP: ${serverIP}			"
echo "			Server Port: ${serverPort}			"

${grenobleDIR}run_tests.sh -c $clientIP -s $serverIP -p $serverPort

if [[ $? -ne 0 ]] ; then
	echo "			Running tests failed!!			"
	exit 1
fi

#${grenobleDIR}filter_consumption.sh

#TODO GET RESULTS