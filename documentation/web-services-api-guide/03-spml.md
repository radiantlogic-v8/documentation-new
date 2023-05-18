---
title: Web Services API Guide
description: Web Services API Guide
---

# SPML

SPML is an XML-based provisioning request-and-response protocol. RadiantOne supports SPML v2 and plays the role of a Provisioning Service Provider (PSP) or provider and listens for, processes, and returns the results for well-formed SPML requests from a known requesting authority or requestor.

SPML Version 2 defines a core protocol over which different data models can be used to define the actual provisioning data. The combination of a data model with the SPML core specification is referred to as a profile. RadiantOne supports the DSML profile.

The following capabilities and operations (as defined in the SPML v2 specifications) are supported:

-	listTargets Operation - enables a requestor to determine the set of targets that the RadiantOne service makes available for provisioning and also enables a requestor to determine the set of capabilities that the provider supports for each target).

-	Batch Capability– enables a requestor to send multiple requests to be executed as a set. The batch capability supports batch operations.

-	Update Capability– this allows an SPML client to detect changes that happen in RadiantOne when the changelog has been enabled. This applies to local RadiantOne Universal Directory stores and local persistent cache branches only. In addition, only the updatesince timestamp attribute is supported in the request (query in the request is not currently supported). Timestamp must be in the following format xsd:dateTime (which is CCYY-MM-DDThh:mm:ss.sss). The updates capability supports the update, iterate and closeIterator operations. 

-	Add Operation – enables a requestor to create a new object on a target.

-	Delete Operation – enables a requestor to remove an object from a target. 

-	Modify Operation – enables a requestor to change an object on a target.

-	Bulk Capability – bulkModify and bulkDelete are supported.

-	Lookup Operation - enables a requestor to obtain the XML that represents an object on a target. This returns the XML for a single entry.

-	Search Capability – can return multiple entries based on a filter. The search capability supports the search, iterate and closeIterator operations.

This service is available for any SPML client on the context /spml. The authentication is performed with the bind information given in the HTTP header.

A WSDL is also available on /spml.wsdl (see WSDL for RadiantOne SPML Web Service section below). It can be used when building a web service client from any generation tool.

## WSDL for RadiantOne SPML Web Service

The WSDL file for the RadiantOne web service can be retrieved by accessing the following URL: 
http[s]://host[:port]/spml/spml.wsdl

```
e.g. http://localhost:8089/spml/spml.wsdl
```

## Sample Requests

The following are sample SPML Requests using SOAP.

### Batch Request Sample

