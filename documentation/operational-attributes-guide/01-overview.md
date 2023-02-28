---
title: Operational Attributes
description: Operational Attributes
---

# Operational Attributes Guide

## Overview

Operational Attributes are used for processing within the RadiantOne service and typically are not to be modified by user operations. In the RadiantOne LDAP schema, these attributes have USAGE directoryOperation.

An example schema entry is shown below for the createTimestamp attribute.

attributeTypes: ( 2.5.18.1 NAME 'createTimestamp' DESC 'Standard LDAP attribute type' EQUALITY generalizedTimeMatch ORDERING generalizedTimeOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation X-ORIGIN 'RFC 2252' )

The operational attributes used by RadiantOne are outlined in this guide.
