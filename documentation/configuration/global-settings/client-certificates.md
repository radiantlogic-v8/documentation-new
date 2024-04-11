---
title: Client Certificates
description: Learn how to manage client certificates. 
---

## Overview

The certificates in the Client Certificate Trust Store are used by RadiantOne to connect via SSL to underlying data sources. Therefore, the appropriate client (public key) certificate (associated with the server certificate of the backend) needs imported into the Client Certificate Trust Store (unless they are signed by a trusted/known Certificate Authority).

## Client Certificate Trust Store

Client certificates can be added to the Client Certificate Truststore at any time without needing to restart the RadiantOne service. All RadiantOne cluster nodes share the contents of the Client Certificate Truststore.

Import client certificates into the truststore from the Control Panel > Global Settings > Client Certificates. Certificates can be viewed, imported, exported or deleted from here.

## Viewing Client Certificates

To view a certificate, select the certificate in the list and click **View**. Valuable information about the certificate is shown (who issued the certificate, who the certificate was issued to, when the certificate is set to expire, status…etc.).

### Importing Client Certificates

To add a certificate:
1.	Click **Import**.
2.	Enter a short, unique name (alias) for the certificate.
3.	Browse to the location of the client certificate file and click **OK**.
4.	Click **Save** in the upper right corner.

### Deleting Client Certificates

To delete a certificate:

1.	Select the desired certificate and click **Delete**.
2.	Click **Yes** to confirm the deletion.
3.	Click **OK** to exit the confirmation.
4.	Click **Save** in the upper right corner.

### Exporting Client Certificates

To export a certificate:

1.	Select the desired certificate and click **Export**.
2.	Enter a location to export the file to.
3.	Enter a name for the exported file.
4.	Click **OK** to export the certificate to a file.
5.	Click **OK** to exit the confirmation.
6.	Click **Save** in the upper right corner.
