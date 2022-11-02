# Agents and Connectors

Agents manage connectors which includes deploying, stopping/suspending and starting them as needed.

A connector is a component that captures changes from data sources. Capture connectors are configured as part of the pipeline configuration process. Capture connectors associated with the RadiantOne Universal Directory (HDAP) stores or persistent caches are automatically configured when the stores are used as a source in a pipeline. Capture connectors for all other data sources require configuration. Capture connectors are configured from the Main Control Panel -> Global Sync tab. Select a topology on the left and then select **Configure** next to the pipeline.

>[!note]
>There are no apply connectors to configure or manage. Changes are propagated through the RadiantOne virtualization layer to the destination.

For details on connector types and properties available for each, please see the RadiantOne Connector Properties Guide.
