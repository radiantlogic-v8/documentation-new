---
title: Password Filter Guide
description: Password Filter Guide
---

# Overview

Synchronizing passwords can be challenging because of the many different encryption schemes used by data sources. One data source may use an encryption scheme that is not understood by another data source. Therefore, the only way to synchronize passwords between the two sources would be to capture the password in clear text before the data source encrypts it. RadiantOne offers a password filter component that captures a password in clear text when it is created or reset and publishes the password to other data sources that need this information. The password filter component is available for Active Directory.
