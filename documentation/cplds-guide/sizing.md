---
title: CPLDS Guide
description: CPLDS Guide
---

# Sizing

Each Follower-Only node (running a worker process) containing 32 GB RAM and 12+ cores can handle detecting changes from approximately 10 backends at the same time. This is assuming that each backend has around 1,000 entries of 1KB in size, in which case, the sync process takes around 1-2 seconds. At this rate, processing and synchronizing 2,200 backends of similar size can be accomplished in about 1-2 minutes. Larger entries (e.g. group entries containing many members) require more memory and can take longer to process.

The list of backends is distributed evenly across worker processes. The more workers deployed, the more the processing load from the backends can be distributed (sorting and comparing is CPU-intensive) and the faster the refresh process can be. Keep in mind that the RadiantOne Universal Directory target must absorb the updates from all of the work processes making the entire refresh process limited by the speed at which it can perform the updates (generally around 1,000-2,000 modifications/second per store).
