#!/bin/bash

EXPECTED_VARIABLES="GIT_TOKEN GIT_OWNER GIT_REPOSITORY GIT_ACTION"
for expect in $EXPECTED_VARIABLES; do
  if [ -z "${!expect}" ]; then
    echo "Missing environment variable $expect"
    exit 1
  fi
done

if [ -z "$1" ]; then
    echo "Must pass list of ips"
    exit 1
fi
ips="$1"
number_pids_per_container=2
pid_count=0
payload=""

# Iterate through text file, line by line
while IFS= read -r ip; do
  # skip blank lines
  if ! [ -z $ip ]; then
    pid_count=$((pid_count+1))
    # echo "IP: $ip"
    payload="$payload,$ip"
    # Send off payload, if the pid_count == $number_pids_per_container
    if [ $pid_count -eq $number_pids_per_container ]; then
      # Remove leading comma from payload
      payload=$(echo $payload | sed -e 's/^,//g')
      # echo "Payload: $payload"

      # Send payload
      echo "Action: ${GIT_ACTION}"
      echo "Send: { \"ips\": \"${payload}\" }"
      echo "To: https://api.github.com/repos/${GIT_OWNER}/${GIT_REPOSITORY}/dispatches"
      curl -s -H "Accept: application/vnd.github.everest-preview+json" \
        -H "Authorization: token ${GIT_TOKEN}" \
        --request POST \
        --data '{"event_type": "'$GIT_ACTION'", "client_payload": { "ips": "'$payload'" }}' \
        https://api.github.com/repos/${GIT_OWNER}/${GIT_REPOSITORY}/dispatches

      # Reset payload variables
      payload=""
      pid_count=0
      echo "--------------------------------------"
    fi
  fi
done < "$ips"
