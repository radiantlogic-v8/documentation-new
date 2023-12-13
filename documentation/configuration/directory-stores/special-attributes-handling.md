---
title: Special Attributes Handling for RadiantOne Directory Stores
description: Learn how to manage special attributes handling for RadiantOne Directory stores. 
---

## Overview

Info.

## Attribute Uniqueness
Attribute Uniqueness enforcement is applicable to RadiantOne Directory stores only.

Certain attribute values (e.g. uid) should be unique across a given container or Directory Information Tree (DIT). The server stops any operation that tries to add an entry that contains an existing value for the given attribute. It also stops any operation that adds or modifies the attribute to a value that already exists in the directory.

Attribute uniqueness is not enabled by default. To define which attributes require unique values, follow the steps below.

1.	From the Main Control Panel > Settings tab > Interception section > Special Attributes Handling sub-section, locate the Attribute Uniqueness section on the right.

2.	In the Attribute Uniqueness section, click **Add** and enter the Base DN (location of a Universal Directory store) for which attribute uniqueness should be enforced. All entries below this point require unique values for the attributes indicated in the next step.

3.	Enter a list of comma-separated attributes that should contain unique values. In the example shown in the screen below, the attributes uid and mail must be unique across all entries located below o=local.

    ![An image showing ](Media/Image3.140.jpg)

    Figure 21: Attribute Uniqueness Example

4.	Click **Save** in the upper right corner.

Repeat these steps to configure attribute uniqueness checking for additional containers/branches.

### Testing Attribute Uniqueness

To test attribute uniqueness, you must have an LDIF file containing all entries you want to check attribute uniqueness for.

To verify uniqueness of attribute values in an LDIF, you can use the Attribute Uniqueness function of the <RLI_HOME>/bin/advanced/ldif-utils utility. Once you have an LDIF file containing entries, pass the file name, path, and the name(s) of the attribute(s) to be verified. The usage is shown below. 

`ldif-utils AttrUniqueness -f <ldif file path> -u <list of (comma-separated) attributes>`

An example command analyzing values for the attributes givenName and telephonenumber is shown below. 

`c:\radiantone\vds\bin\advanced>ldif-utils.bat AttrUniqueness -f c:\globaldirectory.ldif -u givenname,telephonenumber`

If the utility returns the result, “Attribute Uniqueness check successful”, the values for the analyzed attribute(s) are unique. In this example, the utility returns the following at the end of completion of the command. 

`Checking attribute uniqueness...`
<br> `Attribute Uniqueness check successful.`
<br> `Done in 9ms`

In the following example command, the attributes givenName and facsimiletelephonenumber are analyzed.

`c:\radiantone\vds\bin\advanced>ldif-utils.bat AttrUniqueness -f c:\globaldirectory.ldif -u givenname,facsimiletelephonenumber`

If the utility returns the result, “Attribute Uniqueness check result false”, entries sharing the same value for at least one analyzed attribute were detected. In this example, the utility returns the following at the end of completion of the command.

`Checking attribute uniqueness...`
<br> `Attribute Uniqueness check result false. Entries with duplicates:`
<br> `uid=bgreene,ou=users,o=globaldirectory`
<br> `uid=cbaldwin,ou=users,o=globaldirectory`
<br> `uid=fhostetler,ou=users,o=globaldirectory`
<br> `uid=jhiggins,ou=users,o=globaldirectory`
<br> `uid=kchung,ou=users,o=globaldirectory`
<br> `uid=mhue,ou=users,o=globaldirectory`
<br> `uid=mpoole,ou=users,o=globaldirectory`
<br> `uid=owright,ou=users,o=globaldirectory`
<br> `uid=ytanaka,ou=users,o=globaldirectory`
<br> `Done in 12ms`
