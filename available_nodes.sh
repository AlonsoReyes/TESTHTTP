#!/bin/bash

consumptionDIR="/senslab/users/reyes/.iot-lab/last/consumption"

NODES=()
currentNode=0

for file in "$consumptionDIR"/*
do
	if [[ "$file" =~ -([0-9]+)\. ]] ; then
		currentNode=${BASH_REMATCH[1]}
		#echo "Found node: $currentNode"
		count=0
		while [[ $count -le 2  ]]
		do
			ssh -q root@node-a8-${currentNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no exit
			if [[ $? -eq 0 ]] ; then
				NODES=("${NODES[@]}" $currentNode)
				break
			fi
			count="$(($count+1))"
		done

	else
		#echo "Not found"
		continue 
	fi
done 
echo "			Available nodes: ${#NODES[@]}			"
