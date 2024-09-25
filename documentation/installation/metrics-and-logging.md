---
title: Enable metrics and logging
description: Learn how to enable metrics and collect logs of your Self-managed RadiantOne Identity Data Management application.
---

## Enable Metrics and Logging

To deploy Identity Data Management with metrics collection and logging, you will need to first update the existing `values.yaml` file. This file allows you to customize the configuration settings that pertain to your cloud environment.

### Prerequisites

We support the following tools for monitoring and analysis. You may choose one or more of these tools depending on your use case:

- **Prometheus (version 15.13.0)** for metrics collection.
- **Grafana (version 6.40.0)** for dashboard visualization.
- **ElasticSearch (version 7.17.3)** for log aggregation.
- **Kibana (version 7.17.3)** for log analysis.

Using the specified versions is crucial for compatibility with the Identity Data Management sidecar container.

### Configure the Following Parameters

- **storageClass**: The `storageClass` parameter is set to `gp3` by default, which is specific to AWS. If you are using a different cloud provider, adjust this parameter according to the available storage classes that meet your performance and pricing needs.

- **metrics**: Using this object setting, you can enable metrics to be collected in your Prometheus instance. Set the values as described below:

  - **metrics.enabled**: Set the value of this property to `true`.

  - **metrics.pushmode**: Set the value as `false` to enable pull mode for the metrics. After the deployment, you will automatically see metrics being pulled in your installed Prometheus instance.

  - **metrics.pushGateway**: You do not need to provide a value for this field unless you have an existing gateway and want to enable “push mode”.

  - **metrics.fluentd**: Use this object to enable logs and log aggregator(s) monitoring in Fluentd. To disable monitoring for a specific log file, set the value of `logs.enabled` to `false` for that log. Identity Data Management supports multiple log aggregation platforms, including Elasticsearch, OpenSearch, and Splunk. One or more aggregators can be configured.

### Example Configuration

Here is an example configuration of metrics, logs, and aggregators in the `values.yaml` file:

```yaml
metrics: 
  enabled: true 
  image: radiantone/fid-exporter 
  imageTag: latest 
  securityContext: 
    runAsUser: 0 
  annotations: {} 
  pushMode: false 
  pushGateway: "" 
  pushMetricCron: "* * * * *" 
  fluentd: 
    enabled: true 
    logs: 
      vds_server: 
        enabled: true 
      vds_server_access: 
        enabled: true 
      vds_events: 
        enabled: true 
      periodiccache: 
        enabled: true 
      web: 
        enabled: true 
      web_access: 
        enabled: true 
      sync_engine: 
        enabled: true 
      alerts: 
        enabled: true 
      adap_access: 
        enabled: true 
      admin_rest_api_access: 
        enabled: true 
    aggregators: 
       - type: "elasticsearch"  # This sets Elasticsearch as the log aggregator.  
         host: "elasticsearch-master" 
         port: "9200" 
       # Uncomment and configure additional aggregators as needed 
       # - type: "opensearch" 
       #   host: "opensearch-cluster-master" 
       #   port: "9200" 
       #   user: "admin" 
       #   password: "admin" 
       # - type: "splunk_hec" 
       #   hec_host: "splunk-s1-standalone-service.splunk-operator.svc.cluster.local" 
       #   hec_port: "8088" 
       #   hec_token: "" 
```

Provide accurate values for `host`, `port`, and authentication details to ensure proper log forwarding. Adjust the configuration based on your specific requirements and infrastructure setup, and redeploy the chart.
