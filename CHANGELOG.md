## [Known Issues]
- apiadmin should return 404 on invalid path. It is now return 200 and a version string. [ENGOPS-4953]
- I'm not sure if the "encypt" and "decrypt" commands make sense. They were put there for convenience in storing an encrypted value in the database, as there is no other command to do so.

# Changelog

Releases adhere to Semantic Versioning

## 2.16.0 - 2025-02-17
### Added
- Added cache support. Increased performance [ENG-6943]
- Added support for configurable popups for not existing user [ENG-6492]
- Support new alias via account parent-child relation [ENG-6498]
- Require Database Schema 35
- Removed in-apps TOTP clean up scheduled. This is superceded by database schedule

## 2.15.5 - 2025-02-18
### Fixed
- Fixed server return empty response on timeout

## 2.15.4 - 2025-02-12
### Fixed
- Fixed mysql connection metrics [ENG-6680]

## 2.15.3 - 2025-02-12
### Fixed
- OAuth: support client credential flow. polish logs [ENG-6739]

## 2.15.2 - 2025-02-10
### Fixed
- Fixed panic for concurrent map writes by replace gin to stdlib [ENG-5572]

## 2.15.1 - 2025-02-07
### Fixed
- Improved log to contain duration for critical external calls [ENG-6547]

## 2.15.0 - 2025-01-30
### Added
- Update auth readable/simplified password policy [ENG-6493]

## 2.14.4 - 2025-01-28
### Fixed
- Emergent fix v2.14.3 won't start due to dependency update [ENG-6482]

## 2.14.3 - 2025-01-22
### Changed
- Changed ASP enforce behaviour, only enforce users with ASP enabled [ENG-4659]
- Implemented invalid cache when domain password policy changed. Require mailserver 10.14.1

## 2.14.2 - 2025-01-08
### Fixed
- Fixed dependency vulnerability issue [ENG-6284]

## 2.14.1 - 2024-11-11
### Fixed
- Update dependency for security fix [ENG-5693]

## 2.14.0 - 2024-10-31
### Added
- Added support for account_status field enum value rstrFrozen [ENG-5608]

## 2.13.0 - 2024-10-23
### Added
- Added support for password_status field and configurable popup [ENG-5391]

## 2.12.7 - 2024-10-21
### Fixed
- enhanced password dictionary by added Optus requested blacklist [ENG-5507]

## 2.12.6 - 2024-10-17
### Fixed
- enhanced password policyCheck to include existing [ENG-5494]

## 2.12.5 - 2024-10-16
### Fixed
- Reset failed to check reuse password policy [ENG-5494]

## 2.12.4 - 2024-10-11
### Fixed
- Fixed notMigrated user should be redirect to legacy on issue OTP [ENG-5480]

## 2.12.3 - 2024-10-11
### Fixed
- Fixed reissue blocks dunning accounts login my-account portal [ENG-5466]

## 2.12.2 - 2024-09-19
### Fixed
- Fixed auth password policy return rules configured per domain [ENG-5306]

## 2.12.1 - 2024-09-18
### Added
- Additional support on revoke user sessions upon reissue [ENG-5081]

## 2.12.0 - 2024-09-08
### Added
- Support OAuth2+PKCE Flow. At this stage, this feature is for Atmail Cloud Only [ENG-4500]

## 2.11.1 - 2024-09-08
### Changed
- Ubuntu packaging [ENG-3739]

## 2.11.0 - 2024-09-06
### Added
- Added support for account_status field and configurable popup [ENG-4354]

## 2.10.3 - 2024-09-05
### Fixed
- Support alias when requesting OTP, hide error if email doesn't exist [ENG-5277]

## 2.10.2 - 2024-09-05
### Fixed
- Bypass policy check when verify 2fa [ENG-5166]

## 2.10.1 - 2024-09-04
### Fixed
- Fixed change password error when 2fa is enabled [ENG-5166]

## 2.10.0 - 2024-09-04
### Added
- Added password policy api endpoint [ENG-5264]

## 2.9.1 - 2024-09-04
### Fixed
- Fixed translation on password reset API [ENG-4939]

## 2.9.0 - 2024-09-02
### Added
- Support Email-Me and Webhook OTP feature [ENG-4939]
- Requires DB Schema 30 (v1.12.0)

## 2.8.7 - 2024-09-02
### Fixed
- Fixed security issue in password reset bypass [ENG-5065]

