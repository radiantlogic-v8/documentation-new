---
title: System Administration Guide
description: System Administration Guide
---

# Password Policies

When using a RadiantOne Universal Directory store or persistent cache (with password policy enforcement enabled), you can establish password policies for managing things such as password length, quality, reset frequency, lockout…etc. Password policies are only enforced for RadiantOne Universal Directory stores and persistent caches (that contain the user passwords and have enabled the enforcement of password policies) not any other kind of backend configuration (proxies, databases…etc.).

![An image showing ](Media/Image3.102.jpg)
 
Figure 1: Password Policies

## Privileged Password Policy Group

To allow users to bypass password policies, you can add them to the PrivilegedPasswordPolicyGroup group. This group can be useful, for example, if you want a helpdesk user to reset a user’s password. The password policies are not checked, so this user can set a password that does not meet the password content criteria, could be in history, etc.

><span style="color:red">**IMPORTANT NOTE – In addition to PrivilegedPasswordPolicyGroup group members, password policies also do NOT apply to the RadiantOne super user account (cn=directory manager for example) or any member of the cn=directory administrators,ou=globalgroups,cn=config group (or the specific Directory Administrators group you have set on the Main Control Panel > Settings Tab > Server Front End > Administration sub-section).**

To assign users to the Privileged Password Policy Group:

1.	In the Main Control Panel, click the Directory Browser tab.

2.	Expand cn=config and ou=globalgroups.

3.	Select cn=PrivilegedPasswordPolicyGroup.

4.	On the right, click **Manage Group**.

5.	Add privileged accounts to this group.

## Password Policy Configuration

From the Main Control Panel -> Settings Tab -> Security section -> Password Policies sub-section, you can configure the following:

### Password Policy Scope

There is a default password policy that is enforced at a global level for all RadiantOne Universal Directory stores and persistent cache (if password policy enforcement is enabled), no matter where a user account is located. You can override the default policy with a custom one that is applicable only to a certain subset of the user population (determined by group they are a member of, or the location of the entry in the virtual namespace).

>**Note – If a given user entry is affected by both a global and local policy, the local policy takes precedence. For more details, see [Password Policy Precedence](#password-policy-precedence). To enable password policy enforcement for a persistent cache branch, check the Enable Password Policy Enforcement option on the cache settings. For more details on persistent cache, see the RadiantOne Deployment and Tuning Guide.**

### Default Password Policy

In the ‘Choose a Password Policy’ drop-down menu, the default password policy is named Default Policy. Choose this option to edit the components of the global default policy.

![An image showing ](Media/Image3.103.jpg)
 
Figure 2: Password Policy Scope

### Custom Password Policy

To create a custom password policy, next to the ‘Choose a Password Policy’ drop-down, click **NEW**. Enter a policy name applicable to the intended usage and click **OK**.

The ‘Subject’ of the custom policy can be either Sub-tree or Group and is based on a specific base DN. Click **CHOOSE** to select a base DN. If the subject is set to sub-tree, this means that all user entries below the chosen base DN (which must be a RadiantOne Universal Directory store or persistent cache) are affected by the custom policy. If the subject is set to group, this means that all users that are a member of the group specified in the base DN are affected by the custom policy. The group DN can represent a static group (unique members listed in the group entry) or a dynamic group (associated with the groupOfURLs object class and contains a memberURL attribute dictating the members). RadiantOne evaluates dynamic membership automatically to enforce password policies. If a user is affected by a policy defined for sub-tree and for group, the one associated with the group takes precedence.

>**Note – Custom policy properties override those defined in the default policy. The only exception is the password content properties where you can choose to enable the enforcement of the custom policy, or choose to use the default policy. Keep in mind that a value of 0 (zero) in a custom policy for password content means an unlimited amount is allowed. It does not mean that it is undefined.**

An example of a custom password policy is shown below. It is applicable to all users who are located in a RadiantOne Universal Directory store and are a member of the Special Users group identified in the DIT as cn=special users,ou=globalgroups,cn=config.

>**Note – If you define multiple custom password policies associated with groups (as the Subject), they should not have the same precedence if they share members. If a user is affected by multiple group-based policies, the one with the highest precedence (lowest numeric value in the precedence setting) is enforced.**

![An image showing ](Media/Image3.104.jpg)
 
Figure 3: Example Custom Password Policy Applicable to a Group

An example of a custom password policy applicable to all users below a specific container is shown below. This custom policy is enforced for all users in a RadiantOne Universal Directory store located below o=local.

>**Note – precedence level is not configurable for policies defined on a sub tree. Multiple password policies configured with sub tree subject, should not be configured for the same location. If multiple policies impact the same branch, the policy defined at the lowest point is enforced.**

![An image showing ](Media/Image3.105.jpg)
 
Figure 4: Example Custom Password Policy Applicable to a Sub Tree

### Password Policy Precedence

If the user entry has a pwdPolicySubentry attribute that contains a DN pointing to a password policy located below cn=Password Policy,cn=config in RadiantOne, this policy takes precedence and is enforced for the user. If the user entry doesn’t have a pwdPolicySubentry attribute, or if the value points to a non-existent policy below cn=Password Policy,cn=config, then RadiantOne evaluates other configured password policies that affect the user.

The examples below describe how password policies are enforced.

-	If a user has a pwdPolicySubentry attribute that matches a policy configured in RadiantOne, this policy is enforced. No other password policies are considered.

-	If a user is affected by both a global and local policy, the local policy takes precedence. 

-	If a user is affected by both a group-based policy and a sub-tree based policy, the group policy takes precedence. 

-	If a user is affected by multiple group-based policies, the one with the highest precedence (lowest numeric value in the precedence setting) is enforced. 

-	If a user is affected by multiple sub-tree based policies, the one with the deepest DN value is enforced.
Items to keep in mind:

-	The precedence value is a number between 1 and 1000. 1 is the highest level. 1000 is the lowest level. This value is stored in the policyPrecedence attribute of the password policy entry in RadiantOne.

-	The default password policy always has the lowest precedence level (a numeric value of 1000).

-	Each custom password policy defined for groups is associated with a precedence level. This level dictates which policy is enforced for a user that is associated with many group policies. For example, if a user is a member of many groups and each group is associated with a different password policy, the precedence number determines which policy to enforce.

-	Multiple password policies configured with sub tree subject, should not be configured for the same location. If multiple policies impact the same branch, the policy defined at the lowest point (deepest DN) is enforced.
-	If you define multiple custom password policies associated with groups (as the Subject), they should not have the same precedence if they share members.

Password Changes

![An image showing ](Media/Image3.106.jpg)
 
Figure 5: Password Changes Options

### User must change password after reset

This value is stored in the pwdMustChange attribute of the cn=Password Policy entry and has a value of True or False. If True, the user must change their passwords when they first bind to the directory after their password has been reset. The bind error message returned from RadiantOne is “You must change your password before submitting any other requests”.

><span style="color:red">**IMPORTANT NOTE – The applicable password policy must indicate: "User must change password after reset" and "User may change password".**

Actions considered as a reset that will trigger the “You must change your password before submitting any other requests” bind error are:

-	A new user account is added. In order to be considered a password reset, the account must be created by a user other than the cn=directory manager, or any member of the cn=directory administrators group.

-	An existing user account’s password is changed by a user other than themselves, cn=directory manager, or any member of the cn=directory administrators group (cn=directory administrators,ou=globalgroups,cn=config).

If this attribute is not present, or if the value is False, users are not required to change their password upon binding after the password administrator resets the password. 

### User may change password

This value is stored in the pwdAllowUserChange attribute of the cn=Password Policy entry. This value indicates whether users can change their own passwords. If enabled, the value is True, if not the value is False.

### Require existing password in order to change password

This value is stored in the pwdSafeModify attribute of the cn=Password Policy entry. This value is either True (if enabled) or False. This value specifies whether the existing password must be sent along with the new password when being changed.

### Allow a password to be changed after a certain number of days

This value is stored in the pwdMinAge attribute of the cn=Password Policy entry. It holds the number of seconds that must elapse between modifications to the password. If this attribute is not present, 0 seconds is assumed. From the Main Control Panel, you can indicate the length of time in any combination of days, hours and/or minutes using “d” for days (e.g. 1d), “h” for hours (e.g. 4h), and “m” for minutes (e.g. 5m). A value of 1d 5h 45m would indicate a password could be changed after 1 day, 5 hours and 45 minutes.

>**NOTE – your password policy must uphold the following rule: pwdMinAge + pwdExpireWarning < pwdMaxAge.**

### Keep a password history

This value is stored in the pwdInHistory attribute of the cn=Password Policy entry. It holds the maximum number of used passwords to store in the pwdHistory attribute. If this attribute is not present, or if the value is 0, used passwords are not stored in the pwdHistory attribute and the value may be reused.

Password Expiration

![An image showing ](Media/Image3.107.jpg)
 
Figure 6: Password Expiration Options
 
### Password never expires

This value is stored in the pwdMaxAge attribute of the cn=Password Policy entry. If this option is enabled, then the value is 0d.

### Password expires after a certain amount of time

This value is stored in the pwdMaxAge attribute of the cn=Password Policy entry. If this option is enabled, the value contains the amount of time after which a modified password expires. If this attribute is not present, or if the value is 0d, the password does not expire. If not 0d, the value must be greater than or equal to the value of pwdMinAge (the Allow a password to be changed after a certain number of days parameter). From the Main Control Panel, you can indicate the length of time in any combination of days, hours and/or minutes using “d” for days (e.g. 1d), “h” for hours (e.g. 4h), and “m” for minutes (e.g. 5m). A value of 1d 5h 45m would indicate a password expires after 1 day, 5 hours and 45 minutes.

>**NOTE – your password policy must uphold the following rule: pwdMinAge + pwdExpireWarning < pwdMaxAge.**

If a user’s password is expired, the next time a client (on the user’s behalf) connects to RadiantOne, the bind will fail and the additional information returned to the client indicates the password has expired. An example using an ldapsearch command line client by a user identified as “tuser” is shown below.

```
ldapsearch -h 10.11.12.164 -p 2389 -D "uid=tuser,ou=people,o=global" -w password -b "o=global" "(uid=tuser)" 
ldap_simple_bind: Invalid credentials
ldap_simple_bind: additional info: Password has expired.
```

During the bind, RadiantOne calculates if the user’s password has expired and returns the bind response and additional information to the client. It is up to the client to prompt the user to reset their password, if this functionality is desired.

The user entry stored in RadiantOne doesn’t contain an attribute that indicates a user’s password has expired. However, the entry contains an attribute (passwordExpWarned) indicating when the password expiring warning was send in the bind response.

```
dn: uid=tuser,ou=people,o=global
passwordExpWarned: 20170622194148.238Z
```

### Send a warning before the password expires

This value is stored in the pwdExpireWarning attribute of the cn=Password Policy entry. It contains the amount of time before a password is due to expire in which case an expiration warning message is returned to an authenticating user. From the Main Control Panel, you can indicate the length of time in any combination of days, hours and/or minutes using “d” for days (e.g. 1d), “h” for hours (e.g. 4h), and “m” for minutes (e.g. 5m). A value of 1d would indicate a password expiration warning should be sent 1 day prior to the password expiring.

If this attribute is not present, or if the value is 0d no warnings are returned. If not 0d, the value must be smaller than the value of the pwdMaxAge attribute.

>**NOTE – your password policy must uphold the following rule: pwdMinAge + pwdExpireWarning < pwdMaxAge.**

When this is configured, a control is returned with the BindResponse (even if the client doesn’t specifically request it) indicating the amount of time until expiration. An example is shown below.

PasswordExpiringControl {2.16.840.1.113730.3.4.5 false secondsUntilExpiration=432000}

### Allow a certain number of login attempts after the password expires

These are known as grace logins. The value of this parameter is stored in the pwdGraceAuthNLimit attribute of the cn=Password Policy entry. The parameter specifies the number of times an expired password can be used to authenticate. If this attribute is not present, or if the value is 0, authentication fails if the password has expired.

During the grace login attempts, bind requests are processed. However, the subsequent operation after the bind must be a modifyRequest to change the password. Otherwise, an error message is returned indicating “You must change your password before submitting any other requests”.

#### Password Content

The following are the password content options.
-	Password minimum length
-	Minimum required digit (0-9) characters
-	Minimum required uppercase (A-Z) characters
-	Minimum required lowercase (a-z) characters
-	Minimum required special characters
-	Password encryption

If more complex password content is required, the Password Strength Rule can be used.

Each of these properties is described below.
 
![An image showing ](Media/Image3.108.jpg)

Figure 7: Password Content and Account Lockout Options
Enabled

This option is only applicable to custom password policies.
Custom policies can enforce specific password content criteria or inherit from the default policy. If enabled, the custom policy password contents are enforced and override the conditions defined in the default policy. A value of 0 means unlimited, NOT undefined.

If not enabled, the default policy dictates the password content criteria.

### Password minimum length

This value is stored in the pwdMinLength attribute of the cn=Password Policy entry.  This attribute holds the minimum number of characters that must be used in a password. If this attribute is not present, no minimum password length is enforced.

### Minimum Required Digit Characters

This value indicates the number of required numerical characters required in passwords.

### Minimum Required Uppercase Characters

This indicates the number of uppercase characters required in passwords.

### Minimum Required Lowercase Characters

This value indicates the number of lowercase characters required in passwords.

### Minimum Required Special Characters

This value indicates the number of special characters required in passwords.

### Minimum Required Altered Characters

This value indicates the number of characters that must vary between the old password and the new password. This option requires enabling both “User must change password after reset” and “Require existing password in order to change password” in the Password Change section of the password policy.

>**Note – This leverages the Damerau Levenshtein algorithm to determine the variation of characters between the old and new passwords.**

### Restrictions on Using Accountname or Username

This value is stored in the pwdEnableNotContainNames attribute of the cn=Password Policy entry and has a value of true or false. If true, the user’s password must not contain the user’s accoutname or parts of the user’s full name that exceed two consecutive characters.

For the accountname value, the sAMAccountname attribute is checked first. If sAMAccountname is not found, the uid attribute is checked. If uid is not found, rdn value is checked. For the user’s full name, the attribute displayName is checked. If displayName is not present, cn is checked. If the cn attribute is not found, the full name is computed (givenName+sn) and checked. These checks are not case-sensitive.

### Password Encryption

The passwords that are stored in a RadiantOne Universal Directory store may be hashed using any of the following methods: Clear, CRYPT, MD5, PBKDF2AD, Salted SHA-1, Salted SHA-256, Salted SHA-384, Salted SHA-512, and SHA-1.  The least secure methods of CRYPT, MD5, and SHA-1 have been hidden as options from the Main Control Panel.

><span style="color:red">**IMPORTANT NOTE – PBKDF2AD is the required password encryption expected in Azure AD. Therefore, if your HDAP store (or persistent cache) will be synchronized to Azure AD, and passwords are a part of the synchronization, use the PBKDF2AD encryption option to store passwords in the RadiantOne Universal Directory.**

### Automatic Update to Stronger Password Hash

If the “Update stored passwords to stronger encryption after successful bind” is enabled, user accounts that contain a password hashed with a less secure method than allowed for the current password policy are automatically updated to the stronger hash after a successful bind. The only exception to this is for passwords that have a current hash of: PKCS5S2, PBKDF2, PBKDF2AD, SCRYPT, BCRYPT, SMD4, or MD4, in which case the hashing is not changed. This value is stored in the pwdEnableAlgorithmUpgrade attribute of the cn=Password Policy entry and has a value of True or False.

The strength order is as follows:

```
CLEAR -> CRYPT -> MD5 -> SHA1 -> SSHA1 -> SHA256 -> SSHA256 -> SHA384 ->  SSHA384  -> SHA512 -> SSHA512 -> (PKCS5S2 | PBKDF2 | PBKDF2AD | SCRYPT | BCRYPT | SMD4 | MD4)
```

>**Note - PKCS5S2, PBKDF2, PBKDF2AD, SCRYPT, BCRYPT, SMD4, and MD4 are considered as special hashes of the strongest ranking.**

### Password Strength Rule

The default options for enforcing password content are based on an AND operation. For example, if you set a minimum password length, minimum number of required digits, and a minimum number of required uppercase letters, the rule would be expressed as follows.

```
<min password length> AND <min # of digits> AND <min # uppercase letters>.
```

The Password Strength Rule option allows you to define and test password strength requirements that are more complex using an OR condition. For example, you could use the Password Strength Rule option to require a password to have 'n' number of special characters OR 'n' number of Upper Case characters. In another example, a password strength rule requiring at least six total characters, with at least one lower case, at least one uppercase letter, and at least one digit OR one symbol would be expressed in the Password Strength Rule field as follows.

```
^.(?=.{6,})(?=.[a-z])(?=.[A-Z])(?=.[\d\W]).*$
```

Another example would be if you do not want to allow special characters to be used in the password. This would be expressed in the Password Strength Rule field as:
^[a-zA-Z0-9]+$

>**Note - Checking the Password Strength Rule box disables and overrides all other password Content options except Password minimum length and Password encryption.**

Enter your password strength rule using regular expression syntax.

Click **Test** to compile your expression.

### Enable Dictionary Check

The Enable Dictionary Check option is comparable to the Strong Password Check plug-in found in legacy LDAP directories. This enables RadiantOne to verify that a user’s password doesn’t contain unallowed strings from a specified dictionary file. This can be used as a method to enforce strong password policies.

To enable this feature:

1.	From Main Control Panel, navigate to the Settings tab >Security > Password policies section.

2.	Locate the Password Content section and check the option to Enable Dictionary Check. This value is stored in the pwdEnableDictionary attribute of the cn=Password Policy entry and has a value of True or False.

3.	Click **Browse** to navigate to the dictionary file. The value for the location of the dictionary file is stored in the pwdDictionaryFile attribute of the cn=Password Policy entry.

>**Note - The dictionary file must be a text-formatted file containing one dictionary word per line.**

4.	Click **Save**.

### Account Activity and Lockout

Accounts may be automatically locked under two circumstances:

1.	If a user has not authenticated successfully to RadiantOne for longer than a specified period of time.

2.	If a user has reached the failed login threshold.
Keep Track of User’s Last Successful Login Time
If you want to keep track of a user’s last successful login time, enable the option to “Keep track of the user’s last successful logon time” in the Account Activity section of the password policy.

><span style="color:red">**IMPORTANT NOTE - You can exclude pwdLastLogonTime changes from the RadiantOne changelog by setting the following property in ZooKeeper at /radiantone/<Config_Version>/<RadiantOne_ClusterName>/config/vds_server.conf: "skipLoggingIntoChangelogForPwdLastLogonTime" : "true",**

><span style="color:red">**This alleviates excessive writing into the changelog when you have a large volume of user login activity. This property is enforced globally and affects all password policies.**

You can indicate the frequency that RadiantOne records the time of the last successful authentication. The default value is 0s meaning that the last login time is updated on every successful authentication. To change the default, indicate the length of time in any combination of days, hours and/or minutes using “d” for days (e.g. 1d), “h” for hours (e.g. 4h), and “m” for minutes (e.g. 5m). For example, a value of 1d indicates the last login time is updated if at least 1 day has passed since the last successful authentication. Subsequent successful authentications, within this time frame, do not change the last login time.

><span style="color:red">**IMPORTANT NOTE – there is a performance impact on RadiantOne if you keep track of last successful logins because a write operation is performed with a successful bind. It is recommended that you indicate a frequency for writing the last login and that you test the usage of this feature to determine if the degradation in performance is acceptable for your usage.**

If accounts should be automatically locked when a user has not authenticated successfully for a predetermined amount of time, indicate the threshold (number of days) in the “Account Activity” section of the password policy where you see “Lock user’s account if the user is idle longer than <X> days”. The user’s password must be reset to unlock the account. Once the account is unlocked, if it is not used for login longer than the specified time, the account is locked again. If the value is zero days, this means users will never be locked out.

### Lock Accounts Based on Number of Failed Logins

If accounts should be locked out after a failed login threshold is met, check the Accounts may be locked out option in the password policy, and establish the criteria.

-	How may login failures are allowed?  
Enter this value for X (Lockout account after X login failures).

This value is stored in the pwdMaxFailure attribute of the cn=Password Policy entry and contains the number of failed login attempts to allow. This corresponds to the operational attribute for the user entry named pwdFailureTime which stores the time(s) of the login failure(s).
-	How often to reset the failure count?
Enter this value for X (Reset failure count after X minutes).

This value is stored in the pwdFailureCountInterval attribute of the cn=Password Policy entry. This is the temporary interval of time in which RadiantOne keeps track of the number of failed login attempts. For example, if the number of login failures allowed is 2 and the reset failure account is 5 minutes, this means if a user login fails twice within 5 minutes, the account will be locked. If the user logs in unsuccessfully once and then doesn’t try again until after the 5-minute interval has passed, the number of unsuccessful login attempts is reset and the new failed login attempt counts as the first failure instead of the second failure. This relates to the number of values for the pwdFailureTime operational attribute in the user’s entry which is used to determine how many failed logins have been attempted.

>**Note – Once an account is locked, the reset failure count is irrelevant in terms of determining how many failed login attempts have occurred.**

-	How long is an account locked out?
    <br>Lockout forever
    <br>Lockout duration X minutes

    This value is stored in the pwdLockoutDuration attribute of the cn=Password Policy entry. This relates to the operational attribute pwdAccountLockedTime in the user’s entry which includes a timestamp indicating when the user’s account became locked. Once a lockout duration has passed, or a user’s password has been reset by an administrator, the account is unlocked. Any user (other than the locked out user) that has the proper permissions (ACI’s) can reset the user’s password.

### Unlocking Accounts

If a user’s account is locked, it can become unlocked by resetting the user’s password. Any user (other than the locked out user) that has the proper permissions (ACI’s) can reset the user’s password. If the lockout policy has a duration period, the account is automatically unlocked after the duration has passed.

### Operational Password Attributes Stored in User Entries

><span style="color:red">**IMPORTANT NOTE – since these attributes are defined as operational attributes, they do not appear in the user entries unless specifically requested in the search from the client.**

**pwdHistory** – stores the previous values used for passwords to prevent users from re-using previous passwords. The number of passwords that are stored is determined by the value set in the pwdInHistory attribute of the Password Policy.

**pwdChangedTime** - A Generalized Time attribute containing the time the password was last changed.

**pwdLastLogonTime** - stores the user’s last successful login time (bind) if the “Keep track of the user’s last successful logon time” is enabled.

**pwdAccountLockedTime** - A Generalized Time attribute containing the time at which the account was locked. If the account is not locked, this attribute is not present.

If the maximum consecutive login failures (pwdMaxFailure) have been reached during a certain period of time (pwdFailureCountInterval), the user entry will have the operational attribute of: pwdAccountLockedTime and it will contain the time the account became locked.

passwordExpWarned - A Generalized Time attribute containing the time at which the password expiration warning was first sent to the client.

pwdFailureTime - A multi-valued Generalized Time attribute containing the times of previous consecutive login failures. If the last login was successful, this attribute is not present. The number of values will be no more than the value defined in Number of Login Failures for the password policy.

![An image showing ](Media/Image..jpg)

Figure 8: Number of Login Failures
 
If the last login was successful, this attribute is not present.

>**Note - Once the Reset Failure count has passed, the values of the pwdFailureTime attribute are updated during the next unsuccessful login attempt and the values are removed if the next login is successful.**

**pwdGraceUseTime** - A multi-valued Generalized Time attribute containing the times of the previous grace logins.

**pwdPolicySubentry** – An attribute that contains the DN of the password policy associated with the user. RadiantOne does not write to this attribute or allow password policies to be defined on individual users from the Main Control Panel. However, if the entry was imported from another directory, this attribute could have a value that dictates which password policy affects the user. If the value matches a policy defined in RadiantOne, this policy is enforced for the user. If the value does not match a policy defined in RadiantOne it is ignored and other configured policies below cn=Password Policy,cn=config are checked. If multiple policies affect the user, the one with the highest priority (based on precedence level) is enforced.

**pwdReset** - A Boolean attribute containing the value TRUE if the password has been reset and must be changed by the user. If a user’s password is set/reset by the RadiantOne super user (e.g. cn=directory manager), a member of the cn=directory administrators group (cn=directory administrators,ou=globalgroups,cn=config), or the user himself, this does not trigger pwdReset set to TRUE. Only when a user’s password is set/reset by other users (e.g. helpdesk) is the pwdReset set to TRUE. When the affected user logs in with the new password for the first time, they are not allowed to perform operations until they reset their password. For example, if the user attempts a search, RadiantOne responds with error code 53 and a message indicating “You must change your password before submitting any other requests”. After the user updates their password, pwdReset is removed from their entry.

If a user resets their password, RadiantOne performs the following checks based on the password policy:

-	Check if the user is allowed to change their password
-	Check minimum password age
-	Check if old password is provided with new password (if the “Require Existing Password in order to Change Password” policy is enabled)
-	Check the password length
-	Check the password quality (correct number of required characters – upper/lower/number…etc.)
-	Check if the password is in the history
-	Check if the password contains unallowed strings based on a dictionary file

After the BIND response is returned, it is up to the client to prompt the user accordingly (depending on what kind of password policy response or control was returned). 

RadiantOne returns one of the following responses to the client application:

Modify Response Code | Meaning
-|-
53	| User password changes are not allowed. If the “User may change password” is NOT enabled, and a user tries to change their password, they get this error.  <br> <br> OR <br>  <br> The password cannot be changed because it has not been long enough since the last password change. If a user tries to change their password before the minimum number of days between changes has been reached, they get this error message. <br>  <br> OR <br>  <br> The bind user’s entry contains pwdReset=TRUE, meaning they must change their password because it has been reset. The error message returned from RadiantOne is “LDAP error code 53 – Reason 773 – User must reset password: You must change your password before submitting any other requests”.
19 | This code could mean any of the following: <br> Not enough time has passed since the password was last changed. If a user tries to change their password before the minimum number of days between changes has been reached, they get this error message. <br>  <br> OR <br>  <br> The user’s current password must be provided for password changing.  If the “Require Existing Password in order to Change Password” option is enabled, and a user tries to change their password and doesn’t provide their existing password, they get this error message. <br>  <br> OR <br>  <br> The provided password is too short.  If the new password doesn’t meet the required length, they get this error message. <br>  <br> Invalid password syntax: there must be at least <N> special character(s) in the password. If the new password doesn’t contain the appropriate number of special characters as dictated by the password policy, they get this error message. The <N> is the number required per the policy. <br>  <br> Invalid password syntax: there must be at least <N> uppercase character(s) in the password. If a user tries to change their password and it doesn’t contain the appropriate number of upper case characters as indicated in the password policy, they get this error message. The <N> is the number of uppercase characters required. <br>  <br> Invalid password syntax: there must be at least <N> numerical character(s) in the password. If a user tries to change their password and it doesn’t contain the appropriate number of numeric characters as dictated by the password policy they get this error. The <N> is the number of numeric characters required. <br>  <br> Invalid password syntax: there must be at least <N> lowercase character(s) in the password. If a user tries to change their password and it doesn’t contain the appropriate number of lowercase characters as dictated by the password policy, they get this error message. The <N> is the number of lowercase characters required. <br>  <br> OR <br>  <br> Password in history. If a user is allowed to change their password and the “Keep password history” option is enabled, and the user tries to change their password to one that is in the “history”, this error message be returned. <br>  <br> OR <br>  <br> The value is not allowed by the configured password dictionary. Constraint violation.

### Access Control

The settings found in the Main Control Panel > Settings Tab > Security section > Access Control sub-section are for defining access permissions for the virtual namespace. There is a section for configuring access controls, and there is a section for global authorization settings.

![An image showing ](Media/Image3.110.jpg)
 
Figure 9: Access Controls

For details on RadiantOne Access Controls and how to define them, please see [Security and Access Controls](security-and-access-controls).

#### Authorization

The settings configured in the Authorization section determine how RadiantOne handles authorization. These settings dictate whether RadiantOne enforces defined access controls, allows anonymous access, requires passwords for bind operations, and if nested groups are supported. Each setting is described in more details below.

##### Enable ACI

The checking of ACIs by RadiantOne can be enabled or disabled by using the Enable ACI checkbox. Check the box to enable and uncheck to disable.  For specific details about setting ACI, please see [Security and Access Controls](security-and-access-controls).

##### Allow Anonymous Access

If RadiantOne should allow anonymous access, then check the Allow Anonymous Access checkbox. If RadiantOne should not allow anonymous access, make sure this checkbox is not checked. This is the default global access permission for anonymous users and is enforced before subsequent ACI rules. In other words, even if anonymous access were allowed as a general policy, subsequent ACI rules could prevent anonymous users from accessing any data.  For details on access controls that can be set, please [Security and Access Controls](security-and-access-controls).

##### Allow Directory Manager to Impersonate Other Users

Proxy authorization allows the user that creates a connection to RadiantOne to impersonate/request access on behalf of another user. This allows authorization to be enforced for a user other than the one that creates the connection/binds to RadiantOne. By default, the RadiantOne super user (e.g. cn=directory manager) is not allowed to impersonate other users. If you want this special user to be able to impersonate other users (to enforce authorization based on other users instead of as the super user), enable the “Allow Directory Manager to Impersonate Other Users” option. Also, verify that the [Proxy Authorization Control]() is enabled for RadiantOne because this is the control that allows clients to request access on behalf of another user.

##### Bind Requires SSL or StartTLS

If a user binds to RadiantOne and provides a password, that password is vulnerable to interception by a third party when sent over non-SSL ports. To help prevent this vulnerability, you can enforce that binds always use the SSL/TLS ports by using the Bind requires SSL or StartTLS option.

><span style="color:red">**IMPORTANT NOTE – As a best practice, it is recommended that you only allow SSL communication to the RadiantOne service. If you require non-SSL communication but still want to require that binds use SSL or StartTLS, you can use this option.**

This option requires enabling SSL. If you want binds to use StartTLS, you must also enable StartTLS. Refer to [SSL Settings]() for more information on these settings.

If you enable Bind Requires SSL or StartTLS, to avoid problems when using the Main Control Panel you must enable “Use SSL” for internal connections in Main Control Panel > Settings > Internal Connections. This setting corresponds to the “internalVDSClientEnableSSL” setting in ZooKeeper at: /radiantone/v2/doc737cluster/config/vds_server.conf.

![An image showing ](Media/Image3.111.jpg)
 
Figure 10: Internal Connection Settings

##### Bind Requires Password

If a user binds to RadiantOne and does not provide a password, the default behavior is to treat it like an anonymous user. This may introduce security problems for the client application, or in certain cases where machines like printers may bind against RadiantOne, that do not verify that the client actually provided a password. If the Bind Requires Password setting is enabled, and no password is specified in the bind request, RadiantOne tries to bind the specified user and return an invalid credential error to the client. If Bind Requires Password is not enabled, and a bind request comes in with a valid user DN and no password, it is considered an anonymous bind.

##### Enable Nested Groups

If you have groups stored in a RadiantOne Universal Directory store and want to support groups as members, check the Enable Nested Groups option.

><span style="color:red">**IMPORTANT NOTE – Processing nested groups is not efficient and is not enabled by default. When nested groups are used in RadiantOne ACLs for access controls, many recursive searches are required. Large groups with a mix of many members including other groups as members can have poor performance. Use nested groups with caution and validate your use case with performance testing to ensure response times meet your needs.**

##### LDAP_MATCHING_RULE_IN_CHAIN

RadiantOne supports the LDAP_MATCHING_RULE_IN_CHAIN operator and allows clients to issue search filters using the 1.2.840.113556.1.4.1941 matching rule OID. This provides a method to look up the ancestry of an object and can be used in a search filter to retrieve all groups a user is a member of even when that group is nested (and is a member of another group). If the base DN in the RadiantOne namespace is associated with a proxy view, the search filter containing the matching rule OID is passed to the backend which must process the LDAP_MATCHING_RULE_IN_CHAIN. If the base DN in the RadiantOne namespace is associated with a persistent cache or a Universal Directory store, RadiantOne processes the matching rule locally.

><span style="color:red">**IMPORTANT NOTE – if you are using the Linked Attributes calculation in RadiantOne and the users and groups are local, in a persistent cache or Universal Directory store, you must enable the Optimize Linked Attribute setting to support filters requesting isMemberOf/memberOf. This ensures good performance. For details on this setting, see the Namespace Configuration Guide (applicable to RadiantOne Universal Directory stores) or the Deployment and Tuning Guide (applicable to persistent cache).

![An image showing ](Media/Image3.112.jpg)

As a simple example, assume there is a group named All Users and that this group is a member of another group named Sales. The screen below shows the All Users group containing member Adan_Funston.

![An image showing ](Media/Image3.113.jpg)
 
Figure 11: Example Group

The screen below shows the Sales group containing the All Users group as a member.

![An image showing ](Media/Image3.114jpg)
 
Figure 12: Example Nested Group

A client can issue a search leveraging the matching rule OID to retrieve all groups Adan_Funston is a member of with the following search filter.

```
(uniqueMember:1.2.840.113556.1.4.1941:=uid=Adan_Funston,ou=Accounting,o=companydirectory)
```

A search request to RadiantOne with the above filter would return Sales and All Users as shown in the example client below.

![An image showing ](Media/Image3.115.jpg)
 
Figure 13: Search Filter using Matching Rule OID

><span style="color:red">**IMPORTANT NOTE – Queries requesting an intersecting set of multiple memberships like in the following filter are not supported.**

><span style="color:red">**(&(ismemberof:1.2.840.113556.1.4.1941:=cn=max,ou=groups,dc=data)(ismemberof:1.2.840.113556.1.4.1941:=cn=othergroup,ou=groups,dc=data))**

## Client Certificate Trust Store (Cluster Level Trust Store)

Many RadiantOne installed components (e.g. Control Panel) act as client’s to the local RadiantOne service and might require SSL access. Therefore, any time you change the RadiantOne server certificate, you must import the corresponding public key certificate into the Client Certificate Trust Store (unless the signer of the server certificate is already trusted).

Also, the certificates in the Client Certificate Trust Store are used by RadiantOne to connect via SSL to underlying data sources. Therefore, the appropriate client (public key) certificate (associated with the server certificate of the backend) needs imported into the Client Certificate Trust Store (unless they are signed by a trusted/known Certificate Authority).

RadiantOne loads all client certificates from the default Java truststore (<RLI_HOME>/jdk/jre/lib/security/cacerts) when it starts. Then, it dynamically loads all other certificates from the Client Certificate Trust Store. This allows client certificates to be dynamically added at any time without needing to restart the RadiantOne service. When RadiantOne is deployed in a cluster, all nodes share the contents of the Client Certificate Trust Store.

>**Note - It is not recommended to import client certificates into the default Java truststore (<RLI_HOME>/jdk/jre/lib/security/cacerts) since this is overwritten each time there is a RadiantOne patch that requires a Java update and requires a restart of the RadiantOne service every time you add new certificates. For these reasons, it is recommended to use the RadiantOne Client Certificate Trust Store instead.**

Import client certificates into the truststore from the Main Control Panel > Settings Tab > Security section > Client Certificate Truststore. Certificates can be viewed, imported, exported or deleted from here.

><span style="color:red">**IMPORTANT NOTE – when RadiantOne is deployed in a cluster, the public key associated with each server node must be stored in the client certificate truststore if you want the nodes to be able to communicate with each other over SSL. Keep this in mind if you ever change the server certificates on any of the cluster nodes.**

### Viewing Client Certificates

To view a certificate, select the certificate in the list and click **View**. Valuable information about the certificate is shown (who issued the certificate, who the certificate was issued to, when the certificate is set to expire, status…etc.).

#### Adding Client Certificates

To add a certificate:
1.	Click **Import**.
2.	Enter a short, unique name (alias) for the certificate.
3.	Browse to the location of the client certificate file and click **OK**.
4.	Click **Save** in the upper right corner.

#### Deleting Client Certificates

To delete a certificate:

1.	Select the desired certificate and click **Delete**.
2.	Click **Yes** to confirm the deletion.
3.	Click **OK** to exit the confirmation.
4.	Click **Save** in the upper right corner.

#### Exporting Client Certificates

To export a certificate:

1.	Select the desired certificate and click **Export**.
2.	Enter a location to export the file to.
3.	Enter a name for the exported file.
4.	Click **OK** to export the certificate to a file.
5.	Click **OK** to exit the confirmation.
6.	Click **Save** in the upper right corner.

>**Note - If RadiantOne is deployed in a cluster, all nodes share the contents of the client certificate truststore.**

## RadiantOne Universal Directory Attribute Encryption

Attribute encryption prevents data from being readable while stored in a RadiantOne Universal Directory store, any temporary replication stores/attributes (cn=changelog, cn=replicationjournal, cn=localjournal), backup files, and exported LDIF files (must use the LDIFZ file extension). Attribute values are encrypted before they are stored in the Universal Directory store, and decrypted before being returned to the client, as long as the client is authorized to read the attribute (based on ACLs defined in RadiantOne), is connected to RadiantOne via SSL, and is not a member of the special group (e.g. cn=ClearAttributesOnly,cn=globalgroups,cn=config).

There are two items to configure. One is the criteria for the key generation used to encrypt/decrypt the attributes. Two is the list of attributes you want to encrypt.

### Key Generation

To define the criteria used to generate an encryption key:
1.	Navigate to Main Control Panel > Settings Tab > Security section > Attribute Encryption sub-section.

2.	On the right, click on Define Key Generation.

3.	Select the desired cipher from the drop-down list or select [AWSKMS]() if you want to use your own Customer Master Key (CMK) in Amazon Web Services (AWS) Key Management Service (KMS) and have configured the necessary settings in ZooKeeper. If unlimited Java security libraries are installed, there are more ciphers shown in this drop-down list.

>**Note - If you want to use stronger ciphers that are not listed, you must add crypto.policy=unlimited in <RLI_HOME>/jdk/jre/lib/security/java.security file. For more details, see the RadiantOne Hardening Guide.**

![An image showing ](Media/Image3.116.jpg)
 
Figure 14: Attribute Encryption Key

4.	If you selected a cipher suite in the previous step, enter a security key. This value is used to auto-generate an encryption key. If you plan on deploying multiple clusters that will participate in inter cluster replication for encrypted attributes, take note of the value you enter here as you must use it when configuring the security key in the other clusters.

An encryption key is auto-generated based on the cipher and security key value provided. This key is used across nodes in a cluster to encrypt/decrypt the attributes configured for encryption. If inter-cluster replication is deployed, all clusters must be configured with the same cipher and security key.

### Using Amazon Web Services (AWS) with a Customer Master Key (CMK)

Instead of using the default key generation, you have the option to use a customer master key stored in AWS. The following steps describe the configuration.

>**Note – Key rotation is optional in AWS for KMS. If enabled, the default key rotation is once every 365 days. For details on AWS Key Management Service, please see the AWS documentation.**

1.	Log into your AWS account to create your CMK (Customer Master Key).

2.	With your CMK information, log into the Main Control Panel and go to the ZooKeeper tab.

3.	On the ZooKeeper tab, navigate to /radiantone/v2/doccluster/config/vds_server.conf, click Edit Mode, and locate the following properties:

```
  "awsAccessKeyId" : null,
  "awsSecretAccessKey" : null,
  "awsKmsCMKRegion" : null,
  "awsKmsCMKAlias" : null,
```

4.	For the “awsAccessKeyId” property, overwrite the null value with your AWS Access Key ID.

5.	For the “awsSecretAccessKey” property, overwrite the null value with your AWS Access Key Secret.

6.	For “awsKmsCMKRegion” property, overwrite the null value with your AWS region (e.g. "us-east-2").

7.	For “awsKmsCMKAlias” property, overwrite the null value with (e.g. "alias/My_Master_Key”).

8.	Click **Save**.

9.	Navigate to Main Control Panel > Settings > Security > Attribute Encryption and click **Define Key Generation** in the relevant section.

10.	Select the AWSKMS option from the drop-down list and click **OK**.

11.	Click **OK** to confirm.

12.	Define the attributes to encrypt as outlined in the next section.

### Attributes to Encrypt

No attributes are encrypted by default. To configure a list of attributes to encrypt:

1.	Navigate to the RadiantOne Universal Directory (HDAP) store (or configured persistent cache branch) on the Main Control Panel > Directory Namespace tab. 

2.	Enter a comma-separated list of attribute names in the Encrypted Attributes property. 
3.	Click **Save**.
4.	Click **Re-build Index** (if your configuration is a Universal Directory Store) or **Initialize** to reinitialize the cache (if your configuration is a Persistent Cache).

Attributes listed in the Encrypted Attributes property are added to the Non-indexed attribute list by default. This means these attributes are not searchable by default. Indexing encrypted attributes is generally not advised as the index itself is less secure than the attribute stored in Universal Directory/persistent cache. However, if you must be able to search on the encrypted attribute value, it must be indexed. Only “exact match/equality” index is supported for encrypted attributes. To make an encrypted attribute searchable, remove the attribute from the list of nonindexed attributes and then click **Re-build Index** or **Initialize** (to reinitialize) if the branch is a persistent cache.

### Accessing Encrypted Attributes

Attribute values are encrypted before they are stored in Universal Directory/persistent cache, and decrypted before being returned to the client, as long as the client is authorized to read the attribute (based on ACLs defined in RadiantOne), is connected to RadiantOne via SSL, and not a member of the special group containing members not allowed to get these attributes (e.g. cn=ClearAttributesOnly,cn=globalgroups,cn=config). 
 
#### Using Main Control Panel

When viewing Universal Directory/persistent cache entries or exporting them to an LDIF file from the Main Control Panel > Directory Browser tab, make sure you are connected via SSL, otherwise the attributes are returned/exported as encrypted.

If you are connected to the [Control Panel via SSL](), then the operations performed on the Directory Browser tab are based on an SSL connection to RadiantOne, and the attributes defined as encrypted are returned decrypted as long as the user you’ve connected to the Main Control Panel with is authorized to read those attributes and this user is not a member of the Clear Attributes Only Group (which by default is the ClearAttributesOnly group located at,ou=globalgroups,cn=config).

#### Querying Changelog

When entries containing encrypted attributes are updated and logged into the RadiantOne changelog (e.g. cn=changelog), a client that is connected to RadiantOne via SSL, and is NOT a member of the special [Clear Attributes Only Group]() (which by default is the ClearAttributesOnly group located at,ou=globalgroups,cn=config) can see encrypted attributes in clear text. If the client is connected to RadiantOne via SSL and is a member of the special [Clear Attributes Only Group](), the value in the “changes” attribute is returned encrypted.

#### Clear Attributes Only Group

To apply a deny-by-exception policy to encrypted attributes, you can add users to the ClearAttributesOnly group. Members of this group cannot get encrypted attributes in clear, even if ACLs dictate they can read the encrypted attribute(s) and they are connecting to RadiantOne via SSL.

The table below summarizes the behavior of this special group when a user is connected to RadiantOne via SSL.

Is user a member of the special group?	| Attributes In DIT	| Values in “changes” attribute In Changelog
-|-|-
No		| Clear text	| Clear text
Yes		| Not displayed	| Encrypted

To add a user to the Clear Attributes Only group:

1.	In the Main Control Panel, click the Directory Browser tab.

2.	Expand cn=config and then expand ou=globalgroups.

3.	Select cn=ClearAttributesOnly.

4.	On the right, click ![An image showing ](Media/manage-group-button.jpg) (Manage Group).

5.	From here you can add users to the group.

>**Note – To change the default group, on the Main Control Panel, go to the Zookeeper tab (requires [Expert Mode](introduction#expert-mode)). Expand radiantone > `<version>` > `<clustername>` > config and select vds_server.conf. Modify the value for "encryptedAttributeBlacklistGroupDn" to the full DN that points to the group entry to which the exclusion behavior should apply.**

### Updating Encrypted Attributes

To update encrypted attributes, the client must connect to RadiantOne via SSL and be authorized (via ACLs) to read and update the attribute and not be in the special [Clear Attributes Only Group](). When editing entries from the Main Control Panel > Directory Browser tab > selected Universal Directory store, encrypted attributes appear as encrypted because this operation is not connected to RadiantOne via SSL. If you are connected to the [Control Panel via SSL](), then the Directory Browser tab connects to RadiantOne via SSL and the attributes defined as encrypted are shown in clear as long as the user you’ve connected to the Main Control Panel is authorized to read those attributes and is not a member of the blacklisted group. In this case, the connected user can also update the encrypted attribute if permissions allow for it.

### Changing an Encryption Key

If you need to change the encryption security key, follow the steps below.

1.	Go to Main Control Panel > Directory Namespace tab.

2.	Select the naming context representing the Universal Directory (HDAP) store.

3.	On the right, remove all values from the encrypted attributes list.

4.	Click **Save**.

5.	Click **Re-build Index**.

6.	Repeat steps 1-5 for each store that has encrypted attributes.

7.	Go to Main Control Panel > Settings tab > Security > Attribute Encryption.

8.	Click **Define Key Generation**. This option is only available if you removed encrypted attributes and rebuilt the index for all applicable stores.

9.	Go to Main Control Panel > Directory Namespace tab.

10.	Select the naming context representing the Universal Directory (HDAP) store.

11.	On the right, add required attributes to the encrypted attributes list.

12.	Click **Sav**e.

13.	Click **Re-build Index**.

14.	Repeat steps 9-13 for all stores that require encrypted attributes.

## LDIF File Encryption

Using the LDIFZ format when exporting entries produces a zipped and encrypted LDIF file. This prevents data from being readable while stored in exported LDIF files. This setting is required to support [LDIFZ file exports](#requiring-ldifz-for-exports). 

### Key Generation

To define the criteria used to generate an encryption key:

1.	Navigate to Main Control Panel > Settings Tab > Security section > Attribute Encryption sub-section.

2.	On the right, for LDIFZ Encryption Key, click **Define Key Generation**.

3.	Select the desired cipher from the drop-down list or select [AWSKMS]() if you want to use your own Customer Master Key (CMK) in Amazon Web Services (AWS) Key Management Service (KMS) and have configured the necessary settings in ZooKeeper. If unlimited Java security libraries are enabled, there are more available ciphers in this drop-down list.

>**Note - If you want to use stronger ciphers that are not listed, you must add (or uncomment) crypto.policy=unlimited in <RLI_HOME>/jdk/jre/lib/security/java.security file. For more details, see the RadiantOne Hardening Guide.**

4.	If you selected a cipher suite in the previous step, enter a security key. This value is used to auto-generate an encryption key. If you plan on deploying multiple clusters that will participate in inter cluster replication and you are going to initialize Universal Directory (HDAP) stores from an exported LDIFZ file, take note of the value you enter here as you must use it when configuring the LDIFZ cipher and security key in the other clusters.

### Changing an Encryption Key

If you need to change the LDIFZ encryption security key, follow the steps below.

1.	Go to Main Control Panel > Settings tab > Security > Attribute Encryption.

2.	On the right, for LDIFZ Encryption Key, click Define Key Generation.

3.	Select the cipher and enter a security key.

4.	Click **OK**.

5.	Click **Save**.

>**Note – LDIFZ files generated with the old encryption key are no longer usable.**

### Requiring LDIFZ for Exports

The Secure LDIF Export option allows you to enforce the use of the encrypted LDIFZ format when exporting entries from the Directory Browser tab. With this setting enabled, using the unencrypted LDIF format for exports is not supported.

>**Note – Enabling secure LDIF exports requires first defining an LDIFZ encryption key. See the [Changing an Encryption Key](#changing-an-encryption-key) section for more information.**

To enable the secure LDIF export option:

1.	In the Main Control Panel, click the Settings tab.

2.	Navigate to the Security section and select Attribute Encryption.

3.	In the Secure LDIF Export section, click the Enabled switch.

4.	Click **Save**.

This feature works with the LDIFZ Encryption option as outlined in the table below.

<table>
<tr>
<td>LDIFZ Encryption Key	
<td>Secure LDIF Export	
<td>Available Export Formats:		
<br>LDIF	 
<td>Available Export Formats: 
<br>LDIFZ </p>
<tr>
<td> undefined	
<td>Disabled	
<td>🗹	
<td>⌧</p>
<tr>
<td>undefined
<td>Enabled	
<td> N/A because you can’t enable Secure LDIF if the LDIFZ encryption key is not defined.	
<td>N/A because you can’t enable Secure LDIF if the LDIFZ encryption key is not defined.
<tr>
<td>defined	
<td>Disabled	
<td> 🗹	
<td>🗹
<tr>
<td>defined
<td> Enabled	
<td> ⌧	
<td>🗹
</table>