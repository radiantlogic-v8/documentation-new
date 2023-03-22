---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

# Naming Context Property Commands

This chapter explains how to display a list of accepted property names, and how to set, print, and remove the current value for a property. The commands can be issued using the <RLI_HOME>/bin/vdsconfig utility.

## list-prop

This command displays a list of accepted property names categorized by configuration type (LDAP proxy, database proxy, virtual tree, RadiantOne Universal Directory store, and persistent cache).

**Usage:**
The following properties are available on all types of naming contexts:

- active
- datasourcebind
- datasourceupdate
- dsredirlocalwritemode
- noredirattr

The following properties are available only on LDAP proxies:

- accessrightoverride
- datasourcename
- dedicatedconn
- dnattributes
- filterexcluded
- filterincluded
- interceptionvalue
- isjoinoptimized
- islimitattributes
- mappedattributes
- mappedobjectclass
- masteridcache
- postprocisuffix
- postprocxfilter
- postprocxsuffix
- prefilter
- proxiedauthentication
- remotebasedn
- requestedattributes
- rolemappedaccess
- useclientsizelimit
- xjoin

The following property is available only on database proxies:

- datasourcename

The following property is available only on virtual trees:

- dvxname

The following properties are available only on RadiantOne Universal Directory stores:

- datasourcesforpush
- encryptedattr
- ensuredpush
- indexattr
- interclustrep
- location
- notindexattr
- sortedindex

The following properties are available only on persistent-cache naming contexts:

- cronexpressionperiodicrefresh
- datasourcesforpush
- encryptedattr
- ensuredpush
- interclustrep
- listenerenabled
- listenerattr
- location
- notindexattr
- sortedindex
- usecacheforauth
- validationthresholdperiodicrefresh
- validationscriptpathperiodicrefresh

**REST (ADAP) Example**

In the following example, a request is made to display a 
list of accepted property names.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-prop
```

## list-ctx

This command displays a list of the current naming contexts and their type.

**Usage:**
<br>`list-ctx [-dbproxy] [-hdap] [-http] [-instance <instance>] [-ldapproxy] [-pcache] [-root] [-virtualtree]`

**Command Arguments:**

**`- dbproxy`**
<br>Indicates that the list of naming contexts should include database proxies.
**`- hdap`**
<br>Indicates that the list of naming contexts should include RadiantOne Universal Directory (HDAP) stores.
**`- http`**
<br>Indicates that the list of naming contexts should include HTTP type stores.
**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.
**`- ldapproxy`**
<br>Indicates that the list of naming contexts should include LDAP proxies.
**`- pcache`**
<br>Indicates that the list of naming contexts should include persistent caches.
**`- root`**
<br>Indicates that only root naming contexts should be printed out.
**`- virtualtree`**
<br>Indicates that the list of naming contexts should include virtual trees.

**REST (ADAP) Example**

In the following example, a request is made to list the root naming contexts of database proxies, RadiantOne Universal Directory stores, LDAP proxies, and virtual trees.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=list-ctx&dbproxy&hdap&ldapproxy&root&virtualtree
```

## get-ctx-prop

This command prints the current value for a given property on the specified naming context.

>[!note]
>To retrieve properties for a virtual view that uses a merge tree configuration, the mergedatasource and mergedn arguments must be used.

**Usage:**
<br>`get-ctx-prop -namingcontext <namingcontext> -prop <prop> [-cache] [-instance <instance>] [-mergedatasource <mergedatasource>] [-mergedn <mergedn>]`

**Command Arguments:**

**`- namingcontext <namingcontext>`**
<br>[required] The name of the naming context to get/set the property.

**`- prop <prop>`**
<br>The name of the property to get/set. If this command argument is not specified, all properties for the specified naming context are displayed.

**`- cache`**
<br>Indicates if you want to get/set the property on a naming context that is cached.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- mergedatasource <mergedatasource>`**
<br>The data source name of the LDAP proxy merge tree. This argument should be used with the - mergedn argument when specifying an LDAP proxy merge tree.

**`- mergedn <mergedn>`**
<br>The remote base DN of the LDAP proxy merge tree. This argument should be used with the - mergedatasource argument when specifying an LDAP proxy merge tree.

**REST (ADAP) Example**

In the following example, a request is made to display the values for the dnAttributes property in an LDAP proxy.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=get-ctx-prop&namingcontext=o=ldapproxy &prop=dnattributes
```

## set-ctx-prop

This command sets the value for a given property on the specified naming context.

>[!note]
>To set properties for a virtual view that uses a merge tree configuration, the mergedatasource and mergedn arguments must be used.

**Usage:**
<br>`set-ctx-prop -namingcontext <namingcontext> -prop <prop> -value <value> [-cache] [-instance <instance>][-mergedatasource <mergedatasource>] [-mergedn <mergedn>]`

**Command Arguments:**

**`- namingcontext <namingcontext>`**
<br>[required] The name of the naming context to get/set the property.

**`- prop <prop>`**
<br>[required] The name of the property to get/set.

**`- value <value>`**
<br>[required] The value of the property to set.

**`- cache`**
<br>Indicates if you want to get/set the property on a naming context that is cached.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- mergedatasource <mergedatasource>`**
<br>The data source name of the LDAP proxy merge tree. This argument should be used with the - mergedn argument when specifying an LDAP proxy merge tree.

**`- mergedn <mergedn>`**
<br>The remote base DN of the LDAP proxy merge tree. This argument should be used with the - mergedatasource argument when specifying an LDAP proxy merge tree.

### Examples

#### REST (ADAP)

In the following example, a request is made to enable Proxy Authorization for an LDAP proxy view mounted at o=ldapproxy.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=set-ctx-prop&namingcontext=o=ldapproxy&prop=proxiedauthentication&value=true
```

#### Full Text Searching

To enable full text searching on a RadiantOne Universal Directory (HDAP) store or persistent cache naming context, use the “fulltextenabled” property. The syntax is shown below.

<RLI_HOME>/bin/vdsconfig.bat set-ctx-prop -namingcontext <naming context> -cache -prop fulltextenabled -value <true or false>

An example command for a naming context of “o=mytest” is:

vdsconfig.bat set-ctx-prop -namingcontext o=mytest -cache -prop fulltextenabled -value true

>[!warning]
>Setting this value to true only enables full text searching. You must rebuild the index for the store after setting the value to true.

#### Persistent Cache Periodic Refresh Validation Threshold

To read the current threshold value configured for a persistent cache:

```
<RLI_HOME>/bin/vdsconfig.bat get-ctx-prop -namingcontext <naming context> -cache -prop validationthresholdperiodicrefresh
```

To set a new threshold value for a configured persistent cache:

```
<RLI_HOME>/bin/vdsconfig.bat set-ctx-prop -namingcontext <naming context> -cache -prop
validationthresholdperiodicrefresh -value <number from 0 to 100>
```

The validationthresholdperiodicrefresh property described above is a global setting and does not discriminate between add and delete operations. If you want to define a granular threshold for add operations, indicate the percentage in the validationaddthresholdperiodicrefresh property. If you want to define a granular threshold for delete operations, indicate the percentage in the validationdeletethresholdperiodicrefresh property. These values override the validationthresholdperiodicrefresh property for add and delete operations respectively. For example, if validationdeletethresholdperiodicrefresh contains a value of 25, and validationaddthresholdperiodicrefresh contains a value of 50, it means if the generated LDIF image contains 50% more entries or 25% less entries than the current cache image, the periodic persistent cache refresh is aborted for the current refresh cycle.

## unset-ctx-prop

This command removes the value for the given property and sets it to empty on the specified naming context.

>[!note]
>To remove properties for a virtual view that uses a merge tree configuration, the mergedatasource and mergedn arguments must be used.

**Usage:**
<br>`unset-ctx-prop -namingcontext <namingcontext> -prop <prop> [-cache] [-instance <instance>] [-mergedatasource <mergedatasource>] [-mergedn <mergedn>]`

**Command Arguments:**

**`- namingcontext <namingcontext>`**
<br>[required] The name of the naming context to get/set the property.

**`- prop <prop>`**
<br>[required] The name of the property to get/set.

**`- cache`**
<br>Indicates if you want to get/set the property on a naming context that is cached.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- mergedatasource <mergedatasource>`**
<br>The data source name of the LDAP proxy merge tree. This argument should be used with the - mergedn argument when specifying an LDAP proxy merge tree.

**`- mergedn <mergedn>`**
<br>The remote base DN of the LDAP proxy merge tree. This argument should be used with the - mergedatasource argument when specifying an LDAP proxy merge tree.

## get-ctx-interception

To get interception options configured on proxy views, use get-ctx-interception.

An example of using the command for a naming context of o=companyprofiles is shown below.

```
vdsconfig.bat get-ctx-interception -namingcontext o=companyprofiles
```

>[!note]
>To retrieve interception options for a virtual view that uses a merge tree configuration, the mergedatasource and mergedn arguments must be used.

Usage:
get-ctx-interception -namingcontext <namingcontext> [-instance <instance>]
[-mergedatasource <mergedatasource>] [-mergedn <mergedn>]

**Command Arguments:**

**`- namingcontext <namingcontext>`**
<br>[required] The naming context to get the configured interception options for.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- mergedatasource <mergedatasource>`**
<br>The data source name of the LDAP proxy merge tree. This argument should be used with the - mergedn argument when specifying an LDAP proxy merge tree.

