#!/bin/bash

# ----------- READ FROM CONFIG FILE 
base=`pwd`
relative="/../CONFIG/latency.config"
source $base$relative

# ----------- PATH OF MEASUREMENTS FILES
LATENCY_PATH=$(echo "$base/LATENCY_DATA")

if [ ! -d "$LATENCY_PATH" ]; then
	`mkdir -p $LATENCY_PATH`
fi


# ----------- FUNCTIONS ------------ #
# Assign target domains to arraymap "targetdomains"
function read_target_domains(){
	IFS=,
	arr=($TARGET_DOMAIN_IP)

	for key in "${!arr[@]}"; 
	do 
		IFS== read domainname ipaddress <<< ${arr[$key]}
		targetdomains[$domainname]=$ipaddress
	done
}


#----------------------------------- #
# -------------- MAIN -------------- #
#----------------------------------- #

#@function call --- map target domains
read_target_domains

#-------------------------------------- #
#-------------------------------------- #
# 		QOS METRIC: RTT LATENCY 		#
#-------------------------------------- #
#-------------------------------------- #


echo "PING COUNT $PING_COUNT"

PING_RTT_COMMAND=$(ping -c $PING_COUNT -s $PACKET_SIZE -i $INTERIM_DATA ${targetdomains[$domainid]})

echo $PING_RTT_COMMAND