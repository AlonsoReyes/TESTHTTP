#!/bin/bash


# path in A8 node
resultsDIR="/home/root/A8/results/"
#results dir in main server
grenobleResults="/senslab/users/reyes/A8/results/"
#Directory in main server path
consumptionDIR="/senslab/users/reyes/.iot-lab/last/consumption/"

clientConsumption="${grenobleResults}consumption/client_raw/"
serverConsumption="${grenobleResults}consumption/server_raw/"

#test configurations
W_CONFIG=($(seq 8 1 16))
M_CONFIG=($(seq 1 1 8))	
M_CONFIG=("${M_CONFIG[@]}" 100)

MVALUES="$((${#M_CONFIG[@]} - 1))"

clientIP="10.0.12.100"
serverIP="10.0.12.101"
serverPort=8080

while getopts c:s:p: opt
do
	case "${opt}"
	in
		c) clientIP=${OPTARG};;
		s) serverIP=${OPTARG};;
		p) serverPort=${OPTARG};;
	esac
done

echo "			--- Starting experiment ---				"


clientNode="$(echo $clientIP | cut -d'.' -f4)"
serverNode="$(echo $serverIP | cut -d'.' -f4)"

ssh root@node-a8-${serverNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "chmod +x ${resultsDIR}/*.sh && ${resultsDIR}init_dirs.sh && exit"


#sleep 120


while ! [[ -s "${consumptionDIR}a8-${clientNode}.oml" ]] ; do
	sleep 15
	echo "			Can't start while file is empty.			"
done


first=1
LAST=""
CMP=""
INIT_EPOCH=0
END_EPOCH=0

for mcnf in "${M_CONFIG[@]:0:4}"
do
	for wcnf in "${W_CONFIG[@]:1:4}"
	do  
		INIT_EPOCH="$(date +%s)"
		clientCommand="cd ${resultsDIR} && ./init_client.sh -i ${serverIP} -p ${serverPort} -w ${wcnf} -m ${mcnf} && exit"
		serverCommand="cd ${resultsDIR} && ./init_server.sh -w ${wcnf} -m ${mcnf} && exit"
		ssh root@node-a8-${clientNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$clientCommand" &
		sleep 2
		ssh root@node-a8-${serverNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$serverCommand" > /dev/null 2>&1 &
		wait $!

		if [[ $first -eq 1 ]] ; then
			echo "			First iteration				"
			LAST="${clientConsumption}W${wcnf}_M${mcnf}.oml"
			first=0
		else
			echo "			Got to second iteration, gonna compare now!	LAST=$LAST ACTUAL=${consumptionDIR}a8-${clientNode}.oml	"
			CMP="$(cmp -s $LAST ${consumptionDIR}a8-${clientNode}.oml)"
			while [[ $? -eq 0 ]] ; do
				echo "			Still not updated...			"
				sleep 10
				CMP="$(cmp -s $LAST ${consumptionDIR}a8-${clientNode}.oml)"
			done
			LAST="${clientConsumption}W${wcnf}_M${mcnf}.oml"
		fi
		
		END_EPOCH="$(date +%s)"

		cp ${consumptionDIR}a8-${clientNode}.oml ${clientConsumption}W${wcnf}_M${mcnf}.oml
		cp ${consumptionDIR}a8-${serverNode}.oml ${serverConsumption}W${wcnf}_M${mcnf}.oml

		${grenobleResults}clean_files -f ${clientConsumption}W${wcnf}_M${mcnf}.oml -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/client_csv/"
		${grenobleResults}clean_files -f ${serverConsumption}W${wcnf}_M${mcnf}.oml -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/server_csv/"
	done
done 

echo "			STARTING NEXT LOOP -- LAST: $LAST 			"

for mcnf in "${M_CONFIG[@]:0:$MVALUES}"
do
	INIT_EPOCH="$(date +%s)"
	clientCommand="cd ${resultsDIR} && ./init_client.sh -i ${serverIP} -p ${serverPort} -w 16 -m ${mcnf} && exit"
	serverCommand="cd ${resultsDIR} && ./init_server.sh -w 16 -m ${mcnf} && exit"
	ssh root@node-a8-${clientNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$clientCommand" &
	sleep 2
	ssh root@node-a8-${serverNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$serverCommand" > /dev/null 2>&1 &
	wait $!

	CMP="$(cmp -s $LAST ${consumptionDIR}a8-${clientNode}.oml)"
	while [[ $? -eq 0 ]] ; do
		echo "			Still not updated..."
		sleep 10
		CMP="$(cmp -s $LAST ${consumptionDIR}a8-${clientNode}.oml)"
	done
	LAST="${clientConsumption}W16_M${mcnf}.oml"

	END_EPOCH="$(date +%s)"

	cp ${consumptionDIR}a8-${clientNode}.oml ${clientConsumption}W16_M${mcnf}.oml
	cp ${consumptionDIR}a8-${serverNode}.oml ${serverConsumption}W16_M${mcnf}.oml

	${grenobleResults}clean_files -f ${clientConsumption}W16_M${mcnf}.oml -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/client_csv/"
	${grenobleResults}clean_files -f ${serverConsumption}W16_M${mcnf}.oml -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/server_csv/"

done

echo "			STARTING NEXT LOOP -- LAST: $LAST 			"

for wcnf in "${W_CONFIG[@]}"
do
	INIT_EPOCH="$(date +%s)"
	clientCommand="cd ${resultsDIR} && ./init_client.sh -i ${serverIP} -p ${serverPort} -w ${wcnf} -m 100 && exit"
	serverCommand="cd ${resultsDIR} && ./init_server.sh -w ${wcnf} -m 100 && exit"
	ssh root@node-a8-${clientNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$clientCommand" &
	sleep 2
	ssh root@node-a8-${serverNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$serverCommand" > /dev/null 2>&1 &
	wait $!

	CMP="$(cmp -s $LAST ${consumptionDIR}a8-${clientNode}.oml)"
	while [[ $? -eq 0 ]] ; do
		echo "			Still not updated..."
		sleep 10
		CMP="$(cmp -s $LAST ${consumptionDIR}a8-${clientNode}.oml)"
	done
	LAST="${clientConsumption}W${wcnf}_M100.oml"

	END_EPOCH="$(date +%s)"

	cp ${consumptionDIR}a8-${clientNode}.oml ${clientConsumption}W${wcnf}_M100.oml
	cp ${consumptionDIR}a8-${serverNode}.oml ${serverConsumption}W${wcnf}_M100.oml

	${grenobleResults}clean_files -f ${clientConsumption}W${wcnf}_M100.oml -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/client_csv/"
	${grenobleResults}clean_files -f ${serverConsumption}W${wcnf}_M100.oml -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/server_csv/"
done
