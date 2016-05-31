#!/bin/bash
# act as a cpu-bound virtual machine



base=`pwd`
CPUBOUND_PATH="/../CPU-BOUND"
COMPRESS_PATH=$(echo "$base/CPUBOUND_PATH")

# if path doesn't exists, creates it

if [ ! -d "$COMPRESS_PATH" ]; then
        `mkdir -p $COMPRESS_PATH`
fi




while true; do
	`find $COMPRESS_PATH -type f -exec rm -f '{}' \+`
	BREAKLOOP=50
	for ((i=1;i<=BREAKLOOP;i++)); do
			
		INIT_TIMESTAMP=`date  +%Y-%m-%d:%H:%M:%S`

		`touch "$COMPRESS_PATH/$i.txt"`
		
		`cd $COMPRESS_PATH && tar -zcf $i.tar.gz $i.txt`
	done

done



