#!/bin/bash
# \file         hourlyRodslogErrors.sh
# \brief        Counts the number of errors of the current hour in the rodsLog.
# \author       Niek Bats
# \copyright    Copyright (c) 2018, Utrecht University. All rights reserved.

# gets latest log file.
mapfile -t filepaths < <(sudo -u irods ls /var/lib/irods/log/rodsLog.* | tail -n 2)

# counts lines containing ERROR in the last hour
sudo -u irods /var/lib/irods/bin/read-irods-logs.py --last hour  "${filepaths[@]}" | \
  grep -v " ERROR: addMsParam: Two params have the same label ruleExecOut" | \
  grep -v " ERROR: addMsParam: ... param is of type: ExecCmdOut_PI" | \
  grep -v " ERROR: caught python exception: TypeError: No to_python (by-value)" | \
  grep -v " ERROR: caught python exception:   File \"<string>\"" | \
  grep -v " ERROR: Rule Engine Plugin returned \[0\]" | \
  grep -c "ERROR:"
