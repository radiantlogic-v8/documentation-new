# Define Attribute Priority

For an example of the need for attribute priority, see [Attribute Priority](#_VUID) in the Concepts section.

If multiple identity sources publish values to the same global profile attribute (defined in the attribute mapping), you can define attribute priority/precedence.

From the main project page, select **Edit** > **Attribute Priority**.

![Attribute Priority Option](./media/image40.png)

Attribute Priority Option

Each attribute that is mapped from multiple sources is displayed in the table. Choose the attribute and the priority setting as shown on the right.

![Defining Attribute Priority](./media/image41.png)

Defining Attribute Priority

In the Priority drop-down list, choose a priority level for the identity source. If all sources have the same priority, and the attribute values in each source are unique, the global profile attribute will be multi-valued, containing all source values. Otherwise, the attribute is only populated from the identity source configured with the highest priority. If the attribute doesn't have a value in the identity source configured with the highest priority, the global profile attribute is populated from the identity source configured for the next highest priority.

>[!important]
>If you change attribute priority after you've uploaded into the global profile, you must re-upload the data sources.
