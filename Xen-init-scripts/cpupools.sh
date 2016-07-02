#!/bin/bash

# creating heterogeneous pool
`xl cpupool-create name=\"hetero-pool\"`
`xl cpupool-cpu-remove Pool-0 1`
`xl cpupool-cpu-add hetero-pool 1`

# creating cpubound pool
`xl cpupool-create name=\"cpubound-pool\"`
`xl cpupool-cpu-remove Pool-0 2`
`xl cpupool-cpu-add cpubound-pool 2`
`xl cpupool-cpu-remove Pool-0 3`
`xl cpupool-cpu-add cpubound-pool 3`


