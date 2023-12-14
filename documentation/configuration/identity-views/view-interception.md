---
title: Configuring Interception Scripts
description: Learn how to configure an interception script for a specific identity view. 
---

## Interception Script

Interception scripts are written in Java and used to override the default behavior of RadiantOne to implement functionality to meet your needs. Examples of functionality you can introduce are:

-	Complex mappings (concatenations, or string manipulations)

-	Override the incoming query (pre-processing)

-	Processing/changing a result (post processing)

>[!warning] 
>Interception scripts are powerful and offer a lot of flexibility. However, this logic is executed inside RadiantOne so caution should be taken to ensure no undesirable effects. It is highly recommended that you engage Radiant Logic Professional Services to write the interception script(s). If you choose to write your own script(s), the Radiant Logic support team might be unable to diagnose problems in a timely manner. This can result in additional consultation fees imposed on the customer related to the time required to assess and certify the script logic. This is beyond the scope of support and falls under Radiant Logic Professional Services.

Interception scripts can be configured at a [global level](03-front-end-settings#global-interception) (to apply to all root naming contexts configured for the RadiantOne namespace), or for a specific identity view/naming context only. 

1.	After the script has been enabled from the Control Panel click Save in the upper right corner and apply the changes to the server. 

1.	To edit <naming_context>.java, click Edit Script. When finished editing, click Save.  If you are using a global Interception, the script is: globalIntercept.java

1.	Rebuild the intercept.jar file by clicking **Build Interception Jar**. 

1.	Restart the RadiantOne service. If RadiantOne is deployed in a cluster, you must restart the service on all nodes. Your script logic should now be invoked for the operations you have enabled.

For samples of interception scripts, please see the Radiant Logic Knowledge Base at: https://support.radiantlogic.com

Only registered customers have access to the Knowledge Base. 

>[!warning]
>If errors result from interception scripts, error code 1 is always returned by the script. To override this default behavior, and customize/return error codes based on
>the script logic, set useInterceptionErrorCodeOnViews to true using the following command:
>```
>https://radiantoneservice:8090/adap/util?action=vdsconfig&commandname=set-property&name=useInterceptionErrorCodeOnViews&value=true
>```
>For more information, including how to authenticate and issue configuration updates using the REST-based configuration API see:
>[Command Line Configuration](/command-line-configuration-guide/01-introduction).

