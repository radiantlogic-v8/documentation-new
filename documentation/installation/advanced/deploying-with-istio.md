---
title: Deploying with Istio Service Mesh
description: Learn how to deploy self-managed Identity Data Management with Istio Service Mesh.
---

# Deploying with Istio Service Mesh

This guide shows developers how to deploy a self‑managed Identity Data Management cluster on Kubernetes with Istio for ingress, egress, and service‑to‑service traffic management. 

The document assumes familiarity with Kubernetes, Helm, and enterprise networking concepts.

## Architecture Overview

Istio introduces a programmable data plane (Envoy sidecars) and a centralized control plane. Within a self-managed Identity Data Management deployment, it becomes the enforcement layer for inbound traffic, service communication, and outbound connectivity to external systems.

At a high level, the architecture flow looks like this:

![Istio IDDM Architecture](../images/istio-arch.png)

This architecture enables consistent policy enforcement, mutual TLS (mTLS), traffic shaping, resilience controls, and deep observability.

## Prerequisites

* A functioning Kubernetes cluster
* `kubectl` and `helm` configured with appropriate access
* DNS records and TLS certificates prepared for production hostnames (if using TLS)
* Traffic Exclusions: ZooKeeper and internal Identity Data Management fid ports must be excluded from interception

## Installation Workflow

The installation workflow consists of the following steps. 

```
# 1. Install Istio
kubectl create namespace istio-system
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm install istio-base istio/base -n istio-system --wait
helm install istiod istio/istiod -n istio-system --wait
helm install istio-ingressgateway istio/gateway -n istio-system --wait

# 2. Create Identity Data Management namespace with Istio injection
kubectl create namespace iddm-production
kubectl label namespace iddm-production istio-injection=enabled

# 3. Create image pull secret
kubectl create secret docker-registry regcred \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<password> \
  -n iddm-production

# 4. Create a values.yaml file or modify an existing one. 

# 5. Install Identity Data Management with Istio annotations
helm install iddm-helm radiantone/iddm \
  --namespace iddm-production \
  --values /tmp/values.yaml \
  --wait --timeout 15m

# 6. Create Istio configuration files

# 7. Apply Istio configs
kubectl apply -f /tmp/fid-ingress-config.yaml
kubectl apply -f /tmp/fid-egress-config.yaml

# 8. Patch microservices for port exclusions
bash /tmp/patch-microservices.sh

# 9. Verify installation and run tests
kubectl get pods -n iddm-production

```

These steps are explained in further details in the subsequent sections of this document. 

## Files needed

Create these files and ensure that they are accessible from your deployment environment. This document provides examples of what to include in these files in the later sections.

- `values.yaml` – Identity Data Management Helm values with Istio‑specific annotations. 
- `fid-ingress-config.yaml` – Ingress Gateway & VirtualService configuration. 
- `fid-egress-config.yaml` – Egress Gateway & ServiceEntries configuration.
- `patch-microservices.sh` – Shell script to patch microservice deployments. 


### 1. Install Istio

Install Istio base components, control plane, ingress gateway, and egress gateway. 

```
# Add Istio Helm repository
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# Create namespace
kubectl create namespace istio-system

# Install Istio base components (CRDs)
helm install istio-base istio/base \
  -n istio-system \
  --set defaultRevision=default \
  --wait

# Install Istio control plane (istiod)
helm install istiod istio/istiod \
  -n istio-system \
  --wait

# Install Ingress Gateway (in istio-system)
helm install istio-ingressgateway istio/gateway \
  -n istio-system \
  --set service.type=LoadBalancer \
  --wait

# Install Egress Gateway (in istio-system)  
helm install istio-egressgateway istio/gateway \
  -n istio-system \
  --set service.type=ClusterIP \
  --set labels.app=istio-egressgateway \
  --set labels.istio=egressgateway \
  --wait

# Verify installation
helm ls -n istio-system
kubectl get deployments -n istio-system
kubectl get svc -n istio-system
```

