#!/bin/bash


`iperf3 -u -c 10.0.0.10 -b 1024M -i 1 -t 100 -l 4K --get-server-output`