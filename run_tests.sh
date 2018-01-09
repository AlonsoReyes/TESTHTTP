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

# Gets the number of the nodes in use from the IPs.
clientNode="$(echo $clientIP | cut -d'.' -f4)"
serverNode="$(echo $serverIP | cut -d'.' -f4)"

# Grants execution permission to the bash files just in case they don't have it and creates the necessary directories.
ssh root@node-a8-${serverNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "chmod +x ${resultsDIR}/*.sh && ${resultsDIR}init_dirs.sh && exit"

INIT_EPOCH=0
END_EPOCH=0
MID_EPOCH=0

for mcnf in "${M_CONFIG[@]:0:4}"
do
	for wcnf in "${W_CONFIG[@]:1:4}"
	do  
		# Starts up sever node and client after.
		clientCommand="cd ${resultsDIR} && ./init_client.sh -i ${serverIP} -p ${serverPort} -w ${wcnf} -m ${mcnf} && exit"
		serverCommand="cd ${resultsDIR} && ./init_server.sh -w ${wcnf} -m ${mcnf} && exit"
		INIT_EPOCH="$(date +%s)"
		#echo "			Initial time epoch = $INIT_EPOCH			"
		ssh root@node-a8-${serverNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$serverCommand" > /dev/null 2>&1 &
		sleep 2
		ssh root@node-a8-${clientNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$clientCommand" 
		MID_EPOCH="$(date +%s)"
		wait $!
		END_EPOCH="$(date +%s)"
		#echo "			End time epoch = $END_EPOCH			"

		#cp ${consumptionDIR}a8-${clientNode}.oml ${clientConsumption}W${wcnf}_M${mcnf}.oml
		#cp ${consumptionDIR}a8-${serverNode}.oml ${serverConsumption}W${wcnf}_M${mcnf}.oml
		${grenobleResults}clean_files.sh -f ${consumptionDIR}a8-${clientNode}.oml -w ${wcnf} -m ${mcnf} -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/client_csv/"
		${grenobleResults}clean_files.sh -f ${consumptionDIR}a8-${serverNode}.oml -w ${wcnf} -m ${mcnf} -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/server_csv/"
		#echo "			Client 				"
		#${grenobleResults}clean_files.sh -f ${clientConsumption}W${wcnf}_M${mcnf}.oml -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/client_csv/"
		#echo "			Server 				"
		#${grenobleResults}clean_files.sh -f ${serverConsumption}W${wcnf}_M${mcnf}.oml -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/server_csv/"
		#echo "			MID EPOCH=$MID_EPOCH"
	done
done 

# After this it's all the same. 

for mcnf in "${M_CONFIG[@]:0:$MVALUES}"
do
	clientCommand="cd ${resultsDIR} && ./init_client.sh -i ${serverIP} -p ${serverPort} -w 16 -m ${mcnf} && exit"
	serverCommand="cd ${resultsDIR} && ./init_server.sh -w 16 -m ${mcnf} && exit"
	INIT_EPOCH="$(date +%s)"
	ssh root@node-a8-${serverNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$serverCommand" > /dev/null 2>&1 &
	sleep 2
	ssh root@node-a8-${clientNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$clientCommand" 
	wait $!
	END_EPOCH="$(date +%s)"

	${grenobleResults}clean_files.sh -f ${consumptionDIR}a8-${clientNode}.oml -w 16 -m ${mcnf} -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/client_csv/"
	${grenobleResults}clean_files.sh -f ${consumptionDIR}a8-${serverNode}.oml -w 16 -m ${mcnf} -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/server_csv/"
		
done

echo "			STARTING NEXT LOOP -- LAST: $LAST 			"

for wcnf in "${W_CONFIG[@]}"
do
	clientCommand="cd ${resultsDIR} && ./init_client.sh -i ${serverIP} -p ${serverPort} -w ${wcnf} -m 100 && exit"
	serverCommand="cd ${resultsDIR} && ./init_server.sh -w ${wcnf} -m 100 && exit"
	INIT_EPOCH="$(date +%s)"
	ssh root@node-a8-${serverNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$serverCommand" > /dev/null 2>&1 &
	sleep 2
	ssh root@node-a8-${clientNode}.grenoble.iot-lab.info -o StrictHostKeyChecking=no "$clientCommand" 
	wait $!
	END_EPOCH="$(date +%s)"

	${grenobleResults}clean_files.sh -f ${consumptionDIR}a8-${clientNode}.oml -w ${wcnf} -m 100 -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/client_csv/"
	${grenobleResults}clean_files.sh -f ${consumptionDIR}a8-${serverNode}.oml -w ${wcnf} -m 100 -b $INIT_EPOCH -e $END_EPOCH -d "${grenobleResults}consumption/server_csv/"
		
done
