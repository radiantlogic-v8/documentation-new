---
title: Hardening Guide
description: Hardening Guide
---


# Preface

## About this Manual

This document describes some basic tips and general guidance on how to harden RadiantOne so that security risks are reduced as much as possible.

## Audience

This manual is intended for administrators who are responsible for hardening RadiantOne against security threats. This guide provides best practices and general recommendations. The RadiantOne Administrator must decide which items are applicable to their environment and
corporate policies.

## How the Manual is Organized

[Chapter 1 - Securing RadiantOne Configuration and Administration](01-securing-radiantone-configuration-and-administration.md)

This chapter includes a description of the delegated administration accounts included by defaultwith RadiantOne and how to update their passwords. In addition, you will find general recommendations for securing the machine where RadiantOne is installed.

[Chapter 2 – Client Access Limits and Regulation](02-client-access-limits-and-regulations.md)

This chapter describes parameters for limiting and regulating access to the server.

[Chapter 3 – Recommendations for Securing Data at Rest](03-recommendations-for-securing-data-at-rest.md)

This chapter describes recommendations for securing data at rest in RadiantOne.

[Chapter 4 – Recommendations for Securing Data in Transit - SSL/TLS Settings](04-recommendations-for-securing-data-in-transit-ssl-tls-settings.md)

This chapter provides recommendations for securing data in transit.

[Chapter 5 – Recommendations for Monitoring](05-enable-fips-mode.md)

This chapter provides recommendations for monitoring RadiantOne components.

## Technical Support

Technical support can be reached using any of the following options:

- Website: support.radiantlogic.com
- E-mail: support@radiantlogic.com

## Expert Mode

Some settings in the Main Control Panel are accessible only in Expert Mode. To switch toExpert Mode, click the Logged in as, (username) drop-down menu and select Expert Mode.

![An image showing Expert Mode](Media/Image1.1.jpg)

>[!note
>The Main Control Panel saves the last mode (Expert or Standard) it was in when you log out and returns to this mode automatically when you log back in. The mode is saved on a per-role basis.