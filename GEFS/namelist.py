
# local path that stores GEFS files. 
# Formatter is the name of sub-folder.

# change is as: 'your_path/{}/'
target_path = '/glade/scratch/ksha/DATA/GEFS/{}/'

# The source of files. Formatter is the file name 
url_fmt = 'https://nomads.ncep.noaa.gov/pub/data/nccf/com/gens/prod/gefs.{}/00/atmos/pgrb2sp25/{}'

# The file name of GEFS ensemble mean.
# Formatter is the forecast lead time
filename = 'geavg.t00z.pgrb2s.0p25.f{}'

# A list of forecast lead times.
fcst_leads = ['009', '012', '015', '018', '021', '024', '027', '030', '033', '036', '039', '042', '045',
         '048', '051', '054', '057', '060', '063', '066', '069', '072', '075', '078', '081', '084',
         '087', '090', '093', '096', '099', '102', '105', '108', '111', '114', '117', '120', '123',
         '126', '129', '132', '135', '138', '141', '144', '147', '150', '153', '156', '159', '162',
         '165', '168']


