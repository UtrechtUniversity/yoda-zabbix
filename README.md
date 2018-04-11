
# yoda-zabbix

Instructions for monitoring yoda specific items using zabbix

## How to implement yoda specific items for monitoring (on iCAT servers) using zabbix

Add the item key (as defined in the zabbix server) to the file zabbix_agentd.userparams.conf.

This file is included in the zabbix_agentd.conf file.

Example: UserParameter=yoda.delayedrules.count,sudo /etc/irods/yoda-zabbix/monitorDelayedRules.sh.

Only add sudo if the zabbix agent requires sudo permissions to execute the command. For scripts and or iRods rules that require sudo, the command should be added to the file yoda-zabbix-sudoers.

Example: zabbix ALL=NOPASSWD: /etc/irods/yoda-zabbix/monitorDelayedRules.sh

Make sure the yoda-zabbix-sudoers has no syntax errors and has been tested. A syntax error corrupts sudoers and can only be corrected with a re-install! Also duplicate lines are not allowed (also not flagged in the visudo linux editor).

## How to install Zabbix agent on yoda servers (allinone and full)

The provisioning of the zabbix-agent can be done with Ansible, with the playbook zabbix.yml.

Refer to https://github.com/UtrechtUniversity/yoda-ansible/ (do not use the master, but a release branch)

Details can be found in /roles/yoda-zabbix/tasks/main.yml

## Variable for  yoda zabbix_agentd.conf for which the value depends on the fqdn of the zabbix-server that monitors the yoda system:

    zabbix-server

Detailed information can be found in /roles/yoda-zabbix/templates

## Pre-shared-key handling

The pre-shared-key for the zabbix_agentd (zabbix_agentd.psk) is generated during installation using Ansible. The same key has to be configured in the zabbix-server manually.

For information on using pre shared keys refer to:

https://www.zabbix.com/documentation/3.4/manual/encryption/using_pre_shared_keys



LICENSE
-------
This project is licensed under the GPLv3 license.

The full license can be found in [LICENSE](LICENSE).



