#!/bin/bash -l

# The backend that calls file quality check and wgrib2 instances

quality_check() {
# Inputs: 
#    file_prefix, e.g., "ncep_gep01.t00z.pgrb2" 
#    path of the raw files, e.g., $target_dir/2016010100/
#    an array of file names, e.g., ("ncep_gep01.t00z.pgrb2f000" "ncep_gep01.t00z.pgrb2f006" ...) 
# Return:
#    picknames, an array of *valid* file names
#    flag_good, a boolean variable, true mean all fiels are good, can forward to the next step

    patterns=("$@")
    base=${patterns[0]}
    base_dir=${patterns[1]}
    names=("${patterns[@]:2}")
    flag_good=true
    picknames=()
    for fcst_id in $(seq -f "%03g" $fcst_time0 6 $fcst_time1); do
        temp_name=${base}f${fcst_id}
        filesize=$(stat -c%s "$base_dir/$temp_name")
        if [[ ("${names[@]}" =~ "${temp_name}") && ($filesize -ge 1800000) ]]; then
            picknames+=($temp_name)
        else
            echo -e "\t\tMissing or irregular file size: $temp_name"
            flag_good=false
        fi
    done
}

wgrib_opt() {
# Inputs:
#    path of the raw files, e.g., $target_dir/2016010100/
#    a valid file name, e.g., "ncep_gep01.t00z.pgrb2f000"
# No return

    # pick variables
    wgrib2 $1/$2 -s | grep -E "($var_parse)" | wgrib2 -i $1/$2 -grib "$1/temp_out.grb"
    # optional regridding
    if [[ $regrid > 0 ]]; then
        wgrib2 "$1/temp_out.grb" $regrid_parse "$1/temp_regrid.grb"
        mv "$1/temp_regrid.grb" "$1/temp_out.grb"
    fi
    # domain subset
    wgrib2 "$1/temp_out.grb" -small_grib $subset_lon $subset_lat $target_dir/$2
}
