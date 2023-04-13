---
title: Architect Guide
description: Get a quick introduction to using persistent cache to offer a guaranteed level of search performance for the RadiantOne service. The persistent caching feature offers a variety of refresh mechanisms, periodic (time-based) or near real-time (event-driven), to detect changes and automatically update the cache image.
---

# Performance

In addition to being able to quickly add another node to a cluster (to increase throughput), RadiantOne provides persistent caching that enable it to respond to operations quickly. 

With a persistent cache, the virtual entries are stored in the local RadiantOne Universal Directory. This approach doesn't make the cache dependent on memory size anymore and allows for fast recovery in case of failure. The whole virtual view could be cached and a large volume of entries can be supported (hundreds of millions of entries - essentially no practical limit if combined with partitioning/sharding and clusters). The persistent cache provides performance levels comparable to the fastest “traditional” LDAP directory and even better performance when it comes to modify operations.

Advantages

- The RadiantOne service can consistently offer a guaranteed level of performance even after failure/restart of the server (no memory to “prime”).
- Easy to know what information is in cache and what is not.
- Only delta changes trigger cache refreshes which eliminates the need for a random time-to-live interval that could generate unnecessary cache refreshes.

**Disadvantages**

- Initial import of all entries into the persistent cache store is required. Depending on the size of the data set, the initial import could take some time.

**Refresh Mechanisms**

There are three refresh mechanisms available for persistent caching.

- Automatic refresh for changes flowing through the RadiantOne service.
- Periodic refresh
- Real-time cache refresh

**Automatic refresh for changes flowing through RadiantOne** – after setting up a persistent cache, if the RadiantOne service receives a modification request, it sends the request to the appropriate underlying source(s) and if the modification is successful, the RadiantOne service automatically refreshes the persistent cache with the change.

**Periodic refresh** – A refresh of the persistent cache can be scheduled on a time-based interval (e.g. every 4 hours) or at specific defined times (e.g. 1:00 AM, 4:00 AM).

**Real-time cache refresh** – if the data in the underlying data sources changes frequently, there is an option of a real-time cache refresh. This option would involve connectors, which are components that pick-up changes that happen on the underlying sources and push them to update the cache image. Below is a high-level diagram of the components and details involved.

![Real Time Cache Refresh](Media/Image6.9.jpg)

Figure 9: Real Time Cache Refresh

## Related Material

- RadiantOne Deployment and Tuning Guide.
