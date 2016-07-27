#!/bin/bash


`iperf3 -u -c 10.0.0.100 -b 1024M -i 1 -t 1000 -l 4K --get-server-output &`
`iperf3 -u -c 10.0.0.101 -b 1024M -i 1 -t 1000 -l 4K --get-server-output &`
`iperf3 -u -c 10.0.0.102 -b 1024M -i 1 -t 1000 -l 4K --get-server-output &`
`iperf3 -u -c 10.0.0.104 -b 1024M -i 1 -t 1000 -l 4K --get-server-output &`
`iperf3 -u -c 10.0.0.105 -b 1024M -i 1 -t 1000 -l 4K --get-server-output &`
`iperf3 -u -c 10.0.0.106 -b 1024M -i 1 -t 1000 -l 4K --get-server-output &`
`iperf3 -u -c 10.0.0.107 -b 1024M -i 1 -t 1000 -l 4K --get-server-output &`
`iperf3 -u -c 10.0.0.108 -b 1024M -i 1 -t 1000 -l 4K --get-server-output &`