#!/bin/bash

if [ -z "$1" ]; then
    echo "Must pass comma separated list (no spaces) of ips as first argument"
    exit 1
fi
ips="$1"

# Iterate through csv of ips
IFS=',' read -ra ADDR <<< "$ips"
for ip in "${ADDR[@]}"; do
    echo "IP: $ip"
    ip_filename=$(echo $ip | sed -e 's/\./-/g')

    # Run some process, save output to log, and send to background
    ping -q -c 1 $ip | tee "log-${ip_filename}.txt" &
done

# Timeout to wait for background processes to finish
sleep 10

zip logs.zip log-*