### 2. Create a namespace and enable sidecar injection

Create a dedicated namespace for Identity Data Management and turn on automatic sidecar injection. 

```
kubectl create namespace iddm-production

kubectl label namespace iddm-production istio-injection=enabled
```

### 3. Create the image pull secret in the same namespace: 

```
kubectl create secret docker-registry regcred \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<password> \
  -n iddm-production
```

### 4. Configure Helm values (`values.yaml`)

The `values.yaml` file defines Identity Data Management configuration and the Istio‑critical annotations. Create a values.yaml file or modify the existing one to include the following:

```
# Standard Identity Data Management configuration
fid:
  license: "your-license-key"
  rootPassword: "secure-password"

persistence:
  enabled: true
  storageClass: "gp3"  # Or your storage class

# CRITICAL: Pod annotations must be at ROOT LEVEL for Identity Data Management pods, NOT under "fid" section
podAnnotations:
  # Enable holdApplicationUntilProxyStarts for init containers to work
  proxy.istio.io/config: |
    holdApplicationUntilProxyStarts: true
  # Exclude internal FID and ZooKeeper ports from interception
  # traffic.sidecar.istio.io/excludeInboundPorts: "7070,7171,8089,8090"
  # traffic.sidecar.istio.io/excludeOutboundPorts: "7070,7171,8089,8090,2181,2888,3888"

# ZooKeeper configuration - DISABLE sidecars completely
zookeeper:
  replicaCount: 3
  persistence:
    enabled: true
    storageClass: "gp2"
    size: 20Gi
  # Disable Istio sidecar injection for ZooKeeper
  podAnnotations:
    sidecar.istio.io/inject: "false"

# Let Istio handle ingress and (optionally) egress; turn off ingress and gateway inside the chart. 
ingress:
  enabled: false

gateway:
  enabled: false

# Image pull secrets
imagePullSecrets:
  - name: regcred
```

### 5. Install self-managed Identity Data Management 

Deploy the self-managed Identity Data Management chart with istio annotations using your `values.yaml` file. 

```
# Install FID with the prepared values
helm install iddm-production oci://registry.radiantlogic.io/radiantone/helm/iddm-helm \
  --version 1.1.5 \
  -n iddm-production \
  --values values.yaml
```


### 6. Create Istio Configurations

In this step, you will configure Istio ingress and egress files. Create a directory structure similar to the following:

```
fid-istio-config/
├── templates/
│   ├── fid-ingress-config.yaml
│   ├── ingress-virtualservice.yaml
│   ├── fid-egress-config.yaml
│   ├── egress-virtualservice.yaml
└── values.yaml
```


#### 6.1 Ingress Configuration

Istio ingress controls how external traffic reaches your Identity Data Management services. It provides:
* Single entry point for all traffic
* SSL/TLS termination or passthrough
* Load balancing across Identity Data Management pods
* Edge-level security enforcement


Istio supports two primary TLS handling strategies (Termination vs. Passthrough). The correct choice depends on certificate ownership, inspection requirements, and authentication needs.

##### TLS Termination at Istio (SIMPLE / MUTUAL)

In this model, the Istio Gateway decrypts inbound TLS traffic and forwards HTTP traffic to backend services.

Traffic flow:

![](../images/istio-flow.png)

Use this when:

* You want Istio to manage certificates
* HTTP inspection or header manipulation is required
* Layer 7 policy enforcement is needed
* Identity Data Management does not require direct access to client certificates

Advantages:

* Centralized certificate lifecycle management
* Better oservability and metrics
* Support for rate limiting and authentication policies

Trade-offs:

* Client certificates are not preserved 
* Additional latency
* Identity Data Management does not see the original TLS session


##### TLS Passthrough

In passthrough mode, Istio forwards encrypted traffic without decrypting it. Identity Data Management terminates TLS directly.

Traffic flow:

