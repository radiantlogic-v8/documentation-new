---
title: External Token Validators
description: Learn how to manage external token validators.
---

## Overview

RadiantOne supports OAuth 2.0 / OpenID Connect (OIDC) token-based authentication for both the **REST (ADAP) API** and the **SCIM v2 API**. With this model, clients authenticate with an external authorization server (such as Okta) and use the resulting access token to authenticate API requests to RadiantOne.

This approach improves security by ensuring that user credentials are never sent to RadiantOne or the application. A single access token can be reused for multiple requests until it expires.

**Supported API Services:**

| API Service | Description |
| --- | --- |
| REST (ADAP) | Validates external JWTs for ADAP REST API calls |
| SCIM | Validates external JWTs for SCIM v2 endpoint calls *(new in v8.5.0)* |

A high-level diagram of the different components for a REST API call is shown below. Postman is used as a simple client to illustrate the flow. A similar approach applies to SCIM APIs as well.

![High-level architecture: Postman authenticates against the OIDC provider, gets a token, passes it in the header to ADAP, which validates the token and issues requests to the RadiantOne Platform](images/01-architecture-overview.jpg)

In this architecture, you need to follow these high-level steps:

1. Configure an external OIDC authorization server (such as Okta) to issue access tokens.
2. Configure RadiantOne to trust that authorization server using a Token Validator. This document covers additional details about setting up the Token Validator in the later sections.
3. Obtain the access token directly from the authorization server.
4. Call the RadiantOne REST (ADAP) API or SCIM v2 API, presenting the token.
5. RadiantOne validates the token at request time and maps it to a directory identity.

## Prerequisites

Before you begin configuring the token validator, ensure you have the following:

- Configured an OIDC authorization server (e.g., Okta)
- Client ID and Client Secret
- OIDC Discovery URL
- Expected audience and required scopes
- **For SCIM validators:** A SCIM v2 resource type must be configured in RadiantOne Identity Data Management via **Control Panel → Client Protocols → SCIM → Resource Types**.

![SCIM Resource Types page in the Control Panel, used to create a SCIM resource type by defining object and attribute mappings between LDAP and SCIM](images/02-scim-resource-types.png)

## RadiantOne Configuration

This section describes configuring proxy authorization, configuring an external token validator (ADAP or SCIM), and Claims to FID User Mapping.

### Configure Proxy Authorization

The RadiantOne REST (ADAP) service and SCIM v2 service query the RadiantOne LDAP service using proxy authorization.

To configure proxy authorization:

1. Navigate to **Control Panel > Global Settings > Client Protocols > LDAP**.
2. Enable **Proxy Authorization** and click **SAVE**.
3. Navigate to **Control Panel > Security > Access Controls > General**.
4. Enable the **"ALLOW DIRECTORY MANAGER TO IMPERSONATE OTHER USERS"** option and click **SAVE**.

> **Important:** Proxy Authorization must be enabled for SCIM external token validation to work. If it is disabled, SCIM requests authenticated via external JWT will be rejected with: *"ProxyAuthorizationControl is not enabled in VDS."*

## Token Validators

With Token Validators, administrators can configure and manage trusted external token sources to ensure that only valid, verified tokens are accepted for API authentication of both ADAP and SCIM endpoints.

### Adding a Token Validator

1. Navigate to **Global Settings > Token Validators**.
2. Click **"Add Token Validator"**. This opens the configuration form.
3. Fill out all required fields:

![Create Token Validator form showing Name, Status, OIDC Provider, OIDC Discovery URL, JSON Web Key Set (JWKS) URL, Scope Claim Name, Expected Audience, Expected Scope, JSON Web Token Validation Clock Offset, API Service, and Claims to User DN Mapping fields](images/03-create-token-validator.png)

**a. Name** — A unique name for your validator. Must match the pattern `^[a-zA-Z0-9\s_-]+$` and be 100 characters or fewer.