## 2.8.6 - 2024-08-16
### Changed
- Fixed a race condition on getting a new UIAM auth token
- Increase the buffer time when getting new UIAM auth token
- Add more debug on the authenticate call, when there is a non 2xx response [ENG-5033]

## 2.8.5 - 2024-08-17
### Fixed
- Upgraded sqlc. Removed unused codes

## 2.8.4 - 2024-08-15
### Fixed
- Fixed imap authentication panic when not able to reach host [ENG-5120]

## 2.8.3 - 2024-08-12
### Fixed
- Fixed 2fa TOTP vulnerability [ENG-5069]

## 2.8.2 - 2024-07-22
### Fixed
- Add a reset Interval to the UIAM circuit breakers of 60 seconds [ENG-4858]
- Note: this was also built as hotfix - v2.5.8 

## 2.8.1 - 2024-07-23
### Fixed
- Call Ahead fix for non-provisioned user [ENG-4545]

## 2.8.0 - 2024-07-22
### Added
- Update schema package dependency to v1.10.1 (schema version 28)
- No feature change to v2.7.1

## 2.7.1 - 2024-07-21
### Fixed
- Fixed incorrect schema version dependency, which should be v1.9.0 instead of v1.6.3

## 2.7.0 - 2024-07-19
### Added
- Added IMAP authentication mechanism [ENG-4678]

## 2.6.0 - 2024-07-19
### Added
- Support for authenticating non-provisioned user migration status (NotMigrated/Migrating) [ENG-4545]

## 2.5.9 - 2024-08-06
### Changed
- Fixed a race condition on getting a new UIAM auth token
- Increase the buffer time when getting new UIAM auth token
- Add more debug on the authenticate call, when there is a non 2xx response [ENG-5033]

## 2.5.8 (HOTFIX) - 2024-07-22
### Fixed
- Add a reset Interval to the UIAM circuit breakers of 60 seconds [ENG-4858]

## 2.5.7 - 2024-07-17
### Fixed
- Tests are borked with parallel test runs [ENG-4825]

## 2.5.6 - 2024-07-17
### Fixed
- Error in circuit breaker, affects UIAM only, not LDAP [ENG-4703]

## 2.5.5 - 2024-06-19
### Fixed
- Redirect to forgot password link based on migration status [ENG-4567] 

## 2.5.4 - 2024-06-20
### Fixed
- Fixed alias cannot login regression since moved to authapi for authentication [ENG-4603]

## 2.5.3 - 2024-06-17
### Fixed
- Singtel UIAM Auth Token password is encrypted [CHG-449]

## 2.5.2 - 2024-06-03
### Fixed
- Replace md5_crypt library as previous is removed

## 2.5.1 - 2024-05-30
### Fixed
- Allow for refresh token rotation by saving any new refresh tokens [COPS-190]

## 2.5.0 - 2024-05-20
### Added
- Singtel UIAM Password Auth [CHG-449]

## 2.4.11 - 2024-05-13
### Fixed
- Fixed content type header to (application/json) when provisioning auth continuation token [ENG-4261]

## 2.4.10 - 2024-04-02
### Fixed
- Fixed deprovisioned user can still login to webmail when using external LDAP [ENG-4327]

## 2.4.9 - 2024-04-02
### Fixed
- Fixed deprovisioned user can still login to webmail and perform opt-in [ENG-4327]

## 2.4.8 - 2024-03-26
### Fixed
- Bump to new version, there was a mistakes v2.4.7 was able to release even not yet merged to master  [ENG-4301]

## 2.4.7 - 2024-03-26
### Fixed
- Fixed blank suspensionCode for nonMigrated user [ENG-4301]

## 2.4.6 - 2024-03-19
### Patch
- Reissue of access token fixed [ENG-4263]

## 2.4.5 - 2024-03-19
### Fixed
- Regression: TOTP being allowed more than once. Refactor blocklist and ratelimit into totp.Service [ENG-4243]

## 2.4.4 - 2024-03-18
### Fixed
- Vulnerability fix for go-jose: https://pkg.go.dev/vuln/GO-2024-2631 [SEC-382]

## 2.4.3 - 2024-03-13
### Fixed
- Fixed http error code compatibility to apiserver. Allow webmail password auth by default [ENG-4228]

## 2.4.2 - 2024-03-13
### Fixed
- Fixed notMigrated users cannot authenticate via ldap bug [CHG-144]

## 2.4.1 - 2024-03-08
### Fixed
- Fixed forgotten password and master password mode [ENG-4187]

## 2.4.0 - 2023-03-06
- Singtel UIAM Support [ENG-3222]

