---
title: attribute-priority
description: attribute-priority
---
         
# Attribute Priority

Attribute priority/precedence can be defined when a global profile attribute is populated from multiple identity sources. The default priority level set for all attributes is **normal**. This means, when a global profile attribute is populated from multiple identity sources, all unique values are returned in the global profile entry. For example, assume the following use case where two identity sources contain an overlapping user account and both identity sources are configured to publish the title attribute into the global profile. By default, the global profile title attribute contains the value from both identity sources. If the value of the title attribute was the same in both sources, the global profile title would just have one value. In the example depicted below, each identity source has a different value for title, so the global profile title attribute is multi-valued and has both values.

![Global Profile Title Attribute Populated from Two Identity Sources](./media/image10.png)

Global Profile Title Attribute Populated from Two Identity Sources

You can assign different priority levels for identity sources. In which case the highest priority, non-empty identity source attribute values will be used for the global profile attribute.

Priority Levels:

- Lowest

- Low

- Normal

- High

- Highest
