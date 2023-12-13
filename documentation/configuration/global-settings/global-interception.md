---
title: Global Interception
description: Learn how to configure global interception scripts. 
---

## Overview

For information on Interception scripts, please see [Interception Scripts](/introduction/concepts#interception-scripts). The following steps describe how to enable interception scripts at a global level (which are applicable to the entire RadiantOne namespace – all naming contexts).

To enable global interception: **UPDATE THESE STEPS**

1.	From the Main Control Panel > Settings Tab > Interception section > Global Interception sub section.

2.	On the right side, enable the operations you want to intercept. Save the settings and then you can edit the script. The script file is located at <RLI_HOME>\vds_server\custom\src\com\rli\scripts\intercept\globalIntercept.java

![An image showing ](Media/Image3.119.jpg)
 
Figure 1: Global Interception Settings

3.	After your script has been customized, save the file and then rebuild the intercept.jar with ANT. On the RadiantOne machine, rebuild the fidsync.jar with ANT using the following syntax:

`C:\radiantone\vds\vds_server\custom>c:\radiantone\vds\ant\bin\ant.bat buildjars`

4.	Restart the RadiantOne service. Your script logic is now invoked for the operations you have enabled.
