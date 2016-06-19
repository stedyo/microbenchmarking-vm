#!/bin/bash

# assign credit parameters to heterogeneous pool
`xl sched-credit -s -p hetero-pool -t $1`
