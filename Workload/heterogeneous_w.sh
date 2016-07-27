#!/bin/bash


base=`pwd`
relative="/HETEROGENEOUS_PATH"

path="$base$relative"

`nohup  "$path/heterogeneo-1.sh" & "$path/heterogeneo-2.sh" & "$path/heterogeneo-3.sh" & "$path/heterogeneo-4.sh" & "$path/heterogeneo-5.sh" & "$path/heterogeneo-6.sh" & "$path/heterogeneo-7.sh" &`


