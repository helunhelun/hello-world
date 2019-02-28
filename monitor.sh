#!/bin/bash

result=$1

sum_gpu_us=0
sum_gpu_mem=0
sum_gpu_power=0
sum_gpu_temperature=0
sum_cpu_us=0
sum_mem_us=0
count=0

if [ ! -f $result ];then #file is not exit
	touch $result
	>$result
fi

while true
do
	let count++
	# get system status and information
	gpu_info=$(nvidia-smi -i 0 --format=csv,noheader,nounits \
        --query-gpu=utilization.gpu,memory.used,power.draw,temperature.gpu)
	gpu_us=$(echo $gpu_info | awk -F "," '{print $1}')
	gpu_mem=$(echo $gpu_info | awk -F "," '{print $2}')
	gpu_power=$(echo $gpu_info | awk -F "," '{print $3}')
	gpu_temperature=$(echo $gpu_info | awk -F "," '{print $4}')
	cpu_id=$(top -n 1 | grep "Cpu(s)" | awk '{print $8}')
	cpu_us=$(echo "scale=3;100.0-$cpu_id" | bc)
	mem_us=$(free -m | grep "Mem:" | awk '{print $3}')
	# get summer of system
	sum_gpu_us=$(echo "scale=3;$sum_gpu_us+$gpu_us"|bc)
	sum_gpu_mem=$(echo "scale=3;$sum_gpu_mem+$gpu_mem"|bc)
	sum_gpu_power=$(echo "scale=3;$sum_gpu_power+$gpu_power"|bc)
	sum_gpu_temperature=$(echo "scale=3;$sum_gpu_temperature+$gpu_temperature"|bc)
	sum_cpu_us=$(echo "scale=3;$sum_cpu_us+$cpu_us"|bc)
	sum_mem_us=$(echo "scale=3;$sum_mem_us+$mem_us"|bc)
	#get averge 
	ave_gpu_us=$(echo "scale=3;$sum_gpu_us/$count"|bc)
	ave_gpu_mem=$(echo "scale=3;$sum_gpu_mem/$count"|bc)
	ave_gpu_power=$(echo "scale=3;$sum_gpu_power/$count"|bc)
	ave_gpu_temperature=$(echo "scale=3;$sum_gpu_temperature/$count"|bc)
	ave_cpu_us=$(echo "scale=3;$sum_cpu_us/$count"|bc)
	ave_mem_us=$(echo "scale=3;$sum_mem_us/$count"|bc)
	#get current time
	cur_time=$(date +"%Y-%m-%d %H:%M:%S")
	#output file
	echo "$cur_time  $ave_gpu_us $ave_gpu_mem $ave_gpu_power $ave_gpu_temperature $ave_cpu_us $ave_mem_us " >>result
	#echo "$gpu_us $gpu_mem $pu_power $gpu_temperature $cpu_id $cpu_us $mem_us"
	sleep 2
done