![](../images/fid-flow.png)

Use passthrough when:

* Identity Data Management must access client certificates
* LDAP certificate authentication is required
* You have enterprise PKI requirements
* You have end-to-end encryption requirements

Advantages:

* Preserves client certificates
* Maintains end-to-end encryption
* Lower latency (no decrypt/encrypt reprocessing)
* Your Identity Data Management retains its own certificates

Trade-offs:

* No HTTP-layer inspection/modification
* Limited to TCP-level policies
* Certificates must be managed in Identity Data Management


**Example Production-ready Ingress Configuration**

Create a  `/tmp/fid-ingress-config.yaml` file with the following content:

```
# Ingress Gateway Configuration with TLS Passthrough
---
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: fid-ingress-gateway
  namespace: iddm-production
spec:
  selector:
    app: istio-ingressgateway
    istio: ingressgateway
  servers:
  # HTTPS with Passthrough (FID handles SSL)
  - port:
      number: 443
      name: https-passthrough
      protocol: HTTPS
    tls:
      mode: PASSTHROUGH
    hosts:
    - "*"
  # LDAPS with Passthrough  
  - port:
      number: 636
      name: ldaps-passthrough
      protocol: TLS
    tls:
      mode: PASSTHROUGH
    hosts:
    - "*"
  # Plain LDAP
  - port:
      number: 389
      name: ldap
      protocol: TCP
    hosts:
    - "*"
  # HTTP (will redirect to HTTPS)
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: fid-ingress-routes
  namespace: iddm-production
spec:
  hosts:
  - "*"
  gateways:
  - fid-ingress-gateway
  http:
  - match:
    - port: 80
    redirect:
      scheme: https
      port: 443
  tls:
  - match:
    - port: 443
      sniHosts:
      - "*"
    route:
    - destination:
        host: iddm-proxy-service
        port:
          number: 443
  tcp:
  - match:
    - port: 636
    route:
    - destination:
        host: fid-ext
        port:
          number: 2636
  - match:
    - port: 389
    route:
    - destination:
        host: fid-ext
        port:
          number: 2389
```

**Configuration Patterns**

Option A: For TLS Termination (Istio-Managed Certificates)

i. Update your values.yaml file to include the following properties: 

  ```
  # values.yaml for TLS termination
  istioAdvanced:
    enabled: true
    ingress:
      hosts:
        - "fid.example.com"
      tls:
        strategy: "termination"
        mode: "SIMPLE"           # or "MUTUAL"
        credentialName: "istio-fid-cert"
      ldaps:
        strategy: "termination"
        mode: "SIMPLE"
        credentialName: "istio-ldaps-cert"
  ```

ii. Create required secrets:

  ```
  kubectl create secret tls istio-fid-cert \
    --cert=path/to/fid.crt \
    --key=path/to/fid.key \
    -n istio-system
  
  kubectl create secret tls istio-ldaps-cert \
    --cert=path/to/ldaps.crt \
    --key=path/to/ldaps.key \
    -n istio-system
  ```

Option B: For TLS Passthrough (Certificates managed by Identity Data Management)

i. Update your values.yaml file to include the following properties:
  
  ```
  # values.yaml for TLS passthrough
  istioAdvanced:
    enabled: true
    ingress:
      hosts:
        - "fid.example.com"
      tls:
        strategy: "passthrough"
      ldaps:
        strategy: "passthrough"
  ```

ii. Update your values.yaml file to specify certificate configuration:

  ```
  fid:
    tls:
      enabled: true
      certificatePath: "/certs/fid.crt"
      privateKeyPath: "/certs/fid.key"
      clientCAPath: "/certs/client-ca.crt"
  ```


Option C: Mixed Mode (Common in Production)

HTTPS termination with LDAPS passthrough:

