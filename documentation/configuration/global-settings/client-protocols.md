---
title: Client Protocols
description: Learn about the client protocols supported to query RadiantOne. 
---

## Overview

Info.

## LDAP
RadiantOne Identity Data Management supports LDAPv3 as documented in [RFC 2251](http://www.faqs.org/rfcs/rfc2251.html) as a client protocol for querying the service.

### User to DN Mapping
Typically, an LDAP client performs authentication first by searching the RadiantOne namespace for a specific user (based on configuration of the client to search for a specific attribute like cn, sAMAccountName, uid…etc.), and then issues a bind with the user DN returned in the search. These two steps are referred to as identification and credential checking respectively.

If this functionality is not implemented at the client level, RadiantOne can be configured to perform the identification step with user ID to DN mappings. This configuration describes how RadiantOne should find the user DN based on the ID that was received in the bind request.

Let’s look at the following examples to describe the difference.

In the diagrams below, the client is configured to search for the user account and then issue the bind.

![An image showing ](Media/Image3.120.jpg)

Figure 2: Identification Step of Authentication

![An image showing ](Media/Image3.121.jpg)
 
Figure 3: Credentials Checking Step of Authentication

If the client application is not configured (or cannot be configured) to issue a search and then bind, RadiantOne can be configured to perform the search (to find the DN). This is accomplished using User ID to DN mappings.

![An image showing ](Media/Image3.122.jpg)
 
Figure 4: Authentication Process based on User ID to DN Mapping

### Manage Global User to DN Mapping

This location is just for configuring a global user ID to DN mapping. If you are configuring a mapping for [Kerberos](06-security#kerberos), [NTLM](06-security#ntlm), or [MD5](06-security#md5), the configuration is set in those sections located on the Main Control Panel > Settings Tab > Security section > Authentication Methods.

There are three different ways to determine the DN from the user ID (using regular expression syntax). Each is described below.

-	Setting a specific User ID to DN. In this example, if lcallahan were received in the authentication request, RadiantOne would base the authentication on the DN: cn=laura Callahan,cn=users,dc=mycompany,dc=com

`    lcallahan (the user ID) -> (maps to) cn= laura Callahan, cn=users,dc=mycompany,dc=com`

-	Specify a DN Suffix, replacing the $1 value with the User ID.

`(.+) -> uid=$1,ou=people,ou=ssl,dc=com` 
<br> `(.+) represents the value coming in to RadiantOne. If it received a User ID of lcallahan, the DN used to issue the Bind to the underlying directory would be: uid=lcallahan,ou=people,ou=ssl,dc=com.`

-	Specify a Base DN, scope of the search, and a search filter to search for the user based on the User ID received in the bind request.

`(.+) -> dc=domain1,dc=com??sub?(sAMAccountName=$1)`

If RadiantOne received a User ID of lcallahan, it would issue a search like:

`dc=domain1,dc=com??sub?(sAMAccountName=lcallahan)`

Then, a bind request is issued with the user DN that is returned.

For options 2 and 3 described above, multiple variables can be used (not just 1 as described in the examples). Let’s look at an example mapping that uses multiple variables:

`(.+)@(.+).(.+).com -> ou=$2,dc=$3,dc=com??sub?(&(uid=$1)(dc=$3))`

If RadiantOne received a user ID like laura_callahan@ny.radiant.com, the search that would be issued would look like:

`ou=ny,dc=radiant,dc=com??sub?(&(uid=laura_callahan)(dc=radiant))`

RadiantOne uses the DN returned in the search result to issue the Bind request to the backend directory.

### Processing Multiple Mapping Rules

Many User to DN Mapping rules can be configured. They are processed by RadiantOne in the order they appear.

If a single User ID is found with the first mapping rule, then no other rules are evaluated. If the credential is correct, the user is authenticated (by the underlying directory). If the credentials are not correct, the authentication fails. If the authentication fails, no other DN mapping rules are executed. Only if the user is not found using the first DN mapping rule or if multiple users are returned based on the first rule causing ambiguity, will the other rules be evaluated. 

For example, if Laura Callahan, with a login of laura_callahan, is in two sources and there are two DN Mapping rules configured:

`dc=domain1,dc=com??sub?(sAMAccountName=$1)
uid=$1,ou=people,ou=ssl,dc=com`

The first DN Mapping rule is evaluated (dc=domain1,dc=com??sub?(sAMAccountName=laura_callahan)

If Laura Callahan’s account is found from the search, a BIND request is issued using her DN. If the credentials don’t match what are in the underlying directory, the authentication fails. The second DN mapping rule is NOT evaluated. Only when the first DN mapping rule fails to find a user, or if multiple users are returned by the first rule (causing ambiguity), will the other DN mapping rules be used. If no other rules are defined, the authentication fails.
### Supported Controls
LDAP controls, as documented in [RFC 2251](http://www.faqs.org/rfcs/rfc2251.html), offer clients and directory services a mechanism for extending an LDAP operation. 
A client can use a control to specify additional information as part of a request. For example, a client can send a control to a server as part of a search request to indicate that the server should sort the search results before sending the results back to the client. A directory service can return a control in an LDAP operation response to provide additional information to a client. For example, a directory service can send a control in a client bind response to indicate that a password is about to expire. The client could then prompt the user to update their password.

For details on controls supported by RadiantOne Identity Data Management, see [Supported Controls](06-security#kerberos)

## SCIMv2
**LINK TO SCIMv2 PAGE**

## REST
**LINK TO REST PAGE**
