---
title: configure-persistent-cache
description: configure-persistent-cache
---
         
# Configure Persistent Cache

Prior to using FID as an identity source in your Global Identity, configure and initialize a persistent cache for your virtual view(s).

1. Select the **Main Control Panel** > **Directory Namespace** tab.

2. Select **Cache**.

3. Select **Browse** to navigate to the naming context you want to cache.

4. Select **Create Persistent Cache**.

5. On the Refresh Settings tab, choose the type of cache refresh strategy you want to use. For details on the different refresh options and how to initialize the cache, see the RadiantOne Deployment and Tuning Guide.

6. After the persistent cache is configured, choose the cached branch below **Cache** and on the **Refresh Settings** tab, select **Initialize**.

7. If you selected a Real-time refresh strategy, configure the connectors accordingly and start them. For details, see the Connector Properties Guide and the Deployment and Tuning Guide. If you selected a periodic cache refresh approach, configure the refresh interval. For details, see the Deployment and Tuning Guide.