```
istioAdvanced:
  enabled: true
  ingress:
    hosts:
      - "fid.example.com"
      - "ldap.example.com"
    tls:
      strategy: "termination"
      mode: "SIMPLE"
      credentialName: "web-tls-cert"
    ldaps:
      strategy: "passthrough"
    ports:
      https: 443
      ldaps: 636
      ldap: 389
```

This approach allows HTTP-layer features for the web UI while preserving certificate-based authentication for LDAP.

Correct protocol selection in the Gateway is critical. Ensure that you are using the following:

```
# LDAPS
- port:
    number: 636
    protocol: TLS

# HTTPS
- port:
    number: 443
    protocol: HTTPS

# Plain LDAP
- port:
    number: 389
    protocol: TCP
```

Unlike HTTP/HTTPS, LDAPS can work with both termination and passthrough, but each has trade-offs.

Use passthrough if:
* You require client certificate authentication.
* You use SASL EXTERNAL.
* You want the safest and simplest configuration.

Use termination only if:
* You do not use client certificates.
* You want centralized certificate management in Istio.

Depending on your choice, modify your LDAP configuration:

```
# Complete LDAP/LDAPS Configuration
istioAdvanced:
  ingress:
    ports:
      ldap: 389   # Plain LDAP
      ldaps: 636  # Secure LDAPS
    
    # LDAPS strategy (choose one)
    ldaps:
      # For enterprise with client certs
      strategy: "passthrough"
      
      # OR for simple LDAPS without client certs use the following option instead. 
      # strategy: "termination"
      # mode: "SIMPLE"
      # credentialName: "ldaps-istio-cert"

```

For production LDAP deployments, it is recommended to use PASSTHROUGH mode to ensure all LDAP features are preserved. Additionally, consider bypassing Istio for LDAP ports by using pod annotations to avoid potential protocol issues.

**Example Production-ready VirtualService Template**

Create a `ingress-virtualservice.yaml` file to control routing rules with the following content:

```
{{- if .Values.istioAdvanced.enabled }}
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: fid-ingress-routes
  namespace: {{ .Release.Namespace }}
spec:
  hosts:
  {{- range .Values.istioAdvanced.ingress.hosts }}
  - {{ . | quote }}
  {{- end }}
  gateways:
  - fid-ingress-gateway
  http:
  - match:
    - uri:
        prefix: "/classic"
    route:
    - destination:
        host: iddm-proxy-service
        port:
          number: 8080
  - match:
    - uri:
        prefix: "/main"
    route:
    - destination:
        host: iddm-proxy-service
        port:
          number: 8080
  - match:
    - uri:
        prefix: "/api"
    route:
    - destination:
        host: api-gateway
        port:
          number: 8081
  - route:
    - destination:
        host: iddm-proxy-service
        port:
          number: 8080
  {{- if or .Values.istioAdvanced.ingress.ports.ldap .Values.istioAdvanced.ingress.ports.ldaps }}
  tcp:
  {{- if .Values.istioAdvanced.ingress.ports.ldaps }}
  - match:
    - port: 636
    route:
    - destination:
        host: fid-ext
        port:
          number: 2636
  {{- end }}
  {{- if .Values.istioAdvanced.ingress.ports.ldap }}
  - match:
    - port: 389
    route:
    - destination:
        host: fid-ext
        port:
          number: 2389
  {{- end }}
  {{- end }}
{{- end }}
```

HTTP routes handle HTTP/HTTPS traffic and can match on URL paths, headers, etc., while TCP routes handle non-HTTP protocols such as LDAP or databases and match only on the port. LDAP must always be configured under the "tcp:" section, not the "http:" section. Note that route order is important, so more specific routes must appear before more general ones.

#### 6.2 Egress Configuration 

Egress controls how your FID pods connect to external services. Proper configuration ensures security, compliance, reliability, and cost control. 

1. Add the following content to your `fid-egress-config.yaml` file. Here, the Gateway component contains the egress gateway that manages outbound traffic. The selector points to istio-egressgateway pods, and servers specify ports and protocols to handle.

