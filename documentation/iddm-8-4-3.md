---
title: RadiantOne IDDM v8.4.3 Release Notes
description: RadiantOne IDDM v8.4.3 Release Notes
---

# RadiantOne Identity Data Management v8.4.3 Release Notes

June 11, 2026

These release notes contain important information about improvements and bug fixes for RadiantOne Identity Data Management v8.4.3
These release notes contain the following sections:

[Security Vulnerability Fixes](#security-vulnerability-fixes)
[Bug Fixes](#bug-fixes)
[Known Issues](#known-issues)
[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Security Vulnerability Fixes

- [API-4527]: Fix to address: CVE-2025-52999, CVE-2020-9548,CVE-2019-17267,CVE-2020-8840,CVE-2018-14721,CVE-2018-14720,CVE-2018-14718,CVE-2019-20330, CVE-2018-19360,CVE-2019-16335,CVE-2019-14892,CVE-2019-16943,CVE-2019-14379,CVE-2019-16942,CVE-2019-1753,CVE-2019-14893,CVE-2020-9547,CVE-2018-14719, CVE-2019-14540, CVE-2018-1936,CVE-2018-19362,CVE-2020-9546,CVE-2020-11113,CVE-2020-36183,CVE-2020-36185,CVE-2020-35728,CVE-2020-24616,CVE-2020-36181, CVE-2020-36187,CVE-2019-12086,CVE-2020-36179,CVE-2022-42004,CVE-2020-14061,CVE-2020-36182,CVE-2020-36188,CVE-2020-14060,CVE-2020-36184,CVE-2020-11619,CVE-2020-10969,CVE-2020-36518,CVE-2020-35491,CVE-2020-11620,CVE-2020-36189,CVE-2019-10172,CVE-2020-10673,CVE-2022-42003,CVE-2020-10968,CVE-2020-25649,CVE-2020-36180,CVE-2020-14195,CVE-2020-10672,CVE-2020-10650,CVE-2020-11111,CVE-2020-35490,CVE-2020-24750 ,CVE-2020-14062,CVE-2019-14439,CVE-2020-36186,CVE-2020-11112,& CVE-2021-20190.
- [API-4536]: Fix to address: CVE-2025-7962.
- [API-4537]: Fix to address: CVE-2026-45205
- [API-4538]: Fix to address: CVE-2026-8723.
- [API-4539]: Fix to address: CVE-2026-45149.
- [API-4605]: Fix to address: CVE-2020-11979.
- [API-4606]: Fix to address: CVE-2026-40181.
- [API-4613]: Fix to address: CVE-2026-2332,CVE-2025-11143,CVE-2026-42583,CVE-2026-42587,CVE-2026-34480,CVE-2026-34479,CVE-2026-34477,CVE-2025-68161, & CWE-770.
- [API-4615]: Fix to address: CVE-2026-45416 , CVE-2026-44249, CVE-2026-47691, & CVE-2026-45674.
- [API-4618]: Fix to address: CVE-2026-41850,CVE-2026-41851,CVE-2026-41840, CVE-2026-41842,CVE-2026-41841, CVE-2026-41843,CVE-2026-41853,CVE-2026-41710 and CVE-2026-40984.

## Bug Fixes

- [API-4542, SQ-1586]: Fixed an issue where the FileManager upload modal did not support uploading .jar files.

## Known Issues

The following issues have been identified in this release and will be addressed in a future release:
- [API-4420]: During migration import from v7.4.21 to v8.4.0, an IllegalStateException error "(Expected state [STARTED] was [STOPPED])" is logged in PathChildrenCache. The migration itself completes successfully despite the error.
For known issues reported after the release, please see the Radiant Logic Knowledge Base:
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com
If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com
