#!/bin/bash
# \file         dailyPortalUsers.sh
# \brief        Counts the number of portal logins of the last day.
# \author       
# \copyright    Copyright (c) 2019, Utrecht University. All rights reserved.

# gets latest log file.
filepath=/var/log/httpd/portal_access.log

# counts lines containing login HTTP of last day
/etc/zabbix/zabbix_agentd.d/read-apache-logs.py --last day "$filepath" | grep -c '"POST /user/gate[^ ]* HTTP/[^ ]*" 302'
