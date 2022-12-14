---
title: Deployment and Tuning Guide
description: Deployment and Tuning Guide
---

# Chapter 5: Testing RadiantOne Performance

The 3rd party SLAMD Distributed Load Generation Engine is the recommended utility to test the RadiantOne LDAP service performance. Apache JMeter can also be used.

If you are deploying a cluster architecture, a hardware load balancer should be used in front of your RadiantOne nodes. Then, the SLAMD client directs requests to the load balancer which distributes the requests across the nodes as configured. For AWS environments, you should generally pre-warm the Elastic Load Balancer (ELB) so that it has sufficient resources to handle your load test. You can contact AWS prior to your testing to ensure your ELB is provisioned with enough resources. Otherwise, the ELB could be a bottleneck until the resources are increased dynamically, which can take time.

If a single standalone RadiantOne node is deployed, the SLAMD client can point directly to this instance for testing performance.

If RadiantOne is used to virtualize an LDAP source, you should first determine the performance of the underlying LDAP server by accessing it directly (using SLAMD mentioned above).  This provides you with some base performance numbers. Then, run SLAMD against the RadiantOne service (on the branch built from the underlying LDAP source). You should keep in mind that the following additional configurations on your RadiantOne branch could impact performance:

-	Joins

-	Interception scripts

-	Cache

-	Referral Chasing (as a client, RadiantOne FID could chase referrals returned from the backends)

-	Network delays

-	Any logging enabled – for performance testing, logs should be either turned off or reduced to a minimum level. With only access log enabled, you can expect about a 25% reduction in performance. 

    >**Note – to turn off access logging, uncheck both the text and csv output options in Main Control Panel > Settings > Logs > Access Logs. All other types of logging can be disabled from Main Control Panel > Settings > Logs > Log Settings.**

For testing performance of RadiantOne Universal Directory stores, keep in mind the following:

-	Running performance tests that do searches only can skew your expected performance if your real clients issue a mix of searches and writes. To get a more realistic result, either run a test that mixes searches and modifications, or run a set of modification tests first and then run your tests that perform searches only. 

-	Expect a “warm-up” period of generally 15 seconds (run your tests for at least this length of time) to ensure the entire store is in memory before analyzing your results. In some cases, when the store is heavily modified, when the machine RAM available is close to the amount required to hold the entire store in memory, the “warm up” of RadiantOne can take more than 10 minutes as the system must learn that those new segments need to be in memory.

-	The RadiantOne Universal Directory is built on Lucene. Lucene leverages the OS file system cache for its disk-based data. The Java heap size allocated to RadiantOne is not applicable. Therefore, when the Universal Directory store memory requirements are close to reaching the maximum available on the machine, set [max heap size limits](01-global-tuning#memory-size) for the RadiantOne process instead of leveraging the automated expansion. This leaves more machine memory available for the Universal Directory store.
