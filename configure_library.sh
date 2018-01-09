#!/bin/bash


. ./available_nodes.sh

COMM="cd /home/root/A8/nghttp2-1.28.0; ./configure && make && exit"

echo "			Start configuration"
echo "			Connecting to node ${NODES[0]}"
ssh root@node-a8-${NODES[0]}.grenoble.iot-lab.info "$COMM"
echo "			End configuration"