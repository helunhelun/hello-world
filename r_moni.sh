#!/bin/bash

#set -x
file="$(date +%s)_mdata"
conn=$1
while true
do
    gpu_info=$(nvidia-smi -i 0 --format=csv,noheader,nounits \
        --query-gpu=utilization.gpu,memory.used,power.draw,temperature.gpu)
    #temp_cpu=$(sensors -A |  awk -F. '{ if(($1 ~ "Core") || ($1 ~ "Physical")){print $1}}')
    #temp_cpu=${temp_cpu//[a-zA-Z+]/}
    #temp_cpu=${temp_cpu//[0-9]:/:}
    temp_cpu=$(sensors -A |  awk -F. '{ if(($1 ~ "Physical") || ($1 ~ "loc1")){print $1}}')

    temp_cpu=${temp_cpu//[a-zA-Z+]/}

    docker_info=$(docker stats ${conn} --no-stream --format "{{.CPUPerc}}:{{.MemPerc}}")
    #echo  $(date +%s):${docker_info}:${gpu_info//,/:}${temp_cpu//[0-9]:/:}
    echo  $(date +%s):${docker_info}:${gpu_info//,/:}${temp_cpu//[0-9]:/:} >> ${file}

done
