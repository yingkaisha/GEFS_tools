from __future__ import absolute_import
from namelist import *

import os
import argparse
import subprocess
import urllib.request
from datetime import datetime

parser = argparse.ArgumentParser()
parser.add_argument('date_str', help='date_str. e.g., 20100101')
args = vars(parser.parse_args())

dt_fmt = args['date_str']

if dt_fmt == 'auto':
    # Get the current UTC datetime
    dt_fmt = datetime.strftime(datetime.utcnow(), '%Y%m%d')

print("Date: {}".format(dt_fmt))

# if today's sub folder exist
flag_path = os.path.isdir(target_path.format(dt_fmt))

# if not exist, creat through subprocess.Popen
if flag_path is False:
    subprocess.Popen(['mkdir', target_path.format(dt_fmt)])

# downloading status
status = 0

for lead_ in fcst_leads:
    
    filename_ = filename.format(lead_)
    print("Accessing: {}".format(filename_))
    
    try:    
        urllib.request.urlretrieve(url_fmt.format(dt_fmt, filename_), os.path.join(target_path.format(dt_fmt), filename_));
        status = 1
    
    except:
        # if file access is not successful, terminate all downloads
        print("NOT accessible: {}".format(filename_))
        status = 0
        break;
        
with open("GEFS_download.log", "w") as log_io:
    log_io.write(str(status))