```
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: fid-egress-gateway
  namespace: iddm-production
spec:
  selector:
    app: istio-egressgateway
    istio: egressgateway
  servers:
  # HTTP/HTTPS external services
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*.docker.io"
    - "*.github.com"
  - port:
      number: 443
      name: https
      protocol: HTTPS
    hosts:
    - "*.docker.io"
    - "*.github.com"

---
# ServiceEntry for Docker Hub
apiVersion: networking.istio.io/v1beta1
kind: ServiceEntry
metadata:
  name: docker-hub
  namespace: iddm-production
spec:
  hosts:
  - docker.io
  - registry-1.docker.io
  - auth.docker.io
  - production.cloudflare.docker.com
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  - number: 80
    name: http
    protocol: HTTP
  location: MESH_EXTERNAL
  resolution: DNS

---
# ServiceEntry for GitHub
apiVersion: networking.istio.io/v1beta1
kind: ServiceEntry
metadata:
  name: github
  namespace: iddm-production
spec:
  hosts:
  - github.com
  - api.github.com
  - raw.githubusercontent.com
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  location: MESH_EXTERNAL
  resolution: DNS

---
# VirtualService to route through egress gateway
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: docker-hub-routing
  namespace: iddm-production
spec:
  hosts:
  - docker.io
  - registry-1.docker.io
  - auth.docker.io
  - production.cloudflare.docker.com
  gateways:
  - fid-egress-gateway
  - mesh
  http:
  - match:
    - gateways:
      - mesh
    route:
    - destination:
        host: istio-egressgateway.istio-system.svc.cluster.local
        port:
          number: 443
  - match:
    - gateways:
      - fid-egress-gateway
    route:
    - destination:
        host: docker.io
        port:
          number: 443

---
# DestinationRule for cross-namespace routing
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: egressgateway-for-docker
  namespace: iddm-production
spec:
  host: istio-egressgateway.istio-system.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
```

##### Advanced Egress Features

You may also include any of these advanced egress features as needed. 

1. Restricting All External Access

Using this blocks all traffic except explicitly allowed services:

```
istioAdvanced:
  egress:
    restrictMode: true
```

Applied via Sidecar:

```
apiVersion: networking.istio.io/v1beta1
kind: Sidecar
metadata:
  name: default
  namespace: iddm-production
spec:
  egress:
  - hosts:
    - "./*"  # All local services
    {{- range .Values.istioAdvanced.egress.externalServices }}
    - "{{ .host }}"  # Explicitly allowed external
    {{- end }}
```

2. IP-Based Restrictions

Using this blocks specific IP ranges for external traffic:

```
apiVersion: networking.istio.io/v1beta1
kind: ServiceEntry
metadata:
  name: block-private-ips
spec:
  hosts:
  - "blocked.internal"
  addresses:
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  location: MESH_EXTERNAL
  resolution: STATIC
```

**3. Rate Limiting Egress**

This limits outbound requests via EnvoyFilter:

```
apiVersion: networking.istio.io/v1beta1
kind: EnvoyFilter
metadata:
  name: egress-ratelimit
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: "envoy.filters.network.http_connection_manager"
    patch:
      operation: INSERT_BEFORE
      value:
        name: envoy.filters.http.local_ratelimit
        typed_config:
          "@type": type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.local_ratelimit.v3.LocalRateLimit
          value:
            stat_prefix: http_local_rate_limiter
            token_bucket:
              max_tokens: 100
              tokens_per_fill: 100
              fill_interval: 60s
```

4. Egress with Authentication

You can use this for services that require authentication with client certificates:

```
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: external-with-auth
spec:
  host: secure-api.example.com
  trafficPolicy:
    tls:
      mode: MUTUAL
      clientCertificate: /etc/certs/client-cert.pem
      privateKey: /etc/certs/client-key.pem
      caCertificates: /etc/certs/ca-cert.pem
```

## 7. Apply Istio configurations

