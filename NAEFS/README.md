# NAEFS reformatting scripts

This folder contains bash scripts that reformat the [NAEFS](#further-readings) `*.tgz` files 
into `netCDF4` with user-defined variables, ensemble members, and spatial-temporal coverage.

# Usage
1. copy and modify the `namelist.sh` to specify reformatting requirements.
2. In `NAEFS_reformat.sh`, "source" your customized namelist.
3. execute `NAEFS_reformat.sh`

# Dependency
* bash
* `wgrib2` with `netCDF4` support.

# Implementation Notes

* The original `*.tgz` files are available in the shared Google Drive of WFRT.
* `NAEFS_reformat.sh` must have access to `data_dir` and `target_dir` defined in the namelist.
* Temporal files will be generated during the unzip and conversion processes, which requires: 
    1. your `target_dir` has enough space.
    2. No other processes manipulate `target_dir` files. This also means if one has multiple `NAEFS_reformat.sh` runs, each run should have its own `target_dir`.
* `data_dir` will be passed to `find`, for file path with space, it should be specified as `"/drive/xxx/bad[[:space:]]space[[:space:]]dir/"`.
* `NAEFS_reformat.sh` handles file information when it begins to run. Adding new files to `data_dir` on-the-fly will have no effect.

# Contributors

* Justin Haw
* Yingkai (Kyle) Sha <yingkai@eoas.ubc.ca>
* Eve Wicksteed

# Further readings

The North American Ensemble Forecast System (NAEFS) is an 
ensemble weather forecasting project supported
by the Meteorological Service of Canada (MSC), 
the United States National Weather Service (NWS) and 
the National Meteorological Service of Mexico (NMSM)[^1].

NAFES initializes four times per day at 00:00, 06:00, 12:00, and 18:00 UTC. 
It has a 16-day forecast horizon with 6 hours output frequency (0-384 forecasted hours). 
NAEFS provides 42 ensemble members, with 21 members obtained from the 
US Global Ensemble Forecast System (GEFS) and the other 21 members obtained from
the Canadian Global Ensemble Prediction System (GEPS). 
Each set of 21 members includes a control run and 20 initial condition perturbations[^2]. 

The GEFS and GEPS members are produced by the NWS Global Forecast System (GFS), 
and the MSC Global Environmental Multiscale Model (GEM), respectively. 
The native resolutions of GFS and GEM are roughly 50 km, 
and their combined ensemble version, the NAEFS, is re-gridded to regular 
latitude-longitude grids and distributed with either 1-degree (from 2004 to July 18, 2018) 
or 0.5-degree grid spacings (from July 19, 2018[^3] to the present).

UBC WFRT archives the NAFES 00:00 UTC runs daily. The tape archive 
from 2014 to December 2019 is compressed and stored in the Team Drive of WFRT G Suite. 
This WFRT archive is unofficial and incomplete, all the missing dates, files, and variables cannot be recovered.

The near-real-time NAEFS products are available at the NCEP [FTP](ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/naefs/prod/)
server and the [NOAA Operational Model Archive and Distribution System (NOMADS)](http://nomads.ncep.noaa.gov/pub/data/nccf/com/naefs/prod).
The changelog of GEFS and GEPS are available at the [National Centers for Environmental Prediction (NCEP) Central Operations](https://www.nco.ncep.noaa.gov/pmb/changes/),
[NCEP Modeling Center](https://www.emc.ncep.noaa.gov/gmb/yzhu/html/ENS_IMP.html), 
and the [CMC implementation page](https://collaboration.cmc.ec.gc.ca/cmc/cmoi/product_guide/docs/changes_e.html).

Several equivalents of the NAEFS GEFS members are listed as follows:

* The GEFS 003 domain 21 ensemble members are obtained from the same GFS runs that produces the NAEFS, 
but are re-gridded to 1-degree grid spacing. This data is distributed through the
[National Centers for Environmental Information (NCEI)](https://www.ncdc.noaa.gov/data-access/model-data/model-datasets/global-ensemble-forecast-system-gefs).

* The GEFS reforecast version 2 is statistically consistent with the operational
GEFS, and can be accessed through the [Physical Science Laboratory (PSL)](https://psl.noaa.gov/forecasts/reforecast2/download.html).
This data contains both 1-degree regular latitude-longitude grid and T254/T190 Gaussian grid versions, and is available from 1985 to present.
The GEFS reforecast provides 11 ensemble members with the ensemble mean and spread.

Other post-processed NAEFS products are listed as follows: 

* [NCEP Products Inventory (Ensemble mean, bias-corrected, and downscaled products)](https://www.nco.ncep.noaa.gov/pmb/products/naefs/)
* [Ensemble Kernel Density MOS (EKDMOS), NWS](https://www.weather.gov/mdl/ekdmos_home)
* [NAEFS probability maps of weather events over time intervals](https://weather.gc.ca/ensemble/naefs/produits_e.html)
* [EPSgrams for NAEFS Based on Ensemble and Deterministic Forecasts](https://weather.gc.ca/ensemble/naefs/EPSgrams_e.html)

**Reference**

[^1]: [North American Ensemble Forecast System (NAEFS), Environment and natural resources, Government of Canada](https://weather.gc.ca/ensemble/naefs/index_e.html)
[^2]: [Ensemble Situation Awareness Table, National Weather Service](https://satable.ncep.noaa.gov/naefs/)
[^3]: [Upgrade of GEFS/NAEFS Bias-Corrected and Downscaled Products, Service Change Notice, National Weather Service](https://www.weather.gov/media/notification/pdfs/scn18-50naefs_gefsaaa.pdf)