```sh
<soapenv:Envelope xmlns:soapenv=   "http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:spmlbatch= "urn:oasis:names:tc:SPML:2:0:batch"
                  xmlns:spmlbulk=  "urn:oasis:names:tc:SPML:2:0:bulk"
                  xmlns:spmlsearch="urn:oasis:names:tc:SPML:2:0:search"
                  xmlns:spml=      "urn:oasis:names:tc:SPML:2:0"
                  xmlns:dsml=      "urn:oasis:names:tc:DSML:2:0:core">
  	 <soapenv:Header/>
  	 <soapenv:Body>
    	  <spmlbatch:batchRequest processing="sequential" onError="exit">
    	  <!--<spmlbatch:batchRequest requestID="ID0" onError="exit">-->

         <!-- Add Request -->
         <spml:addRequest requestID="ID1" targetID="VDS" returnData="everything">
            <spml:psoID ID="uid=gtest,ou=subtest,ou=test,o=spmlpsptest" targetID="VDS">
               <spml:containerID/>
            </spml:psoID>
            <spml:data>
               <dsml:attr name="objectclass">
                  <dsml:value>inetorgperson</dsml:value>
               </dsml:attr>
               <dsml:attr name="uid">
                  <dsml:value>gtest</dsml:value>
               </dsml:attr>
               <dsml:attr name="givenname">
                  <dsml:value>Gerry</dsml:value>
               </dsml:attr>
               <dsml:attr name="sn">
                  <dsml:value>Test</dsml:value>
               </dsml:attr>
               <dsml:attr name="cn">
                  <dsml:value>Gerry Test</dsml:value>
               </dsml:attr>
               <dsml:attr name="telephonenumber">
                  <dsml:value>123</dsml:value>
               </dsml:attr>
            </spml:data>
         </spml:addRequest>

         <!-- Add Request -->
         <spml:addRequest requestID="ID2" targetID="VDS" returnData="everything">
            <spml:psoID ID="uid=htest,ou=subtest,ou=test,o=spmlpsptest" targetID="VDS">
               <spml:containerID/>
            </spml:psoID>
            <spml:data>
               <dsml:attr name="objectclass">
                  <dsml:value>inetorgperson</dsml:value>
               </dsml:attr>
               <dsml:attr name="uid">
                  <dsml:value>htest</dsml:value>
               </dsml:attr>
               <dsml:attr name="givenname">
                  <dsml:value>Hans</dsml:value>
               </dsml:attr>
               <dsml:attr name="sn">
                  <dsml:value>Test</dsml:value>
               </dsml:attr>
               <dsml:attr name="cn">
                  <dsml:value>Hans Test</dsml:value>
               </dsml:attr>
               <dsml:attr name="telephonenumber">
                  <dsml:value>321</dsml:value>
               </dsml:attr>
            </spml:data>
         </spml:addRequest>

         <!-- BulkModify Request -->
         <spmlbulk:bulkModifyRequest requestID="ID20">
            <spmlsearch:query targetID="VDS" scope="oneLevel">
               <spmlsearch:basePsoID ID="ou=subtest,ou=test,o=spmlpsptest" targetID="VDS">
                  <spml:containerID/>
               </spmlsearch:basePsoID>
               <filter xmlns="urn:oasis:names:tc:DSML:2:0:core">
                  <and>
                     <equalityMatch name="objectclass">
                        <value>inetorgperson</value>
                     </equalityMatch>
                     <or>
                        <equalityMatch name="uid">
                          <value>gtest</value>
                        </equalityMatch>
                        <equalityMatch name="uid">
                          <value>htest</value>
                        </equalityMatch>
                     </or>
                  </and>
               </filter>
            </spmlsearch:query>
            <spmlbulk:modification>
               <modification name="telephonenumber" operation="replace" xmlns="urn:oasis:names:tc:DSML:2:0:core">
                  <value>(415) 209-6800</value>
               </modification>
            </spmlbulk:modification>
         </spmlbulk:bulkModifyRequest>

         <!-- BulkModify Request -->
<!--         <spmlbulk:bulkModifyRequest requestID="ID21">
            <spmlsearch:query targetID="VDS" scope="subTree">
               <spmlsearch:basePsoID ID="o=spmlpsptest" targetID="VDS">
                  <spml:containerID/>
               </spmlsearch:basePsoID>
               <filter xmlns="urn:oasis:names:tc:DSML:2:0:core">
                  <and>
                     <equalityMatch name="objectclass">
                        <value>person</value>
                     </equalityMatch>
                     <equalityMatch name="telephonenumber">
                       <value>(415) 209-6800</value>
                     </equalityMatch>
                  </and>
               </filter>
            </spmlsearch:query>
            <spmlbulk:modification>
               <modification name="sn" operation="replace" xmlns="urn:oasis:names:tc:DSML:2:0:core">
                  <value>Novato</value>
               </modification>
            </spmlbulk:modification>
         </spmlbulk:bulkModifyRequest>
-->
      </spmlbatch:batchRequest>
   </soapenv:Body>
</soapenv:Envelope>
```

### Add Request Sample

