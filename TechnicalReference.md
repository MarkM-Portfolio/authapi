# Auth API

# Introduction

The Auth API is used to perform authentication for accounts

## Authentication
Authentication is configured at the domain level, using the "domainAuth" table. Each domain can configure zero or more authentication methods.

Each authentication method has an "authType" which defines the type of authentication. The authType can be one of the following:
* PASSWORD
* TOKEN

Each authentication method has an "accessPoint" which defines the access point for the authentication method. The access point can be one of the following:
* WEBAPP
* CLIENT

Each authentication method has a "backendType" which defines the backend for the authentication method. The backend type can be one of the following:
* DB
* OIDC
* LDAP
* CUSTOM
* IMAP

### IMAP
IMAP authentication is configured using the "imap_auth" table. This IMAP url will be called to authenticate an account associated with a domain entry in domainAuth table with their corresponding migrateStatus.

An IMAP server typically listens on well-known port 143, while IMAP over SSL/TLS (IMAPS) uses 993.
IMAP url format should be in (imap://<domain>:<port> or imaps://<domain>:<port>).

MySQL [pc5_msvr]> select * from imap_auth;
+----+-----------+------------------------------------------+------+
| id | tenant_id | url                                      | name |
+----+-----------+------------------------------------------+------+
|  1 |         1 | imap://imap.pc5-stg.atmailcloud.com:143  |      |
|  2 |         1 | imaps://imap.pc4-stg.atmailcloud.com:993 |      |
+----+-----------+------------------------------------------+------+

```
To use this integration for a domain, insert rows in domainAuth:
```
MySQL [pc5_msvr]> SELECT * FROM domainAuth WHERE domainId = '157' AND migrateStatus = 'Migrating' \G;
 
*************************** 1. row ***************************
            id: 276
      domainId: 157
   accessPoint: CLIENT
      authType: PASSWORD
   backendType: IMAP
 migrateStatus: Migrating
        oidcId: NULL
       ldap_id: NULL
custom_auth_id: NULL
       imap_id: 2
*************************** 2. row ***************************
            id: 277
      domainId: 157
   accessPoint: WEBAPP
      authType: PASSWORD
   backendType: IMAP
 migrateStatus: Migrating
        oidcId: NULL
       ldap_id: NULL
custom_auth_id: NULL
       imap_id: 2
2 rows in set (0.00 sec)


### LDAP
LDAP authentication is configured using the "ldap_auth" table. Each LDAP authentication method has a "mode" which defines the mode of operation. The mode can be one of the following:
* BIND
* SEARCH
* KAKADU


#### LDAP Error Handling
LDAP Authentication has a number of parameters which control how Auth API reacts in an error situation. These parameters are:
* request_timeout_sec
* request_max_retries
* circuit_breaker_fail_threshold
* circuit_breaker_half_open_max_requests
* circuit_breaker_open_timeout_sec
* circuit_breaker_reset_count_sec

Note that circuit breaker state is stored in memory and changes to parameters require a restart to take effect.

request_timeout_sec:

Controls how long a single request to the ldap server has to return a response before being cancelled. Default 0: no timeout

request_max_retries:

Controls how many times a request can be retried. Default 0: no retries

circuit_breaker_fail_threshold:

Controls how many times a request can fail before the circuit breaker is tripped. Default 0: do not use the circuit breaker. Requires restart.

Note that retries within a single request count as a single failure. A failure is defined as an ldap request which returns an unexpected error. Expected errors are: invalidUser and invalidPassword.


circuit_breaker_half_open_max_requests:

Controls how the maximum number of requests allowed to pass while the circuit breaker is in half open state. Default 0: allow 1 request

circuit_breaker_open_timeout_sec:
Controls the number of seconds the circuit breaker is in open state before transitioning to half open state. Default 0: Uses the library default of 60 seconds

circuit_breaker_reset_count_sec: Unused

### LDAP Metrics
The following metrics are available:
```
	ldapAuthCount = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "authapi_ldap_auth_count",
		Help: "total ldap auth request count",
	}, []string{"name"})
	ldapAuthErrorCount = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "authapi_ldap_auth_error_count",
		Help: "total ldap auth error count",
	}, []string{"name"})
	ldapAuthDuration = promauto.NewHistogramVec(prometheus.HistogramOpts{
		Name:    "authapi_ldap_auth_duration",
		Help:    "ldap auth duration",
		Buckets: prometheus.DefBuckets,
	}, []string{"name"})
	circuitBreakerStateChangeCount = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "authapi_circuit_breaker_state_change_count",
		Help: "circuit breaker state change count",
	}, []string{"name", "from", "to"})
	circuitBreakerConsecutiveFailures = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "authapi_circuit_breaker_consecutive_failures",
		Help: "circuit breaker consecutive failures",
	}, []string{"name"})
	circuitBreakerConsecutiveSuccesses = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "authapi_circuit_breaker_consecutive_successes",
		Help: "circuit breaker consecutive successes",
	}, []string{"name"})
	circuitBreakerTotalFailures = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "authapi_circuit_breaker_total_failures",
		Help: "circuit breaker total failures",
	}, []string{"name"})
	circuitBreakerTotalSuccesses = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "authapi_circuit_breaker_total_successes",
		Help: "circuit breaker total successes",
	}, []string{"name"})
	circuitBreakerRequests = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "authapi_circuit_breaker_requests",
		Help: "circuit breaker requests",
	}, []string{"name"})

```

### OIDC
OIDC authentication is configured using the "oidc" table. There is an example integration setup in Auth0 (see 1Password for credentials): https://manage.auth0.com/dashboard/us/dev-jwgk37crhhzwfm3u/applications
Start by creating a UUID, creating an application in the IDP, getting the client-id and secret and setting up the redirect URI. The table in pc5-stg:
```
MySQL [pc5_msvr]> select * from oidc\G
*************************** 1. row ***************************
                        id: 2
                  tenantId: 2
                      uuid: B4C88BA8-DC67-4FB1-974B-1C6C0C73279A
                      name: auth0-operations-integration
                  clientId: Tn2gKvIEUUXBiqEoDDyAxVxQq3d90miX
                 issuerURI: https://dev-jwgk37crhhzwfm3u.us.auth0.com/
              clientSecret: <redacted>
     authorizationEndpoint: NULL
             tokenEndpoint: NULL
                    scopes: email offline_access
               redirectURI: https://eng.pc5-stg.atmailcloud.com/login/oidc/callback?id=B4C88BA8-DC67-4FB1-974B-1C6C0C73279A
                  imageURI: NULL
             usernameClaim: email
         migrationRedirect: NULL
redirect_account_not_found: NULL
 redirect_account_disabled: NULL
  redirect_account_deleted: NULL
redirect_account_migrating: NULL
            redirect_error: NULL
1 row in set (0.00 sec)
```
To use this integration for a domain, insert rows in domainAuth and loginHostAuth:
```
MySQL [pc5_msvr]> select b.* from domains a join domainAuth b using (domainId) where domainName = 'eng.pc5-stg.atmailcloud.com';
+----+----------+-------------+----------+-------------+---------------+--------+---------+----------------+
| id | domainId | accessPoint | authType | backendType | migrateStatus | oidcId | ldap_id | custom_auth_id |
+----+----------+-------------+----------+-------------+---------------+--------+---------+----------------+
|  7 |        9 | CLIENT      | PASSWORD | DB          | Migrated      |   NULL |    NULL |           NULL |
|  8 |        9 | WEBAPP      | TOKEN    | OIDC        | Migrated      |      2 |    NULL |           NULL |
+----+----------+-------------+----------+-------------+---------------+--------+---------+----------------+
2 rows in set (0.00 sec)

MySQL [pc5_msvr]> select b.* from loginHost a join loginHostAuth b on (a.id=b.loginHostId) where loginHostName='eng.pc5-stg.atmailcloud.com';
+-------------+----------+-------------+--------+----------------+
| loginHostId | authType | backendType | oidcId | custom_auth_id |
+-------------+----------+-------------+--------+----------------+
|          16 | TOKEN    | OIDC        |      2 |           NULL |
+-------------+----------+-------------+--------+----------------+
1 row in set (0.00 sec)
```

## Ad-Hoc encryption
authapi has a command line utility to encrypt and decrypt a string. This is required for a number of cases when authapi is expected to read encrypted data.
eg plaintext "letmein"
```
$ authapi encrypt
encrypting secret from stdin...
Enter Password: 
xwlEidBsQoi1XDT2LWhbnXcrDuLLFIw

$ authapi decrypt
decrypting secret from stdin...
letmein
```