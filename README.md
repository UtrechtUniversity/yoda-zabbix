
# yoda-zabbix

Zabbix monitoring scripts for Yoda

## Deploying the monitoring scripts

The default method for deploying the monitoring scripts is the `zabbix.yml`
playbook in [the main Yoda repository](https://github.com/UtrechtUniversity/yoda).

### Basic configuration

Use the `zabbix_server` parameter to configure the name of the Zabbix server, and
`zabbix_version` to configure the branch of the yoda-zabbix scripts repository to use.

### Authentication to Zabbix server

The Zabbix agent uses a pre-shared key (PSK) to authenticate to the Zabbix server. This key, along
with its identity (i.e. its name) is generated when the Ansible playbook runs. The PSK and its
identity have to be retrieved from the Zabbix agent configuration file and configured on the Zabbix
server manually.

For additional information about using pre-shared keys, please refer to:

https://www.zabbix.com/documentation/current/en/manual/encryption/using_pre_shared_keys

## Implementing additional checks

The monitoring scripts are currently organized by role. 

A new item needs to be added to the user parameter file of its role: `yoda_role.userparams.conf`, where `role` should be one
of `system` or `irodscommon`.

Example:

```
UserParameter=yoda.killedprocesses.count,sudo /etc/zabbix/zabbix_agentd.d/monitorKilledProcesses.sh
```

Use `sudo` if the zabbix agent requires sudo permissions to execute the command, and add the command to the `yoda-zabbix-role-sudoers` file
of the role.

Example:

```
zabbix ALL=NOPASSWD: /etc/zabbix/zabbix_agentd.d/monitorKilledProcesses.sh
```

## License

This project is licensed under the GPLv3 license.

The full license can be found in [LICENSE](LICENSE).
