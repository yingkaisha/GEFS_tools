#!/bin/bash -l

# --------------------------------------------
# Subetting operational NAEFS forecasts by:
# (1) latitude, longitude
# (2) variables
# (3) forecast lead times
# (4) number of CMC/NCEP ensemble members
#
# see `namelist.sh` for details
#
# A collaborative work among UBC WFRT members.
# file path is fixed to the WFRT Google Drive.
# --------------------------------------------

source namelist.sh
source _libs.sh

filenames=($(find ${data_dir}/*tgz -type f -printf "%f\n"))

for file in "${filenames[@]}"; do
    #file=${filenames[0]}
    temp_date=${file:0:10}
    echo -e "Datetime: $temp_date"
    echo -e "\tUnpacking originals"
    tar xf $data_dir$file -C $target_dir
    
    # check if file path exist
    if [ -d "${target_dir}${temp_date}" ]; then
        flag_path=true
        temp_dir=${target_dir}${temp_date}
        
    elif [ -d "${target_dir}/NAEFS/${temp_date}" ]; then
        flag_path=true
        temp_dir="${target_dir}/NAEFS/${temp_date}"
        
    elif [ -d "${target_dir}/scratch/ibcs/Datamart/NAEFS/${temp_date}" ]; then
        flag_path=true
        temp_dir="${target_dir}/scratch/ibcs/Datamart/NAEFS/${temp_date}"
    else
        flag_path=false
        echo -e "\tSkip, unpacking failed"
    fi
    
    if [ $flag_path == true ]; then
        # CMC operations
        if [[ $cmc_members_num > 0 ]]; then 
            echo -e "\tReformatting *$cmc_members_num* CMC members"
            for member_id in $(seq 0 $((cmc_members_num-1))); do
                member_id=$(printf "%02d" $member_id)
                cmcnames=($(find ${temp_dir}/cmc*${member_id}*t00z.pgrb2* -type f -printf "%f\n" | sort))
                basename=${cmcnames[0]}
                # missing checks
                quality_check "${basename::-4}" "$temp_dir" "${cmcnames[@]}"
                # grib operation
                if [ $flag_good == true ]; then
                    temp_outname=${perfix}${temp_date}_CMC_e${member_id}_f${fcst_time0}_f${fcst_time1}
                    for temp_file in "${picknames[@]}"; do
                        wgrib_opt $temp_dir $temp_file > /dev/null
                    done
                    # netcdf conversion
                    cat ${target_dir}/${basename::-4}* > ${target_dir}/${temp_outname}.grb
                    wgrib2 ${target_dir}/${temp_outname}.grb -nc4 -netcdf ${target_dir}/${temp_outname}.nc > /dev/null
                    rm ${target_dir}/*.grb
                    rm ${target_dir}/*pgrb2*
                    echo -e "\t\t${target_dir}/${temp_outname}.nc"
                else
                    echo -e "\tSkip $temp_date/${basename::-4}"
                fi
            done
        fi
        # NCEP operations
        if [[ $ncep_members_num > 0 ]]; then
            echo -e "\tReformatting *$ncep_members_num* NCEP members"
            for member_id in $(seq 0 $((ncep_members_num-1))); do
                member_id=$(printf "%02d" $member_id)
                ncepnames=($(find ${temp_dir}/ncep*${member_id}*t00z.pgrb2* -type f -printf "%f\n" | sort))
                basename=${ncepnames[0]}
                # missing checks
                quality_check "${basename::-4}" "$temp_dir" "${ncepnames[@]}"
                # grib operation
                if [[ $flag_good == true ]]; then
                    temp_outname=${perfix}${temp_date}_NCEP_e${member_id}_f${fcst_time0}_f${fcst_time1}
                    for temp_file in "${picknames[@]}"; do
                        wgrib_opt $temp_dir $temp_file > /dev/null
                    done
                    # netcdf conversion
                    cat ${target_dir}/${basename::-4}* > ${target_dir}/${temp_outname}.grb
                    wgrib2 ${target_dir}/${temp_outname}.grb -nc4 -netcdf ${target_dir}/${temp_outname}.nc > /dev/null
                    rm ${target_dir}/*.grb
                    rm ${target_dir}/*pgrb2*
                    echo -e "\t\t${target_dir}/${temp_outname}.nc"
                else
                    echo -e "\tSkip $temp_date/${basename::-4}"
                fi
            done
        fi
        rm -r $temp_dir
    fi
done
