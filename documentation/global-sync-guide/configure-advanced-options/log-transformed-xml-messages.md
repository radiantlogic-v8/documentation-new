# Log transformed XML messages

To assist with troubleshooting, it can be helpful to log the transformed XML Message. Check the Log transformed XML messages option to have the message logged in:

`{RLI_HOME}\vds_server\logs\sync_engine\sync_engine.log` on the RadiantOne node where the sync engine processor that is assigned for the pipeline is running. If RadiantOne is deployed in a cluster, a sync engine processor can be running on one or more nodes and the pipeline processing is distributed across them. Check for the `{RLI_HOME}\vds_server\logs\sync_engine\sync_engine.log` on each cluster node to find the correct log file. Or you can use the Global Sync tab to download the corresponding sync_engine.log file by selecting the topology and selecting **Configure** next to the pipeline. Select the **Apply** component and in the **Log Viewer** section, select the **Download** button.
