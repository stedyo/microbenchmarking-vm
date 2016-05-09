#!/bin/bash

# ----------- READ FROM CONFIG FILE 
base=`pwd`
relative="/../vars.config"
source $base$relative

# ----------- PATH OF MEASUREMENTS FILES
THROUGHPUT_PATH=$(echo "$base/THROUGHPUT_DATA")


if [ ! -d "$THROUGHPUT_PATH" ]; then
	`mkdir -p $THROUGHPUT_PATH`
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


function target_domains_status(){
	# iterate through targets domains U
	# - check if it's up
	# - check if it's listening on 12865 and 5201 ports
	for domainid in "${!targetdomains[@]}"; do
	
		domainaddress=${targetdomains[$domainid]}

		# check if domain is up 
		ping -q -c2 $domainaddress > /dev/null
		if [ $? -eq 0 ]; then
			echo "$domainid - $domainaddress is up"
		else
			echo "$domainid - $domainaddress is down"
			shutdowndomain+=($domainid)
		fi

		# check if target domains is listening on netperf port :: 12865
		nc -z -q 2 $domainaddress 12865 &> /dev/null
		if [ $? -eq 0 ]; then
			echo "$domainid - $domainaddress is listening on port 12865"
		else
			echo "$domainid - $domainaddress is NOT listening on port 12865"
			dontnetperf+=($domainid)
		fi
		
		# check if target domains is listening on iperf port :: 5201
		nc -z -q 2 $domainaddress 5201 &> /dev/null
		if [ $? -eq 0 ]; then
			echo "$domainid - $domainaddress is listening on port 5201"
		else
			echo "$domainid - $domainaddress is NOT listening on port 5201"
			dontiperf+=($domainid)
		fi
		echo "################"
	done
}



#----------------------------------- #
# -------------- MAIN -------------- #
#----------------------------------- #


#@function call --- map target domains
read_target_domains
#@function call --- check domains status
target_domains_status

#-------------------------------------- #
#-------------------------------------- #
# QOS METRIC: THROUGHPUT MEASUREMENT
#-------------------------------------- #
#-------------------------------------- #
# --- NETPERF COMMAND LINE
#
# -H specify the target host (in this case, the virtual machine ip)
# -l (test lenght) = iteration time would be 2 seconds.
# -t UDP_STREAM = UDP as transport protocol 
# -- -m (packet size) measured on KB

netperf_throughput_command=$(netperf -H ${targetdomains[$domainid]} -D 1.5 -t UDP_STREAM -- -m 100)

echo $netperf_throughput_command

# if target domain netperf is up, then we execute the command
#if [[ ! " ${dontnetperf[@]} " =~ " ${domainid} " ]]; then
#
	# ---------------------------------------------------- #
	# START INFINITE LOOP - WAITING UP FOR SIGNALING TO STOP
	# ---------------------------------------------------- #
#
#	while true; do
#		echo $netperf_throughput_command
#		timestamp=`date +%Y-%m-%d:%H:%M:%S.%N`
#		throughputvalue=$(echo $netperf_throughput_command | awk 'END {print $5}')
#		echo "$timestamp :: $throughputvalue"	
#	done
#else
#	echo "$domainid can't established connection with netperf server"
#fi








