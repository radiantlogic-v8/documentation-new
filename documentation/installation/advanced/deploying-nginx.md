---
title: Deploying with Ingress NGINX 
description: Learn how to deploy self-managed Identity Data Management with Ingress NGINX.
---


## Overview

This guide provides comprehensive instructions for deploying [Ingress NGINX Controller](https://kubernetes.github.io/ingress-NGINX/) to handle all traffic types for Identity Data Management,
including HTTP/HTTPS for web services and TCP for LDAP/LDAPS.

By following this guide, you will configure a single LoadBalancer service capable of handling multiple protocols, including HTTP and HTTPS
for web services as well as TCP traffic for LDAP (389) and LDAPS (636). The setup includes HTTP-to-HTTPS redirection with TLS support,
integration with Identity Data Management’s internal HAProxy proxy, and a production-ready configuration designed for reliability and monitoring.

## Prerequisites

### Required Tools

Before beginning, confirm that the following tools are installed and properly configured:

- **kubectl** version 1.19 or later 
- **Helm** version 3.0 or higher

```bash
# Verify installed tools
kubectl version --client    # Kubernetes CLI (1.19+)
helm version               # Helm 3.0+

# Check cluster access
kubectl cluster-info
kubectl auth can-i create configmap --all-namespaces
```


The `kubectl auth can-i` command verifies that your current credentials have sufficient permissions to create ConfigMaps cluster-wide, required for the TCP services configuration step.

### Required Information

Have the following information ready, as you will be required to provide it in the later steps of the deployment process:

- [ ] **Target namespace** (example: `iddm-prod`) — the Kubernetes namespace where all IDDM components will be deployed
- [ ] **Storage class name** for persistent volumes — required for Identity Data Management's FID core and ZooKeeper data persistence; this is cluster-specific (e.g., `gp3` on AWS, `managed-premium` on Azure)
- [ ] **IDDM license key** — provided by Radiant Logic; the FID service will not start without it.
- [ ] **Admin password** — the root password that you want to use for the Identity Data Management directory service.
- [ ] **Domain name(s) for services** — the public DNS names clients will use to reach the IDDM web interface (e.g., `iddm.example.com`).
- [ ] **TLS certificates** — either pre-generated certificates from your organization, or use cert-manager as described in the Advanced Configurations section.


## Understanding the Architecture

### Traffic Flow with NGINX

The following diagram shows how external traffic flows through the Ingress NGINX Controller into Identity Data Management. 

```
Internet/Users
      ↓
[LoadBalancer Service]
├── HTTP (80) → NGINX → iddm-proxy (HAProxy)
├── HTTPS (443) → NGINX → iddm-proxy (HAProxy)
├── LDAP (389) → NGINX → fid-app (Direct)
└── LDAPS (636) → NGINX → fid-app (Direct)
      ↓
[Identity Data Management Services]
├── iddm-proxy (HAProxy) - Routes HTTP/HTTPS by path:
│   ├── / → iddm-ui (React UI)
│   ├── /api → api-gateway
│   ├── /classic → fid-ext (Classic UI)
│   ├── /admin-service → fid-admin
│   └── /rest-service → fid-app
│
└── fid-app - Handles LDAP/LDAPS directly
```


### Key Components

- **Ingress NGINX Controller:** Handles all external traffic.
- **Identity Data Management Proxy (HAProxy):** Internal reverse proxy for HTTP/HTTPS.
- **FID Core Services:** Directory services for LDAP/LDAPS.
- **Identity Data Management Microservices:** UI, API Gateway, and supporting services.


## Deployment steps

### 1. Certificate generation

Generate TLS certificates as the first step as the Ingress resource references a Kubernetes TLS secret that must exist when the ingress is applied. Choose one of the following methods based on your environment.

#### Option 1: Using OpenSSL

Self-signed certificates are suitable for development and testing. In production, use certificates from a trusted Certificate Authority to avoid browser warnings and client-side trust configuration. Be sure to include all hostnames and IP addresses clients will use in the Subject Alternative Names (SANs), as modern TLS clients require this.

```
# Create a directory for certificates
mkdir -p certs && cd certs

# Generate a private key for the CA
openssl genrsa -out ca-key.pem 4096

# Generate the CA certificate
openssl req -x509 -new -nodes -key ca-key.pem -sha256 -days 3650 -out ca-cert.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=IDDM-CA"

# Generate a private key for the server
openssl genrsa -out server-key.pem 4096

# Create a certificate signing request (CSR) with SANs
cat > server.conf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = US
ST = State
L = City
O = Organization
CN = iddm.example.com

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = iddm.example.com
DNS.2 = www.iddm.example.com
DNS.3 = api.iddm.example.com
DNS.4 = ldap.iddm.example.com
DNS.5 = *.iddm.example.com
IP.1 = 10.0.0.100  # If using IP access
EOF

# Generate the CSR
openssl req -new -key server-key.pem -out server.csr -config server.conf

# Generate the server certificate
openssl x509 -req -in server.csr -CA ca-cert.pem -CAkey ca-key.pem \
  -CAcreateserial -out server-cert.pem -days 365 \
  -extensions v3_req -extfile server.conf

# Verify the certificate
openssl x509 -in server-cert.pem -text -noout | grep -A1 "Subject Alternative Name"

# Return to parent directory
cd ..
```

#### Option 2: Using Step CA 

Step CA is a lightweight internal certificate authority that automates certificate issuance and renewal. It is a good choice if your organization wants more control over certificate lifecycle without depending on a public CA.

```
# Install step CLI
curl -L https://github.com/smallstep/cli/releases/latest/download/step_$(uname -s | tr '[:upper:]' '[:lower:]')_amd64.tar.gz | tar -xz
sudo mv step_*/bin/step /usr/local/bin/

# Initialize a new CA
step ca init --name="IDDM CA" --dns="ca.iddm.local" --address=":443" --provisioner="admin"

# Start the CA server (in background or separate terminal)
step-ca $(step path)/config/ca.json

# Create a certificate for IDDM services
step ca certificate "iddm.example.com" server-cert.pem server-key.pem \
  --san "iddm.example.com" \
  --san "www.iddm.example.com" \
  --san "api.iddm.example.com" \
  --san "ldap.iddm.example.com" \
  --san "*.iddm.example.com" \
  --not-after 8760h

# Get the root CA certificate
step ca root > ca-cert.pem
```


### 2. Configure Umbrella Chart for Deployment

The umbrella chart is a parent Helm chart that declares Identity Data Management and the Ingress NGINX Controller as dependencies and manages them together as a single release. This simplifies deployment, upgrades, and rollbacks since all components are versioned and deployed atomically.

#### i. Create a namespace

```
# Create namespace for your deployment
kubectl create namespace iddm-prod

# Set as current context
kubectl config set-context --current --namespace=iddm-prod
```

#### ii. Create umbrella chart structure

```
# Create your umbrella chart directory
mkdir my-iddm-NGINX && cd my-iddm-NGINX

# Create the chart structure
mkdir -p templates certs
```

#### iii. Copy certificates

The TLS secret is created from your certificate files and stored in Kubernetes so that the Ingress NGINX Controller can reference it when terminating HTTPS connections.

```
# Copy your generated certificates to the chart directory
cp ../certs/server-cert.pem ../certs/server-key.pem ../certs/ca-cert.pem ./certs/

# Create a secret from the certificates
kubectl create secret tls iddm-tls \
  --cert=certs/server-cert.pem \
  --key=certs/server-key.pem \
  -n iddm-prod --dry-run=client -o yaml > templates/tls-secret.yaml
```

#### iv. Create chart.yaml

This file defines the umbrella chart's identity and declares its two dependencies — the IDDM application chart and the Ingress NGINX Controller chart. Aliases allow you to reference each dependency cleanly in `values.yaml`.

You can also use direct helm commands to generate a default generic helm chart and then make changes accordingly.

```
# Chart.yaml - Defines the umbrella chart and its dependencies
apiVersion: v2
name: my-iddm-NGINX
description: IDDM deployment with Ingress NGINX controller
type: application
version: 1.0.0

# Define the charts this umbrella chart depends on
dependencies:
  # IDDM (FID) - The main application
  - name: iddm
    version: "1.1.4"  # Use the specific helm chart version you need
    repository: "oci://registry-1.docker.io/radiantone"
    alias: iddm  # Reference this as 'iddm' in values.yaml
    
  # Ingress NGINX - The ingress controller
  - name: ingress-NGINX
    version: "4.8.3"  # Latest stable version
    repository: "https://kubernetes.github.io/ingress-NGINX"
    alias: NGINX  # Reference this as 'NGINX' in values.yaml
```

#### v. Configure values.yaml

This file contains only the values you want to override from each subchart's defaults. Values not listed here will use the subchart's built-in defaults. Keeping this file focused on overrides makes upgrades easier, since you only need to review your customizations rather than a full configuration dump.

The annotations block under `NGINX.controller.service` is cloud-provider-specific. The example below targets AWS. Uncomment the relevant sections if deploying to Azure or GCP.

```
# values.yaml - Configuration overrides for both IDDM and NGINX

# ===== Global Configuration =====
# Your domain name for external access
domain: iddm.example.com

# ===== Ingress NGINX Configuration =====
# All values under 'NGINX:' override the ingress-NGINX subchart defaults
NGINX:
  controller:
    # Deploy 2 controller instances for high availability
    replicaCount: 2
    
    # Service configuration - Creates the LoadBalancer
    service:
      type: LoadBalancer  # Exposes NGINX externally
      annotations:
        # ===== AWS Configuration =====
        # Use Network Load Balancer for better performance
        service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
        # Enable cross-zone load balancing
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
        # Use TCP protocol for backend
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
        
        # For internal-only access (uncomment if needed)
        # service.beta.kubernetes.io/aws-load-balancer-scheme: "internal"
        
        # ===== Azure Configuration (uncomment for Azure) =====
        # service.beta.kubernetes.io/azure-load-balancer-internal: "true"
        # service.beta.kubernetes.io/azure-load-balancer-resource-group: "my-rg"
        
        # ===== GCP Configuration (uncomment for GCP) =====
        # cloud.google.com/load-balancer-type: "Internal"
        # networking.gke.io/load-balancer-type: "Internal"

    # CRITICAL: TCP services configuration
    # These entries tell NGINX to forward raw TCP traffic on ports 389 and 636
    # to the Identity Data Management service's internal LDAP/LDAPS ports (2389 and 2636)
    tcp:
      389: "{{ .Release.Namespace }}/{{ .Release.Name }}-iddm-fid:2389"
      636: "{{ .Release.Namespace }}/{{ .Release.Name }}-iddm-fid:2636"

    # Controller configuration
    config:
      # Enable real IP preservation — ensures backend services see the original client IP
      use-forwarded-headers: "true"
      compute-full-forwarded-for: "true"
      use-proxy-protocol: "false"

      # SSL configuration
      ssl-protocols: "TLSv1.2 TLSv1.3"
      ssl-ciphers: "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256"
      ssl-prefer-server-ciphers: "true"

      # Proxy timeouts for LDAP — set high to accommodate long-running directory operations
      proxy-connect-timeout: "600"
      proxy-send-timeout: "600"
      proxy-read-timeout: "600"

      # Body size for large LDAP responses
      proxy-body-size: "10m"

      # Enable logging
      enable-access-log-for-default-backend: "true"
      log-format-upstream: '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" $request_length $request_time [$proxy_upstream_name] [$proxy_alternative_upstream_name] $upstream_addr $upstream_response_length $upstream_response_time $upstream_status $req_id'

    # Resources
    resources:
      requests:
        cpu: 500m
        memory: 512Mi
      limits:
        cpu: 1000m
        memory: 1Gi

    # Pod Disruption Budget — ensures at least one controller replica stays available during node maintenance
    podDisruptionBudget:
      enabled: true
      minAvailable: 1

    # Anti-affinity for HA — spreads controller pods across different nodes to avoid a single point of failure
    affinity:
      podAntiAffinity:
        preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                  - key: app.kubernetes.io/name
                    operator: In
                    values:
                      - ingress-NGINX
              topologyKey: kubernetes.io/hostname

    # Metrics — exposes Prometheus-compatible metrics for monitoring controller performance
    metrics:
      enabled: true
      serviceMonitor:
        enabled: true
        namespace: monitoring

    # Admission webhooks — validates Ingress resources before they are applied, preventing misconfigurations
    admissionWebhooks:
      enabled: true
      failurePolicy: Fail

  # Default backend — serves a generic 404 response for requests that don't match any ingress rule
  defaultBackend:
    enabled: true
    replicaCount: 2

# Identity Data Management Configuration
iddm:
  # License and credentials
  fid:
    license: >-
      {rlib}YOUR_LICENSE_KEY_HERE
    rootPassword: "SecurePassword123!"  # CHANGE THIS!

  # Persistence
  persistence:
    enabled: true
    storageClass: "gp3"  # AWS EBS gp3
    size: 20Gi

  # ZooKeeper — used by FID for distributed coordination and configuration storage
  zookeeper:
    replicaCount: 3  # Production HA
    persistence:
      enabled: true
      storageClass: "gp3"
      size: 10Gi

  # Service configuration — ClusterIP ensures services are not directly exposed outside the cluster
  service:
    type: ClusterIP

  # Proxy configuration
  iddmProxy:
    enabled: true
    service:
      type: ClusterIP
      port: 80
    replicas: 1

  # Ensure all services are ClusterIP
  iddmServices:
    ui:
      service:
        type: ClusterIP
    api-gateway:
      service:
        type: ClusterIP
    authentication:
      service:
        type: ClusterIP

  # Resource allocation
  resources:
    limits:
      memory: "4Gi"
      cpu: "2"
    requests:
      memory: "2Gi"
      cpu: "1"

# ===== LDAPS Configuration =====
ldaps:
  # Choose how to handle LDAPS traffic:
  # - "termination": NGINX handles TLS (recommended for simplicity)
  # - "passthrough": FID handles TLS (for end-to-end encryption)
  mode: "termination"
```

#### vi. Create ingress templates

The Ingress resource defines how NGINX routes HTTP/HTTPS traffic to Identity Data Management services. The annotations below are included with broader best practices in mind. 
Modify them according to your specific usage and security requirements.

```
# templates/ingress.yaml
# This template creates the Ingress NGINX resource
# Only deployed if IDDM is enabled
{{- if .Values.iddm.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "my-iddm-NGINX.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "my-iddm-NGINX.labels" . | nindent 4 }}
  annotations:
    # ===== HTTPS Redirect Configuration =====
    # Force all HTTP traffic to redirect to HTTPS
    NGINX.ingress.kubernetes.io/ssl-redirect: "true"
    NGINX.ingress.kubernetes.io/force-ssl-redirect: "true"

    # ===== Backend Configuration =====
    # Protocol used to communicate with backend services
    NGINX.ingress.kubernetes.io/backend-protocol: "HTTP"

    # ===== Proxy Configuration =====
    # Increase body size limit for large LDAP responses
    NGINX.ingress.kubernetes.io/proxy-body-size: "10m"
    # Timeouts for long-running LDAP operations
    NGINX.ingress.kubernetes.io/proxy-connect-timeout: "600"
    NGINX.ingress.kubernetes.io/proxy-send-timeout: "600"
    NGINX.ingress.kubernetes.io/proxy-read-timeout: "600"

    # ===== Security Headers =====
    # These headers instruct browsers on how to handle content, reducing exposure to common web vulnerabilities
    NGINX.ingress.kubernetes.io/configuration-snippet: |
      more_set_headers "X-Frame-Options: SAMEORIGIN";
      more_set_headers "X-Content-Type-Options: nosniff";
      more_set_headers "X-XSS-Protection: 1; mode=block";
      more_set_headers "Referrer-Policy: strict-origin-when-cross-origin";
      more_set_headers "Permissions-Policy: geolocation=(), microphone=(), camera=()";
      more_set_headers "Strict-Transport-Security: max-age=31536000; includeSubDomains; preload";

    {{- with .Values.ingress.annotations }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  # Specify which ingress controller should handle this resource
  ingressClassName: NGINX
  
  # TLS configuration for HTTPS
  tls:
    - hosts:
        - {{ .Values.domain }}
        - www.{{ .Values.domain }}
      # Reference the TLS secret we created
      secretName: iddm-tls
  
  rules:
    # ===== Main Domain Rule =====
    - host: {{ .Values.domain }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                # Route to IDDM proxy (HAProxy) which handles path-based routing internally
                name: {{ .Release.Name }}-iddm-proxy
                port:
                  number: 80  # HAProxy listens on port 80 internally

    # ===== WWW Subdomain Rule =====
    - host: www.{{ .Values.domain }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Release.Name }}-iddm-proxy
                port:
                  number: 80
{{- end }}
```

**templates/_helpers.tpl**

The helpers file defines reusable template functions used across all other templates in the chart. This avoids duplicating naming logic in each template file.

```
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "my-iddm-NGINX.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "my-iddm-NGINX.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "my-iddm-NGINX.labels" -}}
helm.sh/chart: {{ include "my-iddm-NGINX.chart" . }}
{{ include "my-iddm-NGINX.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "my-iddm-NGINX.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-iddm-NGINX.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "my-iddm-NGINX.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
```

#### vii. Configure TCP Services

Because NGINX's TCP forwarding is controlled by a ConfigMap rather than the Ingress resource, a post-install job is used to apply the ConfigMap after the controller is running. 
The job runs after every install or upgrade.

```yaml
# templates/configure-tcp-job.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "my-iddm-NGINX.fullname" . }}-tcp-config
  namespace: {{ .Release.Namespace }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ include "my-iddm-NGINX.fullname" . }}-tcp-config
  namespace: {{ .Release.Namespace }}
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list", "patch", "update"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "my-iddm-NGINX.fullname" . }}-tcp-config
  namespace: {{ .Release.Namespace }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ include "my-iddm-NGINX.fullname" . }}-tcp-config
subjects:
  - kind: ServiceAccount
    name: {{ include "my-iddm-NGINX.fullname" . }}-tcp-config
    namespace: {{ .Release.Namespace }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "my-iddm-NGINX.fullname" . }}-configure-tcp
  namespace: {{ .Release.Namespace }}
  annotations:
    "helm.sh/hook": post-install,post-upgrade
    "helm.sh/hook-weight": "1"
    "helm.sh/hook-delete-policy": before-hook-creation
spec:
  template:
    spec:
      restartPolicy: OnFailure
      serviceAccountName: {{ include "my-iddm-NGINX.fullname" . }}-tcp-config
      containers:
        - name: configure
          image: bitnami/kubectl:latest
          command:
            - /bin/bash
            - -c
            - |
              set -e
              echo "Configuring TCP services for NGINX..."

              # Wait for NGINX controller to be ready before applying the ConfigMap
              kubectl wait --for=condition=available --timeout=300s deployment/{{ .Release.Name }}-NGINX-ingress-NGINX-controller -n {{ .Release.Namespace }}

              # Get the FID service name
              FID_SERVICE="{{ .Release.Name }}-iddm-fid"

              # Create or update TCP services ConfigMap
              cat <<EOF | kubectl apply -f -
              apiVersion: v1
              kind: ConfigMap
              metadata:
                name: {{ .Release.Name }}-NGINX-ingress-NGINX-controller-tcp
                namespace: {{ .Release.Namespace }}
              data:
                389: "{{ .Release.Namespace }}/${FID_SERVICE}:2389"
                636: "{{ .Release.Namespace }}/${FID_SERVICE}:2636"
              EOF

              echo "TCP services configured successfully"
```

#### viii. Add Health Check Configuration

This file exposes the NGINX controller's built-in health endpoint, allowing external monitoring systems and load balancer health checks to verify that the controller is running and ready to accept traffic.

```
# templates/health-check.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "my-iddm-NGINX.fullname" . }}-healthz
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "my-iddm-NGINX.labels" . | nindent 4 }}
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 10254
      protocol: TCP
      name: healthz
  selector:
    app.kubernetes.io/name: ingress-NGINX
    app.kubernetes.io/component: controller
```

#### ix. Deploy the Solution

Run the following commands for deployment. A dry-run is strongly recommended before the actual deployment. It renders all templates and validates them without making any changes, catching configuration errors early.

```
# Add Helm repositories for the dependencies
helm repo add ingress-NGINX https://kubernetes.github.io/ingress-NGINX
helm repo update

# Update dependencies (downloads IDDM and NGINX charts)
helm dependency update

# Create TLS secret from certificates
kubectl create secret tls iddm-tls \
  --cert=certs/server-cert.pem \
  --key=certs/server-key.pem \
  -n iddm-prod

# Deploy with dry-run first to verify
helm install my-iddm . \
  --namespace iddm-prod \
  --values values.yaml \
  --dry-run --debug

# Deploy the umbrella chart
helm install my-iddm . \
  --namespace iddm-prod \
  --values values.yaml \
  --wait \
  --timeout 10m

# Verify deployment
kubectl get pods -n iddm-prod
kubectl get svc -n iddm-prod
kubectl get ingress -n iddm-prod
```


## Understanding Ingress configuration

### HTTP/HTTPS routing

Ingress NGINX routes HTTP/HTTPS traffic to the Identity Data Management proxy (HAProxy), which then handles all internal path-based routing to individual microservices:

```yaml
backend:
  service:
    name: my-iddm-proxy  # HAProxy service
    port:
      number: 80         # HAProxy listens on port 80
```

The Identity Data Management proxy routes based on URL path:

- `/` → `iddm-ui` service (React UI)
- `/api/*` → `api-gateway` service
- `/classic/*` → `fid-ext` service (Classic UI)
- `/admin-service/*` → `fid-admin` service
- `/rest-service/*` → `fid-app` service

### Key Annotations

```
# Force HTTPS — redirects all HTTP requests to HTTPS before they reach the backend
NGINX.ingress.kubernetes.io/ssl-redirect: "true"

# Increase body size for large requests — important for LDAP operations that return large result sets
NGINX.ingress.kubernetes.io/proxy-body-size: "10m"

# Timeouts for long-running operations — prevents connection drops during slow directory queries
NGINX.ingress.kubernetes.io/proxy-read-timeout: "600"

# Security headers — applied to every response to improve browser security posture
NGINX.ingress.kubernetes.io/configuration-snippet: |
  more_set_headers "Strict-Transport-Security: max-age=31536000";
```

### TCP configuration details

Unlike HTTP routing, which uses the `Ingress` resource, TCP service mappings are defined in a ConfigMap. NGINX reads this ConfigMap to determine which backend service should receive traffic on each TCP port. The format is straightforward:

```yaml
data:
  389: "namespace/service:port"  # LDAP
  636: "namespace/service:port"  # LDAPS
```

### LDAP Configuration

```yaml
# ConfigMap entry
389: "iddm-prod/my-iddm-fid:2389"

# This maps:
# External port 389 → FID service port 2389
```

### LDAPS Configuration Options

#### Option 1: SSL Passthrough (Recommended)

In passthrough mode, NGINX forwards the encrypted TCP stream directly to FID without decrypting it. FID handles the TLS handshake end-to-end, which is preferable when certificate management is handled within FID or when end-to-end encryption is required.

```yaml
# FID handles SSL/TLS
636: "iddm-prod/my-iddm-fid:2636"
```

#### Option 2: SSL Termination

In termination mode, NGINX decrypts the LDAPS connection and forwards plain LDAP traffic to FID. This is simpler to configure but means traffic between NGINX and FID is unencrypted inside the cluster.

```yaml
# NGINX terminates SSL (requires stream snippets)
636: "iddm-prod/my-iddm-fid:2389"

# Additional configuration needed in NGINX controller:
stream-snippets: |
  server {
    listen 636 ssl;
    ssl_certificate /etc/NGINX/ssl/tls.crt;
    ssl_certificate_key /etc/NGINX/ssl/tls.key;
    proxy_pass my-iddm-fid:2389;
  }
```

## Advanced Configurations

### Multiple ingress classes

If you need to route different traffic through different NGINX controllers (for example, separating internal and external traffic), 
you can deploy multiple controller instances with distinct ingress class names.

```yaml
# Deploy multiple NGINX controllers
NGINX:
  controller:
    ingressClass: NGINX-internal
    electionID: NGINX-internal-leader

NGINX-external:
  controller:
    ingressClass: NGINX-external
    electionID: NGINX-external-leader
```

### Custom Error Pages

Custom error pages improve the user experience by displaying branded, informative messages instead of the default NGINX error responses.

```yaml
# templates/error-pages.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "my-iddm-NGINX.fullname" . }}-error-pages
data:
  404.html: |
    <!DOCTYPE html>
    <html>
    <head><title>404 Not Found</title></head>
    <body>
      <h1>Page Not Found</h1>
      <p>The requested resource was not found.</p>
      <p><a href="/">Return to IDDM</a></p>
    </body>
    </html>
  503.html: |
    <!DOCTYPE html>
    <html>
    <head><title>Service Unavailable</title></head>
    <body>
      <h1>Service Temporarily Unavailable</h1>
      <p>Please try again later.</p>
    </body>
    </html>
```

### Optional Advanced Features

#### Rate Limiting 

Rate limiting protects Identity Data Management services from abuse and traffic spikes by capping the number of requests accepted per client.
The whitelist allows trusted internal networks to bypass limits.

```
# In ingress annotations, add:
NGINX.ingress.kubernetes.io/limit-connections: "10"
NGINX.ingress.kubernetes.io/limit-rps: "100"  # Requests per second
NGINX.ingress.kubernetes.io/limit-whitelist: "10.0.0.0/8,172.16.0.0/12"
```

#### ModSecurity WAF

ModSecurity adds a Web Application Firewall layer that inspects incoming requests against the OWASP Core Rule Set, blocking common attack patterns
such as SQL injection and cross-site scripting.

```
# values.yaml addition
NGINX:
  controller:
    config:
      enable-modsecurity: "true"
      enable-owasp-modsecurity-crs: "true"
      modsecurity-snippet: |
        SecRuleEngine On
        SecRequestBodyAccess On
        SecRule ARGS "@contains test" "id:1,phase:2,t:lowercase,deny"
```

#### Using cert-manager 

cert-manager automates TLS certificate issuance and renewal. This removes the need to manually rotate certificates before they expire.

```
# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml

# Create ClusterIssuer
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: NGINX
EOF
```

Then update your ingress template to reference the issuer:

```
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
```


## Troubleshooting

### Common Issues

#### 1. TCP services not working

If LDAP or LDAPS connections are being refused, the most common cause is a missing or incorrectly named ConfigMap. Verify the ConfigMap exists and contains the right port mappings, then check controller logs to confirm NGINX loaded the configuration.

```
# Check if ConfigMap exists
kubectl get configmap -n iddm-prod | grep tcp

# Verify ConfigMap content
kubectl get configmap -n iddm-prod my-iddm-NGINX-ingress-NGINX-controller-tcp -o yaml

# Check controller logs
kubectl logs -n iddm-prod -l app.kubernetes.io/name=ingress-NGINX -f | grep -i tcp
```

#### 2. 502 Bad Gateway

A 502 response means NGINX reached the backend service but received an error or no response. Check that the backend service exists and has healthy endpoints before testing internal connectivity directly.

```
# Check backend services
kubectl get svc -n iddm-prod | grep -E "proxy|fid"

# Verify endpoints
kubectl get endpoints -n iddm-prod my-iddm-proxy

# Test internal connectivity
kubectl run -it --rm debug --image=nicolaka/netshoot -n iddm-prod -- bash
# Inside pod:
curl -v http://my-iddm-proxy
```

#### 3. Certificate Issues

Certificate problems typically manifest as browser warnings or TLS handshake failures. Verify the secret exists and that the certificate it contains is valid and covers the correct hostnames.

```
# Check certificate secret
kubectl get secret -n iddm-prod | grep tls

# Describe certificate
kubectl describe certificate -n iddm-prod

# View certificate details
kubectl get secret my-iddm-tls -n iddm-prod -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -text -noout
```

#### 4. LDAP Connection Failed

If LDAP connections fail at the client level, first confirm the LoadBalancer address is correct, then test with a basic `ldapsearch` before investigating at the network level with `tcpdump`.

```
# Test LDAP connectivity
NGINX_LB=$(kubectl get svc -n iddm-prod my-iddm-NGINX-ingress-NGINX-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Test LDAP
ldapsearch -H ldap://$NGINX_LB:389 -x -b "" -s base

# Debug with tcpdump
kubectl exec -it -n iddm-prod deployment/my-iddm-NGINX-ingress-NGINX-controller -- tcpdump -i any port 389
```

### Debug commands

```
# Get all resources
kubectl get all,ingress,configmap,secret -n iddm-prod

# Check the full NGINX configuration that was generated from your Ingress resources
kubectl exec -n iddm-prod deployment/my-iddm-NGINX-ingress-NGINX-controller -- NGINX -T

# View NGINX logs
kubectl logs -n iddm-prod -l app.kubernetes.io/name=ingress-NGINX -f

# Check admission webhook
kubectl get validatingwebhookconfigurations | grep NGINX

# Events — useful for spotting recent errors or state changes across all resources in the namespace
kubectl get events -n iddm-prod --sort-by='.lastTimestamp'
```


## Verification and testing

**1. Get LoadBalancer Address**

The LoadBalancer may expose either a hostname (common on AWS) or an IP address (common on GCP/Azure). The command below handles both cases.

```
export NGINX_LB=$(kubectl get svc -n iddm-prod my-iddm-NGINX-ingress-NGINX-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
if [ -z "$NGINX_LB" ]; then
  export NGINX_LB=$(kubectl get svc -n iddm-prod my-iddm-NGINX-ingress-NGINX-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
fi

echo "NGINX LoadBalancer: $NGINX_LB"
```

**2. Test HTTP to HTTPS Redirect**

A `308 Permanent Redirect` response confirms that the SSL redirect annotation is working correctly and all HTTP traffic will be upgraded to HTTPS.

```
# Should return 308 Permanent Redirect
curl -I http://$NGINX_LB -H "Host: iddm.example.com"
```
**3. Test Web Services**

```
# Test HTTPS
curl -k https://$NGINX_LB -H "Host: iddm.example.com"

# Test specific paths
curl -k https://$NGINX_LB/api/health -H "Host: iddm.example.com"
curl -k https://$NGINX_LB/classic/ -H "Host: iddm.example.com"
```

**4. Test LDAP Services**

```
# Test LDAP
ldapsearch -H ldap://$NGINX_LB:389 -x -b "" -s base "(objectclass=*)"

# Test LDAPS
LDAPTLS_REQCERT=never ldapsearch -H ldaps://$NGINX_LB:636 -x -b "" -s base "(objectclass=*)"

# Check TLS certificate presented by the LDAPS endpoint
openssl s_client -connect $NGINX_LB:636 -servername ldap.iddm.example.com
```

**5. Performance testing**

These tests validate that the deployment can handle realistic load before going to production. Run them from outside the cluster to test the full network path.

```
# HTTP load test
ab -n 1000 -c 10 -H "Host: iddm.example.com" https://$NGINX_LB/

# LDAP load test
for i in {1..100}; do
  ldapsearch -H ldap://$NGINX_LB:389 -x -b "" -s base &
done
```

## Production considerations

### High availability configuration

The configuration below ensures the NGINX controller remains available during rolling updates, node failures, and periods of high load. The Pod Disruption Budget prevents too many replicas from being taken down simultaneously during maintenance.

```
NGINX:
  controller:
    replicaCount: 3
    podDisruptionBudget:
      enabled: true
      minAvailable: 2
    autoscaling:
      enabled: true
      minReplicas: 2
      maxReplicas: 10
      targetCPUUtilizationPercentage: 80
      targetMemoryUtilizationPercentage: 80
```

### Monitoring and metrics

Enabling Prometheus metrics allows you to track request rates, error rates, latency, and upstream health for all traffic passing through the controller.

```
NGINX:
  controller:
    metrics:
      enabled: true
      service:
        annotations:
          prometheus.io/scrape: "true"
          prometheus.io/port: "10254"
      serviceMonitor:
        enabled: true
        additionalLabels:
          release: prometheus
```

### Security hardening

The security context below runs the controller as a non-root user with a read-only filesystem and drops all Linux capabilities except the one required to bind to privileged ports (80 and 443).

```
NGINX:
  controller:
    # Network policies
    networkPolicy:
      enabled: true

    # Pod security
    podSecurityPolicy:
      enabled: true

    # Security contexts
    containerSecurityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      runAsNonRoot: true
      runAsUser: 101
      capabilities:
        drop:
          - ALL
        add:
          - NET_BIND_SERVICE
```

### Backup Strategy

#### Configuration Backup

Back up Ingress definitions, ConfigMaps, and secrets separately so they can be restored independently if needed.

```
# Backup ingress definitions
kubectl get ingress -n iddm-prod -o yaml > ingress-backup.yaml

# Backup ConfigMaps
kubectl get configmap -n iddm-prod -o yaml > configmap-backup.yaml

# Backup secrets
kubectl get secret -n iddm-prod -o yaml > secret-backup.yaml
```

#### Automated Backup

The CronJob below runs nightly at 2am and saves a snapshot of all Ingress-related resources to a mounted backup volume.

```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: NGINX-config-backup
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: backup
              image: bitnami/kubectl:latest
              command:
                - /bin/bash
                - -c
                - |
                  kubectl get ingress,configmap,secret -n iddm-prod -o yaml > /backup/NGINX-config-$(date +%Y%m%d).yaml
```

### Performance tuning

These settings tune NGINX's internal worker processes, connection handling, buffering, and compression. Adjust `worker-connections` based on expected concurrent connection counts, particularly for LDAP workloads where connections are long-lived.

```
NGINX:
  controller:
    config:
      # Worker processes
      worker-processes: "auto"
      worker-connections: "10240"

      # Keep-alive
      keep-alive: "75"
      keep-alive-requests: "100"

      # Buffers
      client-body-buffer-size: "1m"
      client-header-buffer-size: "1k"
      large-client-header-buffers: "4 16k"

      # Timeouts
      client-body-timeout: "60"
      client-header-timeout: "60"
      send-timeout: "60"

      # Gzip compression — reduces bandwidth for JSON and text responses from IDDM APIs
      use-gzip: "true"
      gzip-level: "5"
      gzip-types: "application/json,application/javascript,text/css,text/plain"
```

### Migration considerations

#### Migration from NodePort services

If migrating from an existing NodePort-based setup, update services to ClusterIP before deploying the umbrella chart to avoid port conflicts.

1. List current services:
   ```bash
   kubectl get svc -n iddm-prod -o wide | grep NodePort
   ```

2. Update to ClusterIP:
   ```bash
   kubectl patch svc my-iddm-proxy -n iddm-prod -p '{"spec":{"type":"ClusterIP"}}'
   ```

3. Deploy the umbrella chart
4. Update DNS records to point to the new LoadBalancer

#### Migration from other ingress controllers

For gradual migration, deploy the NGINX controller alongside the existing one using a different ingress class. This lets you validate the new setup with a subset of traffic before cutting over fully.

1. Deploy with a different class:
   ```
   helm install my-iddm . \
     --set NGINX.controller.ingressClass=NGINX-new \
     -n iddm-prod
   ```

2. Test the new setup.
3. Switch traffic gradually.
4. Remove old ingress controller.

## Next steps

Here are some additional steps for you to consider implementing:

1. Configure DNS to point your domain to the LoadBalancer address obtained in the verification step.
2. Set up monitoring by deploying Prometheus and Grafana to visualize the metrics enabled in this guide.
3. Configure backups by implementing the automated backup CronJob for regular configuration snapshots.
4. Perform security review by applying network policies and RBAC. 
5. Perform load testing to validate performance under realistic load before going live.
