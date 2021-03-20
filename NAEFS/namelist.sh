#!/bin/bash -l
# 
# The configuration file of `NAEFS_reformat.sh`.
# Tested by Kyle Sha <yingkai@eoas.ubc.ca>
#
# ------------------------- namelist ------------------------- #
# data_dir - file path of the *.tgz
# target_dir - file path for the reformatted outputs

data_dir="/glade/p/cisl/aiml/ksha/2015/"
target_dir="/glade/scratch/ksha/DATA/NAEFS/2015/"
perfix=""
# examples of output file names
# ${perfix}${date}_CMC_e${member}_f${fcst_time0}_f${fcst_time1}.nc
# ${perfix}${date}_NCEP_e${member}_f${fcst_time0}_f${fcst_time1}.nc

# ------------------------------------------------------------ #
# regrid - grid spacing by degree, 0 means no regridding
#          lat_size=181, so cannot have more coarse than 1-deg
# regrid_keys - regridding options
# subset_lat/lon - spatial subset by lat/lon degrees
# fcst_time# - start and end hours, assuming 6-hr file freq
# *_members_num - number of ensemble members, 21 max

regrid=0

subset_lat="24:85"
subset_lon="196:271"

fcst_time0=0
fcst_time1=360

cmc_members_num=0
ncep_members_num=21

# ------------------------------------------------------------ #
# pick variables (each is a pattern of the full grib table name)
# Kyle version:

vars=(":APCP:"
      ":TMP:2 m" 
      ":RH:850 mb" 
      ":HGT:850 mb" 
      ":TMP:850 mb" 
      ":UGRD:850 mb" 
      ":VGRD:850 mb" 
      ":VVEL:850 mb")

# ------------------------------------------------------------ #
# key words for wgrib2 commands

regrid_keys="-new_grid_winds earth -new_grid_interpolation bicubic -new_grid latlon "

# ------------------------------------------------------------ #
# namelist parsers (do not modify)

if [[ $regrid > 0 ]]; then
    Nlon=$((360/$regrid))
    Nlat=$((181/$regrid))
    regrid_parse="$regrid_keys 0:$Nlon:$regrid -90:$Nlat:$regrid"
fi

var_parse=$(printf "%s|"  "${vars[@]}")
var_parse=${var_parse::-1}
