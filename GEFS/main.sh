#!/bin/bash

# The main GEFS pre-processing routine
# ---------------------------------------------------
#     Check if today's GEFS files exists.
#     Download the ensemble mean.
#     (Planned) subset to given variables and domain.

download_log='GEFS_download.log'
current_time=$(date -u +%Y%m%d)

while [ 1 -le 2 ]
do
    python GEFS_download.py $current_time
    
    log_info=$(cat $download_log)
    flag_success=$[10#${log_info:0:2}]
    
    if [ $flag_success == "0" ]; then
        echo "GEFS_download.py: pending on new files. Sleep 30 min ..."
        sleep 1800
    else
        echo "GEFS_download.py: completed."
        exit 1
    fi
done