# Configuring an OIDC Provider in the RadiantOne Control Panel

This guide walks a Control Panel administrator through connecting an external identity provider (IdP) — such as Google, Microsoft, Okta, or Salesforce — to the RadiantOne Control Panel using OpenID Connect (OIDC), so administrators can sign in through that provider instead of (or in addition to) local Control Panel credentials.

## Who this is for

You'll need Control Panel administrator access. You should also have — or be able to get from your identity provider's admin console — a **client ID** and **client secret** for an OIDC application registered with that provider. If you haven't registered the Control Panel as an application with your IdP yet, do that first; the steps below tell you exactly what redirect URI to give it.

## Before you start: register the Control Panel as an application with your IdP

Every OIDC provider requires you to register a client application before it will issue a client ID and secret. In your IdP's admin console, create a new OIDC/OAuth application and configure it to use the **Authorization Code Flow with PKCE**. When prompted for a redirect (or callback) URI, you'll need the value from Step 2 below — so it's fine to open the Control Panel form first, copy that value, register the application with your IdP, and then come back and finish the form.

## Step 1: Open OIDC Provider Configurations

1. Log in to the Control Panel and go to **Administration > Control Panel Configuration**.
2. Expand the **OIDC Provider Configurations** section. Any existing configurations are listed here, showing their configuration name, provider, discovery URL, and status (Active/Inactive).
3. Click **+ Add OIDC Configuration** to create a new one, or click an existing configuration's name to edit it. Each row also has a **Delete** (trash) icon.

![OIDC Provider Configurations list under Control Panel Configuration](oidc-01-config-list.jpg)

This opens the **OpenID Connect Provider** form.

## Step 2: Copy the redirect URI and register it with your IdP

Near the top of the form, under **Redirect URI (Required by Identity Provider)**, the Control Panel shows a fixed, read-only URL in the form `https://<your-control-panel-host>/callback`. Click **Copy** to copy it.

This is the callback address your identity provider will redirect back to after a user signs in — it's used during the OIDC Authorization Code Flow with PKCE. Paste it into your IdP's application settings, wherever it asks for an "allowed redirect URI" / "callback URL" / "sign-in redirect URI." **The sign-in will fail if this value isn't registered exactly as shown**, so don't paraphrase it or drop the trailing path.

![Redirect URI field with Copy button, and Enabled toggle and Configuration Name field above the form](oidc-02-redirect-uri.jpg)

## Step 3: Name the configuration and pick a provider

1. **Configuration Name** (required) — a short internal label for this configuration, e.g. `okta-employees` or `google-workspace`. This is how it'll appear in the OIDC Provider Configurations list, so make it descriptive if you expect to configure more than one provider.
2. **OIDC Provider** — choose from the dropdown:
   - **Google**, **Apple**, **Microsoft**, or **Salesforce** — picking one of these automatically fills in the **Discovery URL** with that provider's standard `.well-known/openid-configuration` address.
   - **Custom** (default) — for any other provider (Okta, Auth0, Ping, Azure AD/Entra ID, your own IdP, etc.). Enter that provider's discovery URL yourself, or leave it blank and fill in the authorization and token endpoints manually.
3. Leave **Enabled** off for now if you want to finish testing before this configuration goes live; toggle it on when you're ready for users to be able to sign in with it.

![OIDC Provider dropdown open, showing Google, Apple, Microsoft, Salesforce, and Custom](oidc-03-provider-dropdown.jpg)

## Step 4: Populate the endpoints

You have two options:

**Option A — Discovery (recommended when your provider supports it):**
1. Enter the provider's discovery URL in **Discovery URL** (already filled in if you picked Google/Apple/Microsoft/Salesforce in Step 3). This is normally something ending in `/.well-known/openid-configuration`.
2. Click **Discover Endpoint URLs**. The Control Panel fetches that document and automatically fills in **Authorization Endpoint URL** and **Token Endpoint URL** for you.

**Option B — Manual entry:**
Enter **Authorization Endpoint URL** and **Token Endpoint URL** yourself, copying them from your IdP's application/OIDC documentation. Both are required whether or not you use discovery — discovery is just a shortcut for filling them in.

![Discovery URL field with Discover Endpoint URLs button, and the Authorization and Token Endpoint URL fields populated](oidc-04-endpoints-discovery.jpg)

## Step 5: Enter the client credentials

1. **Client ID** (required) — the client ID your IdP issued when you registered the Control Panel as an application.
2. **Client Secret** — click **Edit** next to the field (it shows `- None -` until set) and paste in the client secret your IdP issued. Once saved, the field displays as masked dots; you'll need to click **Edit** again to replace it (it isn't shown again in plain text).
3. **Client Authentication Method** — how the Control Panel presents the client ID/secret to the token endpoint:
   - **CLIENT_SECRET_POST** (default) — sends credentials in the POST body.
   - **CLIENT_SECRET_BASIC** — sends credentials via HTTP Basic Auth.
   
   Check your IdP's application settings for which one it expects; most providers support either, but some default to one specifically.

![Client ID, Client Secret (with Edit button), and Client Authentication Method fields](oidc-05-client-credentials.jpg)

## Step 6: Choose request scopes

