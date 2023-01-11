---
title: Create a Global Identity Builder project
description: Create a Global Identity Builder project
---

# Create a Global Identity Builder project

Each Global Identity Builder project builds a unique reference list of identities from disparate data sources. Overlapping identities are linked based on correlation rules and the entries are joined into a global profile. If there are no overlapping users, the global profile is a complete, aggregated list of unique identities. Clients of the RadiantOne service can leverage the global profile view to identify and authenticate users and retrieve profile attributes to enforce authorization and personalization.

>[!warning]
>It is highly recommended that you use the RadiantOne Identity Data Analysis tool prior to configuring your project. The Identity Data Analysis tool provides valuable insights into the quality of your identity data and identifies potential correlation attributes. For more information on data analysis, see the RadiantOne Data Analysis Guide.

When you first launch the Global Identity Builder tool, there are no projects defined, so you are presented with a welcome page.

1. Select **Get Started!**.

>[!note]
>If you have already created projects, they are accessible on this page. To create a new project, select **New Project**.

2. Define the [project properties](project-properties.md) and select **Save Changes**.
3. Add [identity sources](identity-sources.md) to your project and select **Save Changes**.
4. Select [Upload/Sync](upload.md) to upload identities into the global profile.

After a project has been created, common issues may arise that require manual interventions to resolve. These interventions are described in the following sections:

- [Manually link](../identity-administration.md) any unresolved identities.
- Fix any [login conflicts](../identity-administration.md#login-conflict-analysis) that were found.

Additionally, after initial creation, the project must be maintained to be kept up to date. This maintenance can be managed with [real-time persistent cache refresh](../manage-persistent-cache/overview.md) which keeps your identity sources synchronized with the global profile.