> **Note:** Names must be globally unique across both REST (ADAP) and SCIM validators. Attempting to create a validator with a name that already exists (regardless of API service type) will be rejected with: *"Cannot create new External Token Validator with existing name: &lt;name&gt;"*

**b. Status** — By default, new validators are **ENABLED**. You can toggle the status to **DISABLED** if needed. Disabled validators are skipped during authentication.

**c. OIDC Provider** — Select a preset provider or choose *Custom*.

**d. OIDC Discovery URL** — The OpenID Connect Discovery endpoint for your authorization server (e.g., `https://<your-domain>.okta.com/oauth2/<server-id>/.well-known/oauth-authorization-server`). Click **DISCOVER** to auto-populate the JWKS URL.

**e. JSON Web Key Set (JWKS) URL** — The endpoint where the public keys for token validation are published. Use the **Discover** button to auto-populate this field from the OIDC Discovery URL.

**f. Scope Claim Name** — The name of the claim in the JWT that contains the scopes. The default value is `scope`. Some OIDC providers use different claim names (e.g., Okta uses `scp` for tokens issued via the client credentials flow). Set this value to match the claim name used by your authorization server.

**g. Expected Audience** — The audience value your tokens must contain. If the `aud` claim in the JWT does not match this value, authentication is rejected. Leave this field empty to skip audience validation.

**h. Expected Scope** — The required scope(s) for access. You can specify a single scope or multiple scopes.

   - To specify multiple scopes, separate them with a comma and a space (e.g., `testscp1, testscp2`) or with a space only (e.g., `testscp1 testscp2`).
   - All specified scopes must be present in the token for validation to succeed. If any expected scope is not found in the token, authentication is rejected with a `400` error.

**i. JSON Web Token Validation Clock Offset (seconds)** — Adjusts for clock skew between systems. Valid range: 0–3600 seconds.

**j. API Service** *(new in v8.5.0)* — Select the target API service for this validator:

   - **REST (ADAP)** — The validator applies to ADAP REST API requests only.
   - **SCIM** — The validator applies to SCIM v2 API requests only.

> **Important:** A validator configured for REST (ADAP) will **not** authorize SCIM requests, and vice versa. Each service type only consults its own validators.

**k. Claims to User DN Mapping** — Click **ADD MAPPING** to define one or more DN mapping expressions that resolve JWT claims to a user distinguished name in RadiantOne.

It defines how RadiantOne converts information in a JWT (such as email or username claims) into the Distinguished Name (DN) of a user in its directory.

Example: `ou=People,o=company??one?(mail=${aud})` maps the token's `aud` claim to a user's `mail` attribute.

4. Click **Save** to create the validator.

The Token Validators list in the Control Panel displays all validators with the following columns:

| Column | Description |
| --- | --- |
| NAME | The validator's unique name |
| JSON WEB KEY SET (JWKS) URL | The configured JWKS endpoint |
| API SERVICE | Either **REST (ADAP)** or **SCIM** |
| STATUS | Enabled or Disabled |

![Token Validators list in the Control Panel showing validators with their JWKS URLs, API service type, and enabled status](images/04-token-validators-list.png)

### Switching a Validator Between API Service Types

You can change an existing validator's API Service type (REST ↔ SCIM) by editing it:

1. Navigate to **Global Settings > Token Validators**.
2. Select the validator you want to modify.
3. Change the **API Service** dropdown to the desired type.
4. Click **Save**.

The validator will be removed from its previous service list and placed in the new one. For example, switching from REST (ADAP) to SCIM means the ADAP runtime will no longer use that validator, and the SCIM runtime will begin using it.

### JSON Array Claims Support

The External Token Validator supports JWT claims whose values are JSON arrays. This is particularly relevant for OIDC providers (such as Okta) that represent scopes or other multi-valued claims as arrays rather than space-delimited strings.

