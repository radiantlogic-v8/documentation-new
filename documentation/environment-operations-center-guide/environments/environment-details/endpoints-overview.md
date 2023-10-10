---
keywords:
title: Enable/Disable Endpoints in an Environment from its Detailed View
description: Learn how to enable/disable endpoints of environments in Environment Operations Center.
---


# Endpoints

There are three major endpoints provided through EOC and can be disbaled / enabled as required

![image description](images/endpoints.png)

> [!note]Enabling/Disabling endpoints should be done one endpoint at a time.

## Control Panel

The **CONTROL PANEL** endpoints provides access to the Main Control Panel of FID and is enabled by default after the environment is created.

![image description](images/cp-endpoint.png)

The URL can be clicked directly and new window opens with control panel sign in page or the URL can be copy pasted into a browser

![image description](images/cp-login-page.png)



## LDAPS

The **LDAPS** endpoint provides access to the fid through LDAPS protocol
The LDAPS is disabled by default, and can be enabled by using toggle button.

![image description](images/ldaps.png)

When the endpoint is enabled, the toggle turns green and a message appears on the **Environment Details** panel thats says **Enabling environment LDAPS endpoint**


![image description](images/enable-ldaps.png)

The endpoint enabling process takes about 5-10 minutes for an endpoint to be successfully enabled


![image description](images/enable-ldaps-confirmation.png)


### Disabling LDAPS

To disable the LDAPS endpoint, toggle the LDAPS endpoint (which is green)

A message appears on the Environment Details Panel that says **Deleting environment LDAPS endpoint**

![image description](images/delete-ldaps.png)

## REST

The **REST** endpoint provides API access to the fid.
The REST endpoint is disabled by default, and can be enabled by using toggle button.

![image description](images/rest.png)

When the endpoint is enabled, the toggle turns green and a message appears on the **Environment Details** panel thats says **Enabling environment REST endpoint**

![image description](images/enable-rest.png)

The endpoint enabling process takes about 5-10 minutes for an endpoint to be successfully enabled

![image description](images/enable-rest-confirmation.png)

### Disabling REST

To disable the REST endpoint, toggle the LDAPS endpoint (which is green)

A message appears on the Environment Details Panel that says **Deleting environment REST endpoint**

![image description](images/delete-rest.png)

> If the status of the endpoint does not change and the enabling message still sppears, refresh the envrionments page.
