---
title: Access Tokens
description: Learn how to create access tokens.
---

## Overview
Access tokens are used to authorize requests to a RadiantOne API. A token is issued for a specific API which can be the Configuration API to manage the RadiantOne service or one of the APIs used to manage the data accessible in the RadiantOne platform. Data management APIs supported are SCIMv2 or the native RESTful Web Service once known as ADAP. Access tokens are secrets and should be treated like passwords. 

Access tokens have a validity period that is specified when they are generated. The expiration can be indicated with a specific calendar date, or based on a specific number of days from the time it is generated. Expired tokens can't be used again.

## Configuration API
To configure an access token for calling the RadiantOne configuration API:
1. Navigate to Control Panel > Admin > ACCESS TOKENS tab.
2. Click **+ GENERATE ACCESS TOKEN**.
3. Enter a token name.
4. Select *Configuration API* from the drop-down list.
5. Choose a (delegated admin) role to associate with the token. This role will dictate the settings the token is allowed to configure.
6. Define the token expiration as either a specifc number of days (e.g. 60, 90, 180, 365), or select a specific date that it should expire.
7. Click **CREATE**.

![Access Token for Configuration API](Media/config-api-token.jpg)

## SCIMv2 API
To configure an access token for calling the RadiantOne SCIMv2 API:
1. Navigate to Control Panel > Admin > ACCESS TOKENS tab.
2. Click **+ GENERATE ACCESS TOKEN**.
3. Enter a token name.
4. Select *SCIM API* from the drop-down list.
5. Define the token expiration as either a specifc number of days (e.g. 60, 90, 180, 365), or select a specific date that it should expire.
6. Click **CREATE**.

![Access Token for SCIMv2 API](Media/scim-api-token.jpg)

## REST API
To configure an access token for calling the RadiantOne REST API:
1. Navigate to Control Panel > Admin > ACCESS TOKENS tab.
2. Click **+ GENERATE ACCESS TOKEN**.
3. Enter a token name.
4. Select *REST API* from the drop-down list.
5. Define the token expiration as either a specifc number of days (e.g. 60, 90, 180, 365), or select a specific date that it should expire.
6. Click **CREATE**.

![Access Token for REST API](Media/rest-api-token.jpg)

The RadiantOne REST API also supports OIDC tokens that can be validated with an [External Token Validator](./external-token-validators). 

## Using an Access Token

