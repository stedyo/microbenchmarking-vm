#!/bin/bash

declare -A targetdomains

# ----------- READ FROM CONFIG FILE 
base=`pwd`
relative="/../CONFIG/throughput_jitter_packetloss.config"
source $base$relative

# ----------- PATH OF MEASUREMENTS FILES
JITTER_PATH=$(echo "$base/JITTER_DATA")
PACKET_LOSS_PATH=$(echo "$base/PACKET_LOSS_DATA")
THROUGHPUT_PATH=$(echo "$base/THROUGHPUT_DATA")
DATAGRAM_COUNT_PATH=$(echo "$base/DATAGRAM_COUNT_PATH")

if [ ! -d "$JITTER_PATH" ]; then
	`mkdir -p $JITTER_PATH`
fi

if [ ! -d "$PACKET_LOSS_PATH" ]; then
	`mkdir -p $PACKET_LOSS_PATH`
fi

if [ ! -d "$THROUGHPUT_PATH" ]; then
	`mkdir -p $THROUGHPUT_PATH`
fi

if [ ! -d "$DATAGRAM_COUNT_PATH" ]; then
	`mkdir -p $DATAGRAM_COUNT_PATH`
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
	# - check if it's listening on 5201 port
	

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
# QOS METRIC: JITTER MEASUREMENT
# QOS METRIC: PACKET LOSS MEASUREMENT
#-------------------------------------- #
#-------------------------------------- #
# --- IPERF COMMAND LINE

# -f K  	format message size (KBytes/sec)
# -i  		interval for printing jitter data
# --udp		set UDP as transport protocol
# -c 		set target vm
# -t 		test lenght = overall time spend on this experiment.
# -l 		set packet size (KB)
# -b=0		prevent bandwidth from being limited


QOS_MEASUREMENT_COMMAND=$(iperf3 -u -c ${targetdomains[$domainid]} -b 1000M -i $INTERIM_DATA -t $EXPERIMENT_TIME -l $PACKET_SIZE --get-server-output)


# if target domain netperf is up, then we execute the command
if [[ ! " ${dontiperf[@]} " =~ " ${domainid} " ]]; then

	# timestamp checkpoint
	INIT_TIMESTAMP=`date  +%Y-%m-%d:%H:%M:%S`

	`echo "--- $domainid --- $INIT_TIMESTAMP --- " >> $PACKET_LOSS_PATH/$ipaddress.file`
	`echo "--- $domainid --- $INIT_TIMESTAMP --- " >> $JITTER_PATH/$ipaddress.file`
	`echo "--- $domainid --- $INIT_TIMESTAMP --- " >> $THROUGHPUT_PATH/$ipaddress.file`

		OUTPUT_COMMAND=$(echo $QOS_MEASUREMENT_COMMAND)
		echo $OUTPUT_COMMAND	

		# --------------
		# THROUGHPUT
		# --------------
		# JITTER
		# --------------
		# PACKET LOSS
		# --------------

		# string manipulation
		OUTPUT_1=$(echo "${OUTPUT_COMMAND##*Server output}")
		OUTPUT_2=$(echo "$OUTPUT_1" | sed '1,5d' | head -n -1)
		#throughput (mb/s)
		THROUGHPUT=$(echo "$OUTPUT_2" | awk -F" " '{print $5}')
		# jitter (ms)
		JITTER=$(echo "$OUTPUT_2" | awk -F" " '{print $9}')
		# packet loss (%)
		PACKET_LOSS=$(echo "$OUTPUT_2" | awk -F" " '{print $11}')
		
		echo $THROUGHPUT
		echo " --------- "
		echo $JITTER
		echo " --------- "
		echo $PACKET_LOSS
		echo " --------- "


		`echo "$THROUGHPUT" >> $THROUGHPUT_PATH/$ipaddress.file`
		`echo "$JITTER" >> $JITTER_PATH/$ipaddress.file`
		`echo "$PACKET_LOSS" >> $PACKET_LOSS_PATH/$ipaddress.file`


	`echo "--- END --- " >>  $PACKET_LOSS_PATH/$ipaddress.file`
	`echo "--- END --- " >>  $JITTER_PATH/$ipaddress.file`
	`echo "--- END --- " >>  $THROUGHPUT/$ipaddress.file`
else
	echo "$domainid can't established connection with iperf server"
fi