Under **Request Scopes**, `openid` is included by default and can't usefully be removed (it's what makes this an OIDC login rather than plain OAuth). Use the **- Select request scope -** dropdown and **Add Scope** to add more, typically:
- `email` — to receive the user's email address as a claim.
- `profile` — to receive name and other basic profile claims.

Add whatever additional scopes your IdP requires to release the claims you plan to use in Step 7 — check your provider's documentation, since available scopes vary by provider.

![Request Scopes chips (openid, email, profile) with the Select request scope dropdown and Add Scope button](oidc-06-request-scopes.jpg)

## Step 7: Map claims to a directory user (Claims to User DN Mapping)

This is the step that tells RadiantOne *which existing directory entry* a signed-in user corresponds to. When someone signs in via this provider, RadiantOne evaluates this mapping against the claims in their ID token and expects it to resolve to exactly one existing user entry in your RadiantOne namespace — it does not create new entries.

Click **+ Add Mapping** to open the **DN Mapping Expression Builder**. You have two ways to build the expression:

- **Simple DN Mapping** — a direct DN with claim values substituted in. Use this when a claim maps predictably into a fixed DN pattern. For example:
  - `cn=${name},ou=globalusers,cn=config`
  - `uid=${email},ou=${organization_id},ou=users`
- **Advanced DN Mapping** — an LDAP search expression (base DN, attributes, scope, and filter, separated by `?`), for when the match needs a search rather than a fixed DN pattern. For example:
  - `dc=mydomain??sub?(&(mail=${email})(sn=${family_name}))`

In either mode, type `$` in the **Expression** field to insert a claim — a filtered list of available claims (based on the scopes you added in Step 6) appears as you type the claim name. The green checkmark next to the expression field confirms it's syntactically valid. Click **Save** in the builder once the expression is ready.

![DN Mapping Expression Builder modal, Simple DN Mapping tab, with a validated expression example](oidc-07-dn-mapping-builder.jpg)

You can add more than one mapping expression if you need to match users under different conditions; the Control Panel evaluates them to resolve the signed-in user.

> For the full expression syntax reference, use the **Expressions in RadiantOne** link inside either the Simple or Advanced info tooltip (the small "i" icon next to each tab) in the mapping builder.

## Step 8: Save

Click **Save** at the bottom of the form. Required fields — **Configuration Name**, **Authorization Endpoint URL**, **Token Endpoint URL**, and **Client ID** — are validated immediately; any that are missing are outlined in red with a "Required" message underneath. Fix those and click **Save** again.

![Form showing red "Required" validation messages under empty Configuration Name, Authorization Endpoint URL, Token Endpoint URL, and Client ID fields](oidc-08-required-field-errors.jpg)

If you click **Cancel** with unsaved edits, the Control Panel asks **"Are you sure you want to leave?"** with **Discard** and **Keep Changes** options — choose **Discard** to leave without saving, or **Keep Changes** to go back and finish.

## Testing the configuration

1. Make sure **Enabled** is switched on and the configuration is saved.
2. Open the Control Panel sign-in page in a new browser session (or a private/incognito window) and confirm the new provider appears as a sign-in option.
3. Sign in and confirm you land back in the Control Panel as the expected user. If sign-in fails, see Troubleshooting below.

## Troubleshooting

![Error toast: "Failed to retrieve scopes and claims from the provided OIDC Discovery URL. Please verify the URL is correct and accessible."](oidc-09-discovery-error-toast.jpg)

| Symptom | Likely cause |
|---|---|
| "Failed to retrieve scopes and claims from the provided OIDC Discovery URL. Please verify the URL is correct and accessible." | The discovery URL is wrong, or the Control Panel can't reach it over the network (firewall/DNS). Re-check the URL and that it's reachable from the Control Panel server, not just your browser. |
| **Required** errors on Save | Configuration Name, Authorization Endpoint URL, Token Endpoint URL, or Client ID is empty. Discovery URL itself is optional — it's only a shortcut for filling in the two endpoint URLs. |
| IdP rejects the sign-in redirect / "invalid redirect URI" | The redirect URI registered with your IdP doesn't exactly match the one shown in Step 2. Re-copy it and update the IdP application. |
| User authenticates with the IdP but sign-in still fails in RadiantOne | The DN mapping expression (Step 7) didn't resolve to exactly one existing directory entry. Confirm the claim used in the expression is actually being released (check your scopes in Step 6) and that a matching user entry exists in the namespace. |
| Client authentication fails at the token endpoint | Client Authentication Method (Step 5) doesn't match what your IdP expects — try switching between CLIENT_SECRET_POST and CLIENT_SECRET_BASIC. |

## Editing or removing a configuration later

Return to **Administration > Control Panel Configuration > OIDC Provider Configurations** and click the configuration's name to reopen this same form with its current values loaded (the client secret shows masked; click **Edit** to replace it).

- To temporarily stop a provider from being offered at sign-in **without deleting it**, open it, switch **Enabled** off, and save. This is the safer option if you're not sure you want it gone for good.
- To remove it permanently, click the **Delete** (trash) icon at the end of its row in the OIDC Provider Configurations list. Make sure you have the right row selected before confirming — this can't be undone, and you'd need your IdP's client ID/secret again to recreate it.

---

*This guide reflects the OIDC Provider Configuration form as of August 2026. Field labels or available providers may change in future releases — if something on screen doesn't match this guide, the on-screen labels and tooltips are the source of truth.*
