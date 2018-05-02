#!/bin/bash

# \file         dailyRodslogErrors.sh
# \brief        Count number of current errors of the current day found in the rodsLog.
# \author       Niek Bats
# \copyright    Copyright (c) 2018, Utrecht University. All rights reserved.

# Get latest log file.
filepaths=$(sudo -u irods ls /var/lib/irods/iRODS/server/log/rodsLog.* | tail -n 2)

# Gets current month and day.
monthDay=$(date +"%b %e")

# Get lines containing error and month day.
echo $(sudo -u irods grep "$monthDay" $filepaths | grep "ERROR" | wc -l)
