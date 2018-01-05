#!/bin/bash

resultsDIR="/home/root/A8/results/"
W_CONFIG=($(seq 8 1 16))
M_CONFIG=($(seq 1 1 8))	
M_CONFIG=("${M_CONFIG[@]}" 100)

echo "			Creating necessary directories!			"
# echo "M Values:"
# echo "${M_CONFIG[@]}"
# echo "W Values:"
# echo "${W_CONFIG[@]}"

mkdir -p ${resultsDIR}consumption/client_raw
mkdir -p ${resultsDIR}consumption/server_raw
mkdir -p ${resultsDIR}consumption/client_csv
mkdir -p ${resultsDIR}consumption/server_csv


for mcnf in "${M_CONFIG[@]:0:4}"
do
	for wcnf in "${W_CONFIG[@]:1:4}"
	do  
		#mkdir -p ${resultsDIR}consumption/W${wcnf}_M${mcnf}
		mkdir -p ${resultsDIR}srv_top/W${wcnf}_M${mcnf} 
		mkdir -p ${resultsDIR}cl_top/W${wcnf}_M${mcnf} 
		mkdir -p ${resultsDIR}cl_req/W${wcnf}_M${mcnf} 
	done
done 

for mcnf in "${M_CONFIG[@]}"
do
	#mkdir -p ${resultsDIR}consumption/W16_M${mcnf} 
	mkdir -p ${resultsDIR}srv_top/W16_M${mcnf} 
	mkdir -p ${resultsDIR}cl_top/W16_M${mcnf} 
	mkdir -p ${resultsDIR}cl_req/W16_M${mcnf} 

done

for wcnf in "${W_CONFIG[@]}"
do
	#mkdir -p ${resultsDIR}consumption/W${wcnf}_M100
	mkdir -p ${resultsDIR}srv_top/W${wcnf}_M100
	mkdir -p ${resultsDIR}cl_top/W${wcnf}_M100
	mkdir -p ${resultsDIR}cl_req/W${wcnf}_M100 
done

echo "			Setup done!			"
