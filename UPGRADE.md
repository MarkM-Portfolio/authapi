# UPGRADE.md

This file contains instructions for updating authapi from one version to another

## Introduction

Generally, the update process is simply a matter of updating the package and restarting the service

```bash
# Update the package
yum update atmail-authapi

# Restart the service
systemctl restart atmail-authapi

# Check the service status
systemctl status atmail-authapi

# Check logs for any errors
journalctl -u atmail-authapi
grep authapi /var/log/maillog
```
The database schema is managed by the migratedb.sh tool. 

However, there are some cases where additional steps are required. These are documented below.

## version 2.16
Requires mailserver schema revision 35 (atmail-msvr-1.16.0)
Added new flag `--enable-cache`, which is enabled by default. Account cache: 5 minutes, Domain cache: 10 minutes.

## Version 2.15
Requires mailserver schema revision 33 (atmail-msvr-1.14.0)

## Version 2.12
No special upgrade requirements. Can be upgraded directly.
This version introduces native OAuth2 support, however this feature is only for internal usage at this stage. This won't impact any existing custom integration.

## Version 2.11
No special upgrade requirements. Can be upgraded directly.

## Version 2.10
No special upgrade requirements. Can be upgraded directly.

## Version 2.9
### Schema dependency
Requires mailserver schema revision 30 (atmail-msvr-1.12.0)
Requires READ permission to access table `domainSettings` and `tenant_settings`

## Version 2.8
### Schema dependency
Requires atmail-msvr-1.10.1 or above (schema version 28)

## Version 2.7
This version introduces imap authentication method.
IMAP authentication is now managed per domain with the domainAuth table. Add a record to the domainAuth table for each domain that uses IMAP authentication.
Schema update is required. See Prerequisites below. (IMAP authentication is used for Atmail Cloud migration purpose. On-prem customers only need to satisfy the schema version requirement.)

### Prerequisites
Requires atmail-msvr-1.9.0 or above (schema version 26)

## Version 2.6
This specific version support for authenticating non-provisioned user migration status.
The schema update is required. See Prerequisites below.
### Prerequisites
atmail-schema-msvr 1.8.0 or later (minimum schema version 24). The migratedb.sh tool must show version 24 or higher

## Version 2.5
This version introduces custom extends custom authentication method to password authentication. 
This feature is not available for general use and requires custom integration. There are no schema changes and no extra configuration.

## Version 2.4
This version introduces custom authentication methods when the feature is enabled. This feature is disabled by default.
The schema update is required. See Prerequisites below.

Usage:
```
--jmap-sso-enabled                                                enable JMAP /sso endpoint (default: false) [$JMAP_SSO_ENABLED]
```

### Prerequisites
atmail-schema-msvr 1.6.3 or later (minimum schema version 17). The migratedb.sh tool must show version 21 or higher, ie
```bash
foo@bar:~$ migratedb.sh msvr version
RESULT:
21
```
# Database Permissions
In addition to the previous permissions, the database user must add the following minimum permissions

## SELECT
custom_auth
custom_auth_config

## Version 2.3
### Schema dependency
require mailserver schema version 20

### Behaviour Change
authapi publish message to dovecot-policy-server to perform post login audit log. dovecot-policy-server logs to `accountLogins` table
in `accountLogins` table, the protocol `webmail` has been renamed to `jmap`.

### New configure
below new conifg are not required for Telstra setup

```yaml
enable-totp-cleanup: false
event-topic: Storeman::Command
apiserver-url: http://<jmap-api.domain>
opt-in:
  check-url: <url>
  api-key: <key>
enable-legacy-otp: false
enable-jmap-v1-token-revoke: false
```

## Version 2.2
No special upgrade requirements. Can be upgraded directly.

## Version 2.1
### Prerequisites
Requires atmail-msvr-1.5.0 or above (schema version 15)

## Version 2.0

* LDAP authentication is now managed per domain with the domainAuth table. The existing LDAP config file, referenced by config varibles ldap.enabled and ldap.config is not longer used. Please migrate the data in this file to the ldap_auth table, and add a record to the domainAuth table for each domain that uses LDAP authentication.

* The deprecated config item enable-adminapi-dns has been removed

### Prerequisites

atmail-schema-msvr 1.4.0 or later (minimum schema version 14). The migratedb.sh tool must show version 14 or higher, ie
```bash
foo@bar:~$ migratedb.sh msvr version
RESULT:
14
```
