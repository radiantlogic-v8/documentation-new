---
title: Operational Attributes
description: Operational Attributes
---

# Password Policy Operational Attributes

## pwdHistory

Stores the previous values used for passwords to prevent users from re-using previous passwords. The number of passwords that are stored is determined by the value set in the pwdInHistory attribute of the Password Policy.

## pwdChangedTime

A Generalized Time attribute containing the time the password was last changed. 

## pwdAccountLockedTime 

A Generalized Time attribute containing the time at which the account was locked. If the account is not locked, this attribute is not present. 

If the maximum consecutive login failures (pwdMaxFailure) have been reached during a certain period of time (pwdFailureCountInterval), the user entry will have the operational attribute of: pwdAccountLockedTime and it will contain the time the account became locked.

## passwordExpWarned

A Generalized Time attribute containing the time at which the password expiration warning was first sent to the client. 

## pwdFailureTime

A multi-valued Generalized Time attribute containing the times of previous consecutive login failures. If the last login was successful, this attribute is not present.

## pwdGraceUseTime 

A multi-valued Generalized Time attribute containing the times of the previous grace logins. 

## pwdPolicySubentry 

An attribute that contains the DN of the password policy associated with the user. RadiantOne does not write to this attribute or allow password policies to be defined on individual users from the Main Control Panel. However, if the entry was imported from another directory, this attribute could have a value that dictates which password policy affects the user. If the value matches a policy defined in RadiantOne, this policy is enforced for the user. If the value does not match a policy defined in RadiantOne it is ignored and other configured policies below cn=Password Policy,cn=config are checked. If multiple policies affect the user, the one with the highest priority (based on precedence level) is enforced.

## pwdReset

A Boolean attribute containing the value TRUE if the password has been reset and must be changed by the user. If a user’s password is set/reset by the RadiantOne super user (e.g. cn=directory manager), a member of the cn=directory administrators group (cn=directory administrators,ou=globalgroups,cn=config), or the user himself, this does not trigger pwdReset set to TRUE. Only when a user’s password is set/reset by other users (e.g. helpdesk) is the pwdReset set to TRUE. When the affected user logs in with the new password for the first time, they are not allowed to perform operations until they reset their password. For example, if the user attempts a search, the RadiantOne service responds with error code 53 and a message indicating “You must change your password before submitting any other requests”. After the user updates their password, pwdReset is removed from their entry.

## pwdLastLogonTime

If the option to “Keep track of the user’s last successful login time” is enabled in the password policy, this attribute stores the time associated with the user’s last successful login/bind.