Once you have finalized all your Istio configurations, apply them by running the following commands:

```
kubectl apply -f /tmp/fid-ingress-config.yaml
kubectl apply -f /tmp/fid-egress-config.yaml
```

## 8. Add Additional Annotations for Microservices

The Identity Data Management StatefulSet receives its annotations from values.yaml. However, microservice deployments must be patched separately (This step is optional. Use it only when you need to exclude specific ports as part of network policies):

```
# Patch all microservices to exclude LDAP and FID REST ports
for deployment in authentication api-gateway directory-browser \
                  directory-namespace directory-schema settings \
                  system-administration data-catalog zipkin \
                  iddm-ui iddm-proxy; do
  kubectl patch deployment $deployment -n iddm-production --type='json' -p='[
    {
      "op": "add",
      "path": "/spec/template/metadata/annotations",
      "value": {
        # "traffic.sidecar.istio.io/excludeOutboundPorts": "2389,2636,8089,8090"
      }
    }
  ]' && echo "Patched: $deployment"
done
```

### 9. Verify deployment

i. Check that pods are ready and sidecars are injected: 

```
kubectl get pods -n iddm-production
```

ii. Get the ingress gateway address and test web access: 

```
export INGRESS_HOST=$(kubectl get svc -n istio-system istio-ingressgateway \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
# Or:
export INGRESS_HOST=$(kubectl get svc -n istio-system istio-ingressgateway \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

curl -k https://$INGRESS_HOST/classic -H "Host: fid.example.com"
```

iii. Test LDAP and LDAPS: 

```
ldapsearch -x -H ldap://$INGRESS_HOST:389 \
  -D "cn=Directory Manager" \
  -w "password" \
  -b "dc=example,dc=com" \
  "(objectClass=*)"

ldapsearch -H ldaps://$INGRESS_HOST:636 \
  -Y EXTERNAL \
  --cert /path/to/client.crt \
  --key /path/to/client.key \
  -b "dc=example,dc=com"
```

iv. Test egress from inside a pod: 

```
kubectl exec -n iddm-production deployment/api-gateway -c api-gateway -- \
  curl -s https://api.github.com/rate_limit
```

## Troubleshooting common issues 

### Init Containers Failing (Connection Refused)

Issue: FID init containers fail with "connection refused" to ZooKeeper.

Check:

```
kubectl describe pod fid-0 -n iddm-production
# Look for init container failures

kubectl logs fid-0 -n iddm-production -c check-zk
# Shows: "Connection refused" errors
```

**Root Cause:** Istio’s iptables redirect all traffic before the proxy is ready. Init containers run after `istio-init` but before `istio-proxy`, so no network connectivity is available during the init phase.

Fix:

```
# Add to values.yaml at TOP LEVEL (not under fid:)
podAnnotations:
  proxy.istio.io/config: |
    holdApplicationUntilProxyStarts: true
  traffic.sidecar.istio.io/excludeOutboundPorts: "2181,2888,3888"
```

If Helm annotations don’t apply:

```
kubectl patch statefulset fid -n iddm-production --type='json' -p='[
  {
    "op": "add",
    "path": "/spec/template/metadata/annotations/proxy.istio.io~1config",
    "value": "holdApplicationUntilProxyStarts: true"
  }
]'
```


### Authentication Service Returns 503

Issue: Authentication fails with "503 Service Unavailable" when calling `fid-app`.

Check:

```
kubectl logs deployment/authentication -n iddm-production -c authentication
# Shows: Error connecting to fid-app:2389 or fid-app:8089
```

**Root Cause:** Istio intercepts LDAP (2389) and FID REST (8089/8090) ports. Envoy proxy cannot parse binary LDAP protocol, resulting in connection failures.

Fix:

```
# Patch all microservices to exclude these ports
bash /tmp/patch-microservices.sh iddm-production
```

### Directory Manager User Not Found

Issue: Authentication fails with "user not found" despite FID running.