For example, a token issued by Okta using the client credentials flow may contain scopes in the following format:

```json
{
  "scp": [
    "testscp1",
    "testscp2",
    "testscp3"
  ],
  "aud": "http://example.com:8089/adap",
  "sub": "0oa100lhmsfPSMDYP698"
}
```

When configuring the Token Validator for tokens with JSON array claims:

- Set the **Scope Claim Name** to the array claim name used by your provider (e.g., `scp` for Okta).
- Specify one or more values in the **Expected Scope** field. The validator automatically parses the JSON array and checks that all expected values are present.
- No additional configuration is needed. The validator detects whether the claim value is a JSON array or a plain string and handles both formats.

## Querying RadiantOne REST API (ADAP)

### 1. Obtain an Access Token

Here's an example request where Okta is the OIDC.

```bash
curl --request POST \
--url "https://project-1234567.okta.com.okta.com/oauth2/default/v1/token" \
--header "Accept: application/json" \
--header "Content-Type: application/x-www-form-urlencoded" \
--data "grant_type=client_credentials&client_id=<your client id>&client_secret=<your client secret> &scope=customadap"
```

### 2. Use the access token as a bearer token

In this example, Postman is used to include the access token in the Authorization header as a bearer token.

![Postman Headers tab showing the Authorization header set to a Bearer token value](images/05-postman-auth-header.jpg)

### 3. Make the API request

In this example, a basic search is performed.

| Field | Value |
| --- | --- |
| URL Syntax | `http://<host>:8089/adap/` |
| Method | Get |
| Header Name | Authorization |
| Header Value | Bearer |
| Example URL | `http://localhost:8089/adap/o=companydirectory` |

If successful, the operation displays a response body similar to the following.

![Postman response body showing a 200 OK JSON result with a resources array containing directory entries and their attributes](images/06-postman-response-body.jpg)

## Querying RadiantOne SCIM v2 API with an External Token *(new in v8.5.0)*

Once you have configured a SCIM external token validator, you can authenticate SCIM v2 requests using a Bearer token from your OIDC provider.

### 1. Obtain an Access Token

Request an access token from your OIDC provider. Example using Okta:

```bash
curl --request POST \
  --url "https://<your-domain>.okta.com/oauth2/<server-id>/v1/token" \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --header "Authorization: Basic <base64(clientId:clientSecret)>" \
  --data "grant_type=client_credentials&scope=<expected-scope>&aud=<expected-audience>"
```

Ensure the `scope` and `aud` parameters match the values configured in your SCIM token validator.

### 2. Call the SCIM v2 Endpoint

Use the access token as a Bearer token in the Authorization header:

```bash
curl --request GET \
  --url "http://<radiantone-host>:8089/scim2/v2/Users" \
  --header "Authorization: Bearer <access_token>"
```

When a SCIM request is made with an external JWT:

1. RadiantOne validates the token against all **enabled** SCIM validators (tried in order; any one accepting is sufficient).
2. The **Claims to User DN Mapping** resolves the token's claims to a local RadiantOne user DN.
3. The SCIM operation executes using **proxied authorization** so that the request runs with the mapped user's identity and ACLs.

> **Important:** If Proxy Authorization is disabled, requests will be rejected with: *"ProxyAuthorizationControl is not enabled in VDS."*

## Token Lifetime

By default the token lifetime is set to 10 hours. To configure the token timeout:

1. Go to **Classic Control Panel > Settings tab > Server Front End > Other Protocols** section.
2. In the REST/ADAP section (requires Expert Mode), edit the value in the **Token Timeout** field.
3. Click **Save**.
4. Restart the RadiantOne service from the Environment Operations Center. Navigate to **Environments > &lt;Environment_Name&gt; > Overview** tab and restart the Identity Data Management service. This performs a rolling restart and all nodes are restarted.

When an expired or unrecognized token is used, the response displays the message *"Authentication failed: Unknown token"*.

  

