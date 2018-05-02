#!/bin/bash
# \author		Niek Bats
# \file			hourlyRodslogErrors.sh
# \brief		Count number of current errors of the current hour found in the rodsLog
# \copyright	Copyright (c) 2018, Utrecht University. All rights reserved.
#
#gets latest log file
filepaths=$(sudo -u irods ls /var/lib/irods/iRODS/server/log/rodsLog.* | tail -n 2)

#gets current month day and hour
monthDayHour=$(date +"%b %e %H")

#gets lines containing error and month day hour
echo $(sudo -u irods grep "$monthDayHour" $filepaths | grep "ERROR" | wc -l)
