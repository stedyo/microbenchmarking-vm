#!/bin/bash
declare -A targetdomains

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


function target_domains_status(){
	# iterate through targets domains U
	# - check if it's up
	# - check if it's listening on 12865 port

	for domainid in "${!targetdomains[@]}"; do
	
		domainaddress=${targetdomains[$domainid]}

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
# QOS METRIC: LATENCY MEASUREMENT
#-------------------------------------- #
#-------------------------------------- #

# ping tool (define RTT time)
# ouput data in milliseconds ()
	
PING_LATENCY_COMMAND=$(ping ${targetdomains[$domainid]} -c $EXPERIMENT_TIME -n)

# if target domain netperf is up, then we execute the command
if [[ ! " ${dontnetperf[@]} " =~ " ${domainid} " ]]; then

	# check if output file doesn't exist ... if not, creates it
	if [ ! -f "$LATENCY_PATH/$ipaddress.file" ]; then
		`echo -n "" > $LATENCY_PATH/$ipaddress.file`
	fi

	# timestamp checkpoint
	INIT_TIMESTAMP=`date  +%Y-%m-%d:%H:%M:%S`

	`echo "--- $domainid --- $INIT_TIMESTAMP --- " >> $LATENCY_PATH/$ipaddress.file`

		
		OUTPUT_COMMAND=$(echo $PING_LATENCY_COMMAND | sed '1d' | head -n -2)
		OUTPUT_1=$(echo $OUTPUT_COMMAND | awk -F" " '{print $7}')
	

		printf '%s\n' "$OUTPUT_1" | while IFS= read -r line
		do
	   		LATENCY=${line#*=}
   			`echo "$LATENCY" >>  $LATENCY_PATH/$ipaddress.file`	
		done			

	`echo "--- END --- " >>  $LATENCY_PATH/$ipaddress.file`
else
	echo "$domainid can't established connection with netperf server"
fi