## 2.3.0 - 2023-02-27
### Added
- Support password reset enforcement feature. Require Schema version 20 [ENG-4063]
- Supporting webapp authentication endpoint compatible to apiserver
- Refer to UPGRADE.md for more change details

## 2.2.3 - 2023-02-15
- No functional change, just rebuild with updated dependencies to fix vulnerbility error

## 2.2.2 - 2023-11-24
- No change, just rebuild

## 2.2.1 - 2023-11-23
### Added
- marked extra field on gRPC API api.PasswordValidator/Validate as optional [ENG-3389]
- Fixed typo

## 2.2.0 - 2023-11-23
### Added
- Added extra field on gRPC API api.PasswordValidator/Validate [ENG-3389]

## 2.1.6 - 2023-11-22
### Changed
- Upgraded sqlc, rebuild to fix some v2 module error [ENG-3389]

## 2.1.5 - 2023-11-03
- V2 Module support

## 2.1.4 - 2023-10-09
- Rebuild due to failed build agent

## 2.1.3 - 2023-10-04
### Fixed
- AUTHAPI: Broken OIDC authentication [ENG-3165]

## 2.1.2 - 2023-09-18
### Fixed
- AUTHAPI: allowing empty lassword on ldap authentication

## 2.1.1 - 2023-09-05
### Fixed
- ca-certificates was not installed in the docker image [ENG-2896]

## 2.1.0 - 2023-090-04
### Added
- LDAP mode added. Supports "bind", "search" and "kakadu" modes. Requires schema version 15 [ENG-2751]

## 2.0.0 - 2023-08-24
### Added
- LDAP backend type for password auth [ENG-2758]
- Add migrate status selector for password authenticator [ENG-2751]
This is a major version update. It has a dependency on a mailserver schema update

## 1.17.4 - 2023-08-25
### Fixed
- Only store lower case username in token otherwise DAV borked [ENG-2658]

## 1.17.3 - 2023-07-24
### Fixed
- SQL error in getAccount [ENG-2558]

## 1.17.2 - 2023-07-17
### Added
- Updated oidc table, added missing redirect migrating account column [ENG-2514]

## 1.17.1 - 2023-06-30
### Fixed
- When redis borked, temporarily bypass RBL & ratelimit

## 1.17.0 - 2023-06-28
### Added
- Updated oidc table to support redirecting on various error conditions [ENG-2361]
- Remove migrationStatus check to enable LI

## 1.16.0 - 2023-05-29
### Added
- Nonce cookie for id token verification
- Additional control over oidc cookie handling [ENG-2146]

## 1.15.11 - 2023-05-12
### Fixed
- Debug logging for oidc not correct

## 1.15.10 - 2023-05-12 - FAILED build - no rpm
### Changed
- v1.15.9 introduced a regression in resolving aliases. This fixes it [ENG-1752]
- OIDC discovery is cached

## 1.15.9 - 2023-05-08 - REGRESSION DO NOT USE
### Fixed
- Fixed virtual alias login failed on oidc [ENG-1740]

## 1.15.8 - 2023-04-02
### Fixed
- Fixed virtual alias login failed [ENG-1525]

## 1.15.7 - 2023-03-28
### Fixed
- Master password is not working when account status is Migrating [ENG-1476] 

## 1.15.6 - 2023-03-23
### Fixed
- A panic in the server no longer brings the whole thing down 

## 1.15.5 - 2023-03-06
### Fixed
- Additional tests for CRYPT [ENG-1287]

## 1.15.4 - 2023-03-02
### Fixed
- Broken test [ENG-918]

## 1.15.3 - 2023-03-01
### Changed
- Fixed the error return for invalid user domain [ENG-918]

## 1.15.2 - 2023-02-28
### Changed
- Updated dependencies
- Added flags for insecure hash schemes - PLAIN, PLAIN-B64, MD5, MD5-CRYPT
### Fixed
- Allow insecure hashes when requested
- Add authapi hash-plain utility to convert existing hashes

## 1.15.1 - 2023-02-22
### Fixed
- ASPs were broken when there was no domain policy [ENG-918]

## 1.15.0 - 2023-02-20
### Added
- TrustedProxies configuration. accountLogins update on auth [ENG-191]
- Use buf for protobuffers. Begin v2 implementation
- Various security fixes
- Webmail Redirect config
- jmapv1 Authentication Module
- master password authentication
- domain authentication supports DB and OIDC
- Metrics not populating [ENG-190]
- Add mysql pooling flags [ENG-474]

