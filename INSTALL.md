# INSTALL.md

This file contains instructions for installing the atmail-authapi package

# Prerequisites

CentOS 7 is required for the rpm package.

The schema is managed by the migratedb.sh tool. See the [migratedb.sh](/usr/share/doc/atmail/migratedb) documents for more information. The required minimum package is atmail-schema-msvr-1.4.0. The migratedb.sh tool must show version 14 or higher, ie
```bash
foo@bar:~$ migratedb.sh msvr version
RESULT:
14
```

# Database Permissions
The database user must have the following minimum permissions

## SELECT

Config
account
account_messages
accounts
app_passwords
brands
custom_auth
custom_auth_config
domainAuth
domains
ldap_auth
loginHost
loginHostAuth
oidc
oneTimePassword
passwordPolicy

## DELETE
app_passwords

## INSERT
account_messages
app_password
app_messages

## UPDATE
accounts

# Installation

1. Install the atmail-authapi package
```bash
yum install atmail-authapi
```
2. Configure the atmail-authapi service
```bash
vim /etc/atmail/authapi/authapi.yaml
```
3. Start the atmail-authapi service
```bash
foo@bar:~$ systemctl start atmail-authapi
foo@bar:~$ systemctl status atmail-authapi
● atmail-authapi.service - atmail-authapi - atmail mailserver admin api service
   Loaded: loaded (/usr/lib/systemd/system/atmail-authapi.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2023-08-29 03:13:03 UTC; 9s ago
     Docs: http://www.atmail.com/
 Main PID: 2623 (authapi)
   CGroup: /system.slice/atmail-authapi.service
           └─2623 /usr/bin/authapi --config /etc/atmail/authapi/authapi.yaml --syslog

```
4. Check the logs for any errors
```bash
journalctl -u atmail-authapi
grep authapi /var/log/messages
```
