---
title: Enable metrics and logging
description: Learn how to enable metrics and collect logs of your Self-managed RadiantOne Identity Data Management application.
---

## Enable Metrics and Logging

RadiantLogic provides log files in your pod by default in case you need them for troubleshooting purposes. You can navigate to them by searching for ".log" files in the radiantone directory. 

This document shows you how to programmatically forward and process these log files in your existing monitoring and analyzing software.

To deploy Identity Data Management with metrics collection and logging, you will need to update your existing `values.yaml` file. This file allows you to customize the configuration settings that pertain to your cloud environment.

### Prerequisites

Radiant Logic supports the following tools for monitoring and analysis. You may choose one or more of these tools depending on your use case:

- **Prometheus (version 15.13.0)** for metrics collection.
- **Grafana (version 6.40.0)** for dashboard visualization.
- **ElasticSearch (version 7.17.3)** for log aggregation.
- **Kibana (version 7.17.3)** for log analysis.

Using the specified versions is crucial for compatibility with Identity Data Management.

### Configure the Following Parameters

  - **storageClass**: The `storageClass` parameter is set to `gp3` by default, which is specific to AWS. If you are using a different cloud provider, adjust this parameter according to the available storage classes that meet your performance and pricing needs.

  - **metrics**: Using this object setting, you can enable metrics to be collected in your Prometheus instance. Set the values as described below for the properties related to this object:

  - **enabled**: Set the value of this property to `true`.

  - **image**: This refers to the Docker image used for the metrics exporter. Set the value of this property to "radiantone/fid-exporter".

  - **imageTag**: This refers to the version tag of the Docker image. Set the latest version of the container as the value of this property.

  - **pushmode**: By default, the value of this field is `false`. This enables pull mode for Prometheus. After the deployment, you will automatically see metrics being pulled in your installed Prometheus instance. If you decide to use pushmode, set the value to "true" and ensure that Prometheus pushGateway is deployed and a URL for the gatway is available. 

  - **pushGateway**: You do not need to provide a value for this field unless you have an existing gateway and want to enable “push mode”.

  - **fluentd**: Use this object to enable logs and log aggregator(s) monitoring in Fluentd. To disable monitoring for a specific log file, set the value of `logs.enabled` to `false` for that log. Identity Data Management supports multiple log aggregation platforms, including Elasticsearch, OpenSearch, and Splunk. One or more aggregators can be configured.

 - **securityContext.runAsUser**: This configures the security context for the metrics container. Set the value of this property as 0.

- **annotations**: This allows you to add Kubernetes annotations to the metrics pods.

- **livenessProbe**: This configures the liveness probe for the metrics container.

- **readinessProbe**: This configures the readiness probe for the metrics container.

- **initialDelaySeconds**: This indicates the number of seconds to wait before performing the first probe.

- **timeoutSeconds**: This indicates the number of seconds after which the probe times out.

### Example Configuration

Here is an example configuration of metrics, logs, and aggregators in the `values.yaml` file:

```yaml
metrics: 
  enabled: true 
  image: radiantone/fid-exporter 
  imageTag: latest 
  securityContext: 
    runAsUser: 0 
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9091"
  pushMode: false 
  pushGateway: "" 
  pushMetricCron: "* * * * *"
  livenessProbe:
    initialDelaySeconds: 60
    timeoutSeconds: 5
  readinessProbe:
    initialDelaySeconds: 120
    timeoutSeconds: 5
  fluentd: 
    enabled: true
    configFile: /fluentd/etc/fluent.conf 
    logs: 
      vds_server: 
        enabled: true 
      vds_server_access: 
        enabled: true
        #Optionally, use the parse property to parse the log in a specified format.
        parse: |-
          <parse>
            @type tsv
            keys LOGID,LOGDATE,LOGTIME,LOGTYPE,SERVERID,SERVERPORT,SESSIONID,MSGID,CLIENTIP,BINDDN,BINDUSER,CONNNB,OPNB,OPCODE,OPNAME,BASEDN,ATTRIBUTES,SCOPE,FILTER,SIZELIMIT,TIMELIMIT,LDAPCONTROLS,CHANGES,RESULTCODE,ERRORMESSAGE,MATCHEDDN,NBENTRIES,ETIME
            types LOGID:integer,LOGDATE:string,LOGTIME:string,LOGTYPE:integer,SERVERID:string,SERVERPORT:integer,SESSIONID:integer,MSGID:integer,CLIENTIP:string,BINDDN:string,BINDUSER:string,CONNNB:integer,OPNB:integer,OPCODE:integer,OPNAME:string,BASEDN:string,ATTRIBUTES:string,SCOPE:string,FILTER:string,SIZELIMIT:integer,TIMELIMIT:integer,LDAPCONTROLS:string,CHANGES:string,RESULTCODE:integer,ERRORMESSAGE:string,MATCHEDDN:string,NBENTRIES:integer,ETIME:integer
          </parse>
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