## 1.14.2 - 2023-01-31
### Fixed
- Add mysql pooling flags [ENG-474]

## 1.14.1 - 2023-01-10
### Fixed
- Client RBL switch [ENG-207]

## 1.14.0 - 2023-01-10
### Added
- Implemented brute force protection on client auth [ENG-207]

## 1.13.0 - 2022-11-14
### Added
- Added support for OTP [EODS-364]
- Added support branding email template [EODS-424]

## 1.12.1 - 2022-09-12
### Fixed
- Timestamp should be returned in API [EODS-357]
- User can only create 25 ASP [EODS-361]

## 1.12.0 - 2022-06-22
### Added
- Auth module now enables gRPC Auth [AUTHSRV-20]

## 1.11.0 - 2022-05-27
### Added
- New feature: support password encrypt by {CRYPT} [ENGOPS-8932]

## 1.10.0 - 2022-04-26
### Added
- New feature: localpart, alias & dedicated tenant [ENGOPS-8761]

## 1.9.3 - 2022-03-21
### Fixed
- Fixed loading global account password policy error [ENGOPS-8719]

## 1.9.2 - 2022-03-21
### Fixed
- Restore camelCase in json response [ENGOPS-8679]

## 1.9.1 - 2022-03-21
### Fixed
- Missing ldap authenticator [ENGOPS-8585]

## 1.9.0 - 2022-03-21
### Added
- Forked from adminapi. Migrated lua/ldap support from dict [ENGOPS-8585]
- Added better metrics [ENGOPS-8585]

## 1.8.2 - 2022-03-16
### Fixed
- Fixed query domain ASP policy error when domain doesn't have policy [ENGOPS-8565]

## 1.8.1 - 2021-12-14
### Fixed
- Fixed skip smtp auth not working issue. Improve domain policy
security check [AUTHSRV-18]

## 1.8.0 - 2021-12-10
### Added
- Added App Specific Password support

## 1.7.9 - 2021-10-29
### Changed
- Update jwt library. Add backwards compatibility for aud claim as csv list [ENGOPS-7490]

## 1.7.8 - 2021-08-09
### Changed
- FTR: Update redis dial using event module [ENGOPS-7167]

## 1.7.7 - 2021-08-02
### Fixed
- FTR: Fixed http not working when TLS is on [ENGOPS-7108]

## 1.7.6 - 2021-07-26
### Added
- FTR: Added TLS support for redis [ENGOPS-7029]

## 1.7.5 - 2021-07-20
### Added
- FTR: Added TLS support for gRPC listener [CA-51]

## 1.7.4 - 2020-03-01
### Added
- Added redis connection health check [MAIL-333]

## 1.7.3 - 2020-02-11
### Added
- Added log wrapper showing where original error comes from [MAIL-324]

## 1.7.2 - 2020-12-2
### Fixed
- Fixed 401 response contains error details [MAIL-308]
- Removed dependency on package srv-lb which requires GPLv3
- Fixed invalid path return version info instead of 404

## 1.7.1 - 2020-11-19
### Fixed
- Update authapi.yaml config file template for RPM [MAIL-303]

## 1.7.0 - 2020-11-16
### Added
- Unverified secret will be cleaned up after expiry [ENGOPS-4856]

## 1.6.1 - 2020-10-13
### Fixed
- Logic error in 2FA stops settings from showing in webmail [MAIL-294]

## 1.6.0 - 2020-09-30
### Added
- Support webmail messages, support OPTIONS method [WEBM-383]

## 1.5.0 - 2020-08-17
### Added
- Implement manage totp under password policy

## 1.4.0 - 2020-08-17
### Added
- Implement max totp code retry control and ensure code is one-time only [MAIL-245]

## 1.3.0 - 2020-08-05
### Added
- Added audit log. Metrics assigned dedicated port and enabled histogram [MAIL-265]

## 1.2.0 - 2020-07-23
### Added
- Support validate apiserver signed JWT token [MAIL-258]

## 1.1.0 - 2020-05-27
### Added
- Implemented verify password and code before delete enabled totpSecret token

## 1.0.2 - 2020-05-13
### Fixed
- Do not return 500 when code is invalid
- More debug logs

## 1.0.1 - 2020-05-01
### Added
- As an administrator I can override (ability to disable 2FA, controlled by RBAC) in the event that a user has no access to TOTP (i.e. lost device). [MAIL-160] 

## 1.0.0 - 2020-04-29
### Added
- Generate, validate and save TOTP seed [MAIL-158]
