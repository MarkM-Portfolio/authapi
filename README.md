# Atmail Auth API

AuthAPI provides authentication services

## Modules

AuthAPI is originated from AdminAPI and Dict server, so it can have unnecessary config required on simple usage. Modules allow load only selected gRPC modules in order to simplify the configuration.

This is a WIP feature, now modules include:
- auth: auth module only
- grpc: gRPC collections, enable full feature of gRPC including auth, ASP, TOTP etc.
- jmapv1: JMAP v1 authentication handlers. This is a drop in replacement for the existing apiserver /auth endpoint, with some noteable enhancements. See [JMAP v1] (#jmap-v1)

# Replacing AdminAPI

By default, AuthAPI will use a different dns entry in consul. In order to replace AdminAPI during transition period, use `--enable-adminapi-dns=true` to enable AuthAPI also advertise itself as AdminAPI

# Installation
## Install from RPM
Make sure you have the cloud repo configured in your environment. Refer to [Internal YUM repositories](https://atmail.atlassian.net/wiki/spaces/AT/pages/1027080220/Internal+YUM+repositories)

Then install atmail-authapi via yum

``` shell
yum install atmail-authapi
```

## Configuration
The full list of supported configuration can be get via `authapi -h`:

### mysql
mysql dsn. for example root:changeme@tcp(localhost:3306)/mailserver

### syslog
Set to true to log to syslog

### totp_key
TOTP encryption key is a 32 bytes random string encode with base64. The easist way to generate a totp key is:
``` shell
openssl rand -base64 32
```

## Example config

``` shell
mysql: root:root@tcp(localhost:3306)/mailserver
auth: apiadmin:changeme
totp_key: "ZP6LD7dtSpbRKL1uudmpQ3mX0BWEV7p5DATKpP2PFZM="
syslog: true
```
# Start service

``` shell
systemctl start atmail-authapi
```

# Test

## Verify Auth From CLI
``` shell
authapi --config /etc/atmail/authapi/authapi.yaml auth USERNAME PASSWORD
```

### Verify hc2-prod LDAP
(Find prod test account credential statmail02 from 1password app)

```shell
[root@msbe-1 (orchid-msbe-1) ~]# authapi --verbose --config /etc/atmail/authapi/authapi.yaml auth statmail02@singnet.com.sg xxxxx
DEBU[0000] enabled debug log
DEBU[0000] validating via ldap                           ldapURL="ldaps://ldap.orchid.local:9771?skip-tls-verify=true"
OK
```

## From HTTP API

``` shell
curl -u admin:pass -k https://localhost:8360/auth -H 'Content-Type: application/json' -d '{"username":"john@test.com", "password":"changeme"}'
```

or (when TLS not enabled)
``` shell
curl -u admin:pass http://localhost:8360/auth -H 'Content-Type: application/json' -d '{"username":"john@test.com", "password":"changeme"}'
```

## Check gRPC
``` shell
grpcurl -plaintext localhost:8361 list
```

# JMAP v1

Implements authentication based on https://bitbucket.org/atmaildevbucket/jmapio

There have a number of modifications in order to support oidc, and host based authentication methods.

The following endpoints are added, all under the path prefix of /jmap/v1/auth. This is intended to be a transparent replacement of the existing apiserver /auth endpoint.

## GET /jmap/v1/auth

The loginHosts table is queried to determine if it is associated with a domain. No authentication methods are available if it is not.

The domain will allow one of "password" or "oidc" methods. If an authentication method is found, a "reissue" method will also be added, to allow refreshing of tokens.

The "oidc" authentication method will include an id key, for use in making calls to the /jmap/v1/auth/oidc endpoints.

## POST /jmap/v1/auth

This is the equivalent of the existing handlers in apiserver. However, only "password" and "reissue" methods are supported.

It returns an access token and a list of endpoints which will accept the token.

## GET /jmap/v1/oidc?id=<oidc_id>

This endpoint will produce a redirect to the configured identity provider, where the end user will login.

## GET /jmap/v1/oidc/callback?id=<oidc_id>&<oidc_callback_params>

This endpoint validates the idp authentication response, as per
https://openid.net/specs/openid-connect-core-1_0.html#AuthResponse

It returns an access token and a list of endpoints which will accept the token.