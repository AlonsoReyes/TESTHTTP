#!/bin/bash

USER="aaaa"
SITE="grenoble"
while getopts u:s: opt
do
	case "${opt}"
	in
		u) USER=${OPTARG};;
		s) SITE=${OPTARG};;
	esac
done

COMM="cd A8; mkdir results; mkdir test_server; wget 'https://github.com/nghttp2/nghttp2/releases/download/v1.28.0/nghttp2-1.28.0.tar.gz'; tar -xf nghttp2-1.28.0.tar.gz; cd nghttp2-1.28.0; ./configure && make && exit"
ssh ${USER}@${SITE}.iot-lab.info "$COMM"
