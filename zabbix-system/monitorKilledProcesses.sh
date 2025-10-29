#!/bin/bash

# \file      monitorKilledProcesses.sh
# \brief     Returns the number of lines in /var/log/messages.for killed processes due to lack of virtual memory of the current day
# \brief     Mar 29 09:29:50 combined kernel: Killed process 15639 (irodsServer) total-vm:913264kB, anon-rss:754528kB, file-rss:4kB, shmem-rss:22556kB
# \copyright Copyright (c) 2018-2025, Utrecht University. All rights reserved.

# returns count of lines containing Killed process and month day.
journalctl --since today | grep -c "kernel: Out of memory: Killed process "
