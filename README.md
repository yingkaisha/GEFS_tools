# GEFS_tools

This repository contains tools for accessing and processing GEFS forecasts.

## The `GEFS` folder

The `GEFS` folder contains Python and Bash scripts that access and pre-process the operational GEFS. 

Currently, the main routine downloads GEFS 0.25-degree ensemble mean fields from the NOAA Operational Model Archive and Distribution System (NOMADS) to the WFRT server. Spatial-temproal subsetting is planned as the next step.

## The `NAEFS` folder

The `NAEFS` folder contains Bash scripts that reformat the opertional NAEFS files into netCDF4 with user-defined variables, ensemble members, and spatial-temporal coverage. 

The main routine is based on the archived NAEFS `*.tgz` files stored in the WFRT G-Suite. The NAEFS files should be cloned from the cloud before executing the main routine.