**`- mergedn <mergedn>`**
<br>The remote base DN of the LDAP proxy merge tree. This argument should be used with the - mergedatasource argument when specifying an LDAP proxy merge tree.

**REST (ADAP) Example**

In the following example, a request is made to retrieve interception script options configured on an LDAP proxy.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=get-ctx-interception&namingcontext=o=ldapproxy
```
## set-ctx-interception

To set interception options on proxy views, use set-ctx-interception.

Below is an example of configuring an interception for bind, add and delete for a naming context of o=companyprofiles:

```
vdsconfig.bat set-ctx-interception -namingcontext o=companyprofiles -bind true -add true - delete true
```

>[!note]
>To retrieve interception options for a virtual view that uses a merge tree configuration, the mergedatasource and mergedn arguments must be used.

The first time you use set-ctx-interception, a default interception script matching your naming context is generated in <RLI_HOME>\vds_server\custom\src\com\rli\scripts\intercept. You can always get the full path to the java file with get-ctx-interception.

After editing the Java file, the intercept.jar file must be rebuilt and the RadiantOne service must be restarted for the script to take effect. If deployed in a cluster, restart the RadiantOne service on all nodes.

**Usage:**
<br>`set-ctx-interception -namingcontext <namingcontext> [-add <true/false>] [-bind <true/false] [-search <true/false>] [-modify <true/false>] [-delete <true/false>] [-compare <true/false>] [-specialops <true/false>] [-srep <true/false>] [-instance <instance>] [-mergedatasource <mergedatasource>] [-mergedn <mergedn>]`

**Command Arguments:**

**`- namingcontext <namingcontext>`**
<br>[required] The naming context to get the configured interception options for.

**`- add <true/false>`**
<br>A value of true indicates interception on add (insert) operations is enabled. A value of false means it is not enabled.

**`- delete <true/false>`**
<br>A value of true indicates interception on delete operations is enabled. A value of false means it is not enabled.

**`- bind <true/false>`**
<br>A value of true indicates interception on bin (authentication) operations is enabled. A value of false means it is not enabled.

**`- search <true/false>`**
<br>A value of true indicates interception on search (select) operations is enabled. A value of false means it is not enabled.

**`- modify <true/false>`**
<br>A value of true indicates interception on modify (update) operations is enabled. A value of false means it is not enabled.

**`- compare <true/false>`**
<br>A value of true indicates interception on compare operations is enabled. A value of false means it is not enabled.

**`- specialops <true/false>`**
<br>A value of true indicates interception on special operations (invoke) is enabled. A value of false means it is not enabled.

**`- srep <true/false>`**
<br>A value of true indicates interception on search result entry processing (process result) operations is enabled. A value of false means it is not enabled.

**`- instance <instance>`**
<br>The name of the RadiantOne instance. If not specified, the default instance named vds_server is used.

**`- mergedatasource <mergedatasource>`**
<br>The data source name of the LDAP proxy merge tree. This argument should be used with the - mergedn argument when specifying an LDAP proxy merge tree.

**`- mergedn <mergedn>`**
<br>The remote base DN of the LDAP proxy merge tree. This argument should be used with the - mergedatasource argument when specifying an LDAP proxy merge tree.

**REST (ADAP) Example**

In the following example, a request is made to set interception script options on an LDAP proxy view.

```
https://<rli_server_name>:8090/adap/util?action=vdsconfig&commandname=set-ctx-interception&namingcontext=o=ldapproxy&add=true&delete=false&bind=true&search=true&modify=true&specialops=false
```

### Interception Values

If an interception script is enabled for a naming context, the interceptionvalue property reflects
which operations are enabled. The table below details the base values and their meaning.

| Interception Value  | Meaning |   
|------------|------------| 
0 | No operations enabled
1 | On Bind enabled
2 | On Search enabled
4 | On Modify enabled
8 | On Delete enabled
16 | On Add enabled
32 | Search Result Entry Processing enabled
64 | On Compare enabled
128 | On Special Operations (invoke) enabled

These base values can be used to calculate the value for the combinations of operations enabled. Add the values for the operations and the total is set for the interceptionvalue property. Some examples are shown in the table below.

| Interception Value  | Meaning |   
|------------|------------| 
3 | On Bind and On Search enabled
5 | On Bind and On Modify enabled
9 | On Bind and On Delete enabled
19 | On Bind, On Add and On Search enabled
34 | On Search and Search Result Entry Processing enabled
65 | On Bind and On Compare enabled
