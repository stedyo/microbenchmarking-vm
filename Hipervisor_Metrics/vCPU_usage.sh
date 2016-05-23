#!/bin/bash

declare -A targetdomains

# -------- READ FRM CONFIG FILE
base=`pwd`
relative="/../CONFIG/vcpu_usage.config"
source $base$relative


# -------- PATH OF MEASUREMENTS FILES
VCPUSAGE_PATH=$(echo "$base/VCPUSAGE_DATA")

if [ ! -d "$VCPUSAGE_PATH"  ]; then
	`mkdir -p $VCPUSAGE_PATH`
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

# xentop
# -b display output as bash 
# -d delay between displayed data (set for every 1 second)
# -i number of iteration xentop should do before exit
# -r skip the header
# -line-buffered is a feature from grep that allows display streaming data
# vcpu consume (%)

XENTOP_COMMAND=$(xentop -b -d $INTERIM_DATA -i $EXPERIMENT_TIME -r 0 | grep --line-buffered $domainname |  awk -F" " '{print $3}')

echo $XENTOP_COMMAND

# check if output file doesn't exist ... if not, creates it
if [ ! -f "$VCPUSAGE_PATH/$ipaddress.file" ]; then
	`echo -n "" > $VCPUSAGE_PATH/$ipaddress.file`
fi

# timestamp checkpoint
INIT_TIMESTAMP=`date  +%Y-%m-%d:%H:%M:%S`
`echo "--- $domainname --- $INIT_TIMESTAMP --- " >> $VCPUSAGE_PATH/$ipaddress.file`


OUTPUT_COMMAND=$(echo $XENTOP_COMMAND)
echo $OUTPUT_COMMAND
`echo "$OUTPUT_COMMAND" >> $VCPUSAGE_PATH/$ipaddress.file`

`echo "--- END --- " >>  $VCPUSAGE_PATH/$ipaddress.file`