```sh
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:spml="urn:oasis:names:tc:SPML:2:0" xmlns:dsml="urn:oasis:names:tc:DSML:2:0:core">
   <soapenv:Header/>
   <soapenv:Body>
      <spml:addRequest requestID="0" targetID="VDS" returnData="everything">
         <spml:psoID ID="uid=ftest,ou=subtest,ou=test,o=spmlpsptest" targetID="VDS">
            <spml:containerID/>
         </spml:psoID>
         <spml:data>
            <dsml:attr name="objectclass">
               <dsml:value>inetorgperson</dsml:value>
            </dsml:attr>
            <dsml:attr name="uid">
               <dsml:value>ftest</dsml:value>
            </dsml:attr>
            <dsml:attr name="givenname">
               <dsml:value>Fred</dsml:value>
            </dsml:attr>
            <dsml:attr name="sn">
               <dsml:value>Test</dsml:value>
            </dsml:attr>
            <dsml:attr name="cn">
               <dsml:value>Fred Test</dsml:value>
            </dsml:attr>
         </spml:data>
      </spml:addRequest>
   </soapenv:Body>
</soapenv:Envelope>
```

### BulkModify Request Sample

```sh
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:oasis:names:tc:SPML:2:0:bulk" xmlns:urn1="urn:oasis:names:tc:SPML:2:0:search" xmlns:urn2="urn:oasis:names:tc:SPML:2:0" xmlns:spmldsml="urn:oasis:names:tc:SPML:2:0:DSML">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:bulkModifyRequest requestID="6">
         <urn1:query targetID="VDS" scope="subTree">
            <urn1:basePsoID ID="o=spmlpsptest" targetID="VDS">
               <urn2:containerID/>
            </urn1:basePsoID>
         </urn1:query>
         <urn:modification>
            <modification name="telephonenumber" operation="replace" xmlns="urn:oasis:names:tc:DSML:2:0:core">
               <value>111.333.4444</value>
            </modification>
         </urn:modification>
      </urn:bulkModifyRequest>
   </soapenv:Body>
</soapenv:Envelope>
```

### ListTargets Request Sample

```sh
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:oasis:names:tc:SPML:2:0">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:listTargetsRequest requestID="0">
         <!--You may enter ANY elements at this point-->
      </urn:listTargetsRequest>
   </soapenv:Body>
</soapenv:Envelope>
```

### Updates Request Sample

```sh
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:oasis:names:tc:SPML:2:0:updates" xmlns:urn1="urn:oasis:names:tc:SPML:2:0:search" xmlns:urn2="urn:oasis:names:tc:SPML:2:0">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:updatesRequest requestID="r1" executionMode="synchronous" updatedSince="20110216230000.000">
         <!--You may enter ANY elements at this point. The query sample below is commented out as it is not supported at this time-->
<!--         <urn1:query targetID="VDS" scope="subTree">
            <urn1:basePsoID ID="ou=spml,o=test" targetID="VDS">
               <urn2:containerID/>
            </urn1:basePsoID>
         </urn1:query>
-->
         <!--Zero or more repetitions:-->
<!--         <urn:updatedByCapability>?</urn:updatedByCapability>
-->
      </urn:updatesRequest>
   </soapenv:Body>
</soapenv:Envelope>
```

### Search Request Sample

```sh
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
<spmlsearch:searchRequest maxSelect="1" xmlns:spml="urn:oasis:names:tc:SPML:2:0" xmlns:spmlsearch="urn:oasis:names:tc:SPML:2:0:search" xmlns:dsml="urn:oasis:names:tc:DSML:2:0:core">
         <spmlsearch:query targetID="o=mycompany" scope="subLevel">
            <dsml:filter>
                                    <dsml:equalityMatch name="uid">
                                                <dsml:value>testuser1</dsml:value>
                                    </dsml:equalityMatch>             
                         </dsml:filter>
            <spmlsearch:basePsoID targetID="o=mycompany" ID="o=mycompany"/>
         </spmlsearch:query>
      </spmlsearch:searchRequest>
   </soap:Body>
</soap:Envelope>
```
