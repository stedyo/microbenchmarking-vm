#!/bin/bash


`iperf3 -u -c 10.0.0.106 -b 1024M -i 1 -t 100 -l 63K --get-server-output`