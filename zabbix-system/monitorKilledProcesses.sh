#!/bin/bash

# \file      monitorKilledProcesses.sh
# \brief     Returns count of log lines mentioning OOM process kills on the current day
# \copyright Copyright (c) 2018-2026, Utrecht University. All rights reserved.

if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Error: could not determine distribution"
    exit 1
fi

if [ "$NAME" = "Ubuntu" ]
then
    datestamp=$(date +"%Y-%m-%dT")
    grep "^$datestamp" /var/log/syslog /var/log/syslog.? | grep -c "kernel: Out of memory: Killed process"
elif [ "$NAME" = "Red Hat Enterprise Linux" ] || [ "$NAME" = "AlmaLinux" ]
then
    datestamp=$(date +"%b %e")
    grep "^$datestamp " /var/log/messages | grep -c "kernel: Out of memory: Killed process"
else
    echo "Error: unknown distribution: $NAME"
fi