Check:

```
kubectl logs fid-0 -n iddm-production -c fid | grep -i "directory manager"
# Should show: Username: cn=Directory Manager
```

**Root Cause:** Pods restarted before initialization, often due to ZooKeeper connectivity issues or missing port exclusions.

Fix: Ensure all port exclusions are in place, then delete and recreate FID pods:

```
kubectl delete pod fid-0 -n iddm-production
kubectl wait --for=condition=ready pod fid-0 -n iddm-production --timeout=300s
```


### Pods Not Getting Sidecars

Issue: Pods show 1/1 containers instead of 2/2.

Check:

```
kubectl get namespace iddm-production -o yaml | grep istio-injection
```

Fix:

```
kubectl label namespace iddm-production istio-injection=enabled
kubectl rollout restart deployment -n iddm-production
kubectl rollout restart statefulset fid -n iddm-production
```


### 503 Service Unavailable – Investigation

Issue: Frequent 503 errors, often from `api-gateway` to backend.

**Investigation Steps:**

Check Envoy configuration:

```
kubectl exec -n iddm-production deployment/api-gateway -c istio-proxy -- \
  curl -s localhost:15000/clusters | grep authentication
```

Test direct connectivity:

```
kubectl exec -n iddm-production deployment/api-gateway -c api-gateway -- \
  wget -O- http://authentication-service:80/actuator/health
```

Check for IP mismatch:

```
kubectl get svc authentication-service -n iddm-production -o wide
kubectl get endpoints authentication-service -n iddm-production
```

**Root Causes:**

* STRICT mTLS policies
* Missing service endpoints
* Protocol mismatch

**Fix Priority:**

1. Check and override STRICT PeerAuthentication → PERMISSIVE
2. Verify endpoints exist → Fix service selectors
3. Create ServiceEntry/DestinationRule → Force protocol settings
4. Exclude ports for binary protocols → Use pod annotations


### FID-0 Continuously Restarting

Issue: FID-0 restarts with "Connection reset by peer" to ZooKeeper.

Check:

```
kubectl logs fid-0 -n iddm-production -c fid | grep -i zookeeper
```

**Root Cause:** Outbound ZooKeeper traffic intercepted by Istio; sidecar cannot handle ZooKeeper protocol.

Fix:

```
podAnnotations:
  traffic.sidecar.istio.io/excludeInboundPorts: "7070,7171,8089,8090"
  traffic.sidecar.istio.io/excludeOutboundPorts: "7070,7171,8089,8090,2181,2888,3888"
```

> Note: Port 2181 must be excluded for FID pods.


### LDAP Connection Refused

Issue: LDAP connections fail through Istio.

Check:

```
kubectl get deployment fid -n iddm-production -o yaml | grep -A5 excludeInboundPorts
```

Fix:

```
podAnnotations:
  traffic.sidecar.istio.io/excludeInboundPorts: "2389,2636"
```


### External Services Blocked

Issue: Cannot reach external services.

Check:

```
kubectl get serviceentry -n iddm-production
kubectl logs -n istio-system deployment/istio-egressgateway
```

Fix: Add ServiceEntry for the external service, ensure egress gateway is running, and verify firewall rules.


### High Latency

Issue: Requests are slower than expected.

Check:

```
kubectl exec -n iddm-production deployment/api-gateway -c istio-proxy -- \
  curl -s localhost:15000/stats | grep upstream_rq_time
```

Fix: Reduce circuit breaker sensitivity, increase connection pool size, and consider excluding internal ports from the mesh.


### Certificate Issues

Issue: TLS handshake failures.

Check:

```
kubectl get secret fid-tls-cert -n iddm-production
openssl s_client -connect $INGRESS_HOST:443 -servername fid.example.com
```

Fix:

```
kubectl create secret tls fid-tls-cert \
  --cert=path/to/cert.pem \
  --key=path/to/key.pem \
  -n iddm-production
```

