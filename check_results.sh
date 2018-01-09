#!/bin/bash

CLIENT_RESULTS="/senslab/users/reyes/A8/results/consumption/client_csv/*"
SERVER_RESULTS="/senslab/users/reyes/A8/results/consumption/server_csv/*"

for file in $CLIENT_RESULTS ; do
	if ! [[ -s "$file" ]] ; then
		echo "$file is empty."
	fi
done

for file in $SERVER_RESULTS ; do
	if ! [[ -s "$file" ]] ; then
		echo "$file is empty."
	fi
done