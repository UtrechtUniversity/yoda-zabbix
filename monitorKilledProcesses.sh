#!/bin/bash

# \file      mostKilledProcesses.sh
# \brief     Returns the number of lines in /var/log/messages.for killed processes due to lack of virutal memory of the current day
#.\brief     Mar 29 09:29:50 combined kernel: Killed process 15639 (irodsServer) total-vm:913264kB, anon-rss:754528kB, file-rss:4kB, shmem-rss:22556kB
# \copyright Copyright (c) 2018, Utrecht University. All rights reserved.

# Gets current month and day.
monthDay=$(date +"%b %d")

# Get lines containing Killed Process and month day.
echo $(sudo -u root grep "$monthDay" /var/log/messages | grep "Killed" | wc -l)

