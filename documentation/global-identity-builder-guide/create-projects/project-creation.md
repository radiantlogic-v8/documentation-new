# Project Creation

Each Global Identity Builder project builds a unique reference list of identities from disparate data sources. Overlapping identities are linked based on correlation rules and the entries are joined into a global profile. If there are no overlapping users, the global profile is a complete, aggregated list of unique identities. Clients of the RadiantOne service can leverage the global profile view to identify and authenticate users and retrieve profile attributes to enforce authorization and personalization.

>[!important]
>It is highly recommended that you use the RadiantOne Identity Data Analysis tool prior to configuring your project. The Identity Data Analysis tool provides valuable insights into the quality of your identity data and identifies potential correlation attributes. For more information on data analysis, see the RadiantOne Data Analysis Guide.

When you first launch the Global Identity Builder tool, there are no projects defined, so you are presented with a welcome page.

1. Select **Get Started!**.

>[!note]
>If you have already created projects, they are accessible on this page. To create a new project, select **New Project**.

1. Define the [project properties](#project-properties) and select **Save Changes**.

2. Add [Identity Sources](#identity-sources) to your project and select **Save Changes**.

3. Select [**Upload/Sync**](#upload) to upload identities into the global profile.

4. [Manually link](#manual-identity-administration) any unresolved identities.

5. Fix any [login conflicts](#login-conflict-analysis) that were found.

6. Configure [real-time persistent cache refresh](#persistent-cache-with-real-time-refresh) to keep your identity sources synchronized with the global profile.
