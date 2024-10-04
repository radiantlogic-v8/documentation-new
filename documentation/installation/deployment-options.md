---
title: Introduction to the Deployment Options
description: Learn about the deployment options for RadiantOne Identity Data Management.
---

## Overview

### Subscription Options

The two forms of subscriptions available for RadiantOne Identity Data Management are: SaaS and Self-managed.
For SaaS deployments, Radiant Logic own and manages the infrastructure where the Identity Data Management product is deployed. 

Whereas for self-managed deployments, the customer owns and manages the infrastructure. For self-managed deployments, Radiant Logic provides a helm chart and customers deploy the helm chart in their Kubernetes cluster. Unlike version 7.4, we no longer provide the option to install Radiant Logic products using traditional installers.

Key differentiators between the two forms of subscription are shown below.

Description	| SaaS | Self-managed
-|-|-
Securely connect to on-prem identity data silos w/o direct network connectivity (Secure Data Connectors)  	| X | - 
Access to AIDA – the Artificial Intelligent Data Assistant​.	| X | -
Environment Operations Center - Built-in dashboards for mnitoring and reporting​.	| X | -
Environment Operations Center - Built-in interface for querying and visualizing logs 	| X | -
Environment Operations Center – Control Plane for quickly and easily deploying RadiantOne Identity Data Management.  	| X | -
Environment Operations Center – easily  upgrade your RadiantOne Identity Data Management versions with a click of a button.  	| X | -
Customer can subscribe to release channels and get notifications about early access to Beta versions of upcoming product releases. | X | - 
Guaranteed 99.9% infrastructure availability. | X | ? (customer responsibility)
Deploy RadiantOne Identity Data Management in the platform using Helm Charts. | - | X
Deploy RadiantOne Identity Analytics using Helm Charts | - | X
Customer is responsible for deploying applications (IDDM and/or IDA), updating/upgrading versions of applications, scaling in/out the number of nodes used by the app. | X | X
Requires Kubernetes knowledgeable staff to install and maintain the cluster. | - | X
Customer owns and manages the Kubernetes infrastructure for the Applications. | - | X

### Technical Support

Radiant Logic technical support can be reached using any of the following options:

- E-mail: support@radiantlogic.com
- Website: https://support.radiantlogic.com

## SaaS

For SaaS deployments, RadiantOne Identity Data Management is installed by creating a new environment in [Environment Operations Center](/../../eoc/latest/environments/environment-overview/create-environments).

## Self-managed

For self-managed deployments, have your Kuberenetes cluster configured and then deploy RadiantOne Identity Data Management using Helm. For details see: [Self-managed Deployments](./self-managed.md)

## Upgrades

If you are looking to upgrade to v8.1 SaaS or Self-managed, see: [Upgrades](./upgrades.md) for options.
