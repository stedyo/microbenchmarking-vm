#!/bin/bash

# ----------- READ FROM CONFIG FILE 
base=`pwd`
relative="/../CONFIG/throughput.config"
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
	# - check if it's listening on 12865 port

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
# -H 			specify the target host (in this case, the virtual machine ip)
# -l 			test lenght = overall time spend on this experiment.
# -t UDP_STREAM = UDP as transport protocol 
# -f K = 		set measurement unit in Kb
# -- -m 		set packet size (KB)
# -D 			interval for printing throughput data
# -P 			hide headers banners

NETPERF_THROUGHPUT_COMMAND=$(netperf -H ${targetdomains[$domainid]} -P 0 -D $INTERIM_DATA -l $EXPERIMENT_TIME -t UDP_STREAM -f K -- -m $PACKET_SIZE )

# if target domain netperf is up, then we execute the command
if [[ ! " ${dontnetperf[@]} " =~ " ${domainid} " ]]; then

	# check if output file doesn't exist ... if not, creates it
	if [ ! -f "$THROUGHPUT_PATH/$ipaddress.file" ]; then
		`echo -n "" > $THROUGHPUT_PATH/$ipaddress.file`
	fi

	# timestamp checkpoint
	INIT_TIMESTAMP=`date  +%Y-%m-%d:%H:%M:%S`

	`echo "--- $INIT_TIMESTAMP --- " >> $THROUGHPUT_PATH/$ipaddress.file`

		OUTPUT_COMMAND=$(echo $NETPERF_THROUGHPUT_COMMAND | grep '^Interim')
		# Kbytes/s
		THROUGHPUT_DATA=$(echo $OUTPUT_COMMAND | awk -F ' ' '{print $3}')

		echo $NETPERF_THROUGHPUT_COMMAND
	`echo "$THROUGHPUT_DATA" >> $THROUGHPUT_PATH/$ipaddress.file`
	`echo "--- END --- " >>  $THROUGHPUT_PATH/$ipaddress.file`
else
	echo "$domainid can't established connection with netperf server"
fi
