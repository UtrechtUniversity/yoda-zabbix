#!/bin/bash
# \file         hourlyPortalUsers.sh
# \brief        Counts the number of portal logins in the past hour
# \author       
# \copyright    Copyright (c) 2019, Utrecht University. All rights reserved.

# gets latest log file.
filepath=/var/log/httpd/portal_access.log

# counts lines containing login HTTP in the past hour
/etc/zabbix/zabbix_agentd.d/read-apache-logs.py --last hour "$filepath" | grep -c '"POST /user/gate[^ ]* HTTP/[^ ]*" 302'
