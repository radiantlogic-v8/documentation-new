---
title: persistent-cache
description: persistent-cache
---
         
# Persistent Cache

After uploading identity sources into the global profile, a persistent cache is automatically defined for the view. Persistent cache is a local copy of global profile stored in a RadiantOne HDAP store. Although the Global Identity Builder process automatically defines a persistent cache, a real-time cache refresh mechanism must be manually configured. The persistent cache refresh is the process that keeps the identity sources synchronized to the global profile store. Changes are synchronized one-way, from the identity sources to the global profile. Once the real-time persistent cache refresh process is running, no changes can be made to the project. If changes are needed, you must stop cache refresh. For details on configuring a real-time persistent cache refresh process, see the chapter [Persistent Cache with Real-Time Refresh](#persistent-cache-with-real-time-refresh).

>[!important]
>Real-time cache refresh is the only option available for the global profile view.
