---
title: Web Services API Guide
description: Web Services API Guide
---

# DSML

Directory Service Markup Language (DSML) is an open, extensible format that allows directories to exchange information across directory server types. RadiantOne support for DSML version 2.0 allows directory contents to be accessed, modified, and controlled through XML (eXtensible Markup Language), a more flexible language than HTML that allows customized markup languages to be created for different uses. 

As a Web services protocol, DSML closely mirrors Lightweight Directory Access Protocol (LDAP). DSML is designed to allow arbitrary Web services clients to access directory services using the client's native protocols (http://soap), which allows content stored in a directory service to be easily accessed by standard Web service applications and development tools. DSML is useful in Web applications because it can access directories when a firewall would normally screen out an LDAP request.

Simple Object Access Protocol (SOAP) is an XML-based protocol used in combination with Hypertext Transfer Protocol (HTTP) to access information in a distributed database. DSMLv2 uses SOAP to bind to a Directory Server over the Web in such a way those LDAP directories, such as the RadiantOne service, can be rendered in XML.

This service is available from any DSML client on the context /dsml.  The authentication is performed with the bind information given in the HTTP header.

A WSDL is also available on /dsml?wsdl (see [WSDL for RadiantOne DSML Web Service](#wsdl-for-radiantone-dsml-web-service) section below). It can be used when building a web service client from any generation tool. 

Primary benefits of DSML are:
-	LDAP client not required to access the directory.

-	LDAP operations can easily pass through firewalls.

-	LDAP operations can be batched and executed in a single request.

## WSDL for RadiantOne DSML Web Service

The WSDL file for the RadiantOne DSML web service can be retrieved by either clicking on the wsdl link from the welcome page, or by accessing the following URL:

http[s]://host[:port]/dsml?wsdl

```
e.g. http://localhost:8089/dsml?wsdl
```
