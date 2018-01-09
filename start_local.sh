#!/bin/bash

USER="example"
SITE="grenoble"
while getopts u:s: opt
do
	case "${opt}"
	in
		u) USER=${OPTARG};;
		s) SITE=${OPTARG};;
	esac
done

echo "			USER: $USER --- SITE: $SITE				"

COMM="cd A8; mkdir results; mkdir test_server; wget 'https://github.com/nghttp2/nghttp2/releases/download/v1.28.0/nghttp2-1.28.0.tar.gz'; \
tar -xf nghttp2-1.28.0.tar.gz; cd nghttp2-1.28.0;\
 ./configure && make && exit"
ssh ${USER}@${SITE}.iot-lab.info "$COMM"
echo "			Remember to have your server files in a directory called test_server in your local machine and inside the repository directory	"
#echo "Now you've got to upload the server files to the test_server directory and the .sh files to the results directory. And then run the start_exp.sh script"
sftp ${USER}@${SITE}.iot-lab.info:/senslab/users/${USER}/A8/results/ <<< $'put *.sh ' 
sftp ${USER}@${SITE}.iot-lab.info:/senslab/users/${USER}/A8/results/test_server <<< $'put test_server/*'

START_COMM="cd A8/results ; ./start_exp && exit"

ssh ${USER}@${SITE}.iot-lab.info "$START_COMM"

sftp ${USER}@${SITE}.iot-lab.info:/senslab/users/${USER}/A8/results/ <<< $'get A8_http2_client.csv \n get A8_http2_server.csv'


