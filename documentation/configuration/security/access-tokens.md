---
title: Access Tokens
description: Learn how to create access tokens.
---

## Overview
Access tokens are used to authorize requests to a RadiantOne API. A token is issued for a specific API which can be the Configuration API to manage the RadiantOne service or one of the APIs used to manage the data accessible in the RadiantOne platform. Data management supported are SCIMv2 or the native RESTful Web Service once known as ADAP. Access tokens are secrets and should be treated like passwords. 

Access tokens have a validity period that is specified when they are generated. are valid for 30 days and automatically renew every time they're used with an API request. When a token has been inactive for more than 30 days, it's revoked and can't be used again.

## Configuration API



## SCIMv2 API
## REST API
