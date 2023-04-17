---
title: Manage Global Identity Builder real-time persistent cache refresh
description: Learn how the cached virtual view created by the Global Identity Builder is kept up to date with changes that happen in the identity sources using real-time persistent cache refresh.
---

# Manage Global Identity Builder real-time persistent cache refresh

Once a Global Identity Builder project is complete, the global profile is kept up to date with changes that happen in the identity sources using real-time persistent cache refresh.

The definition of **persistent cache** can be found in the chapter [Global Identity Builder concepts](../concepts.md#persistent-cache).

To learn how to leverage persistent cache, please read the section on [configuring real-time persistent cache refresh](configuration.md).

At times it may be desirable or necessary to modify the properties of a project. In order to do so, real-time persistent cache refresh must be halted and restarted. To learn about this process, please read the section on [re-configuring project properties](re-configuration.md).

Different changes to [identity sources](../create-projects/identity-sources.md) (in other words, source events) can occur. In response, real-time persistent cache refresh produces corresponding outcomes for global profile identities. To learn about the different kinds of source events and their respective results, please read how [real-time persistent cache refresh impacts global profile identities](impact-on-global-profile.md).
