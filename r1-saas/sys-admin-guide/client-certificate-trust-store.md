---
title: System Administration Guide
description: System Administration Guide
---

# Client Certificate Trust Store (Cluster Level Trust Store)

Many RadiantOne installed components (e.g. Control Panel) act as client’s to the local RadiantOne service and might require SSL access. Therefore, any time you change the RadiantOne server certificate, you must import the corresponding public key certificate into the Client Certificate Trust Store (unless the signer of the server certificate is already trusted).

Also, the certificates in the Client Certificate Trust Store are used by RadiantOne to connect via SSL to underlying data sources. Therefore, the appropriate client (public key) certificate (associated with the server certificate of the backend) needs imported into the Client Certificate Trust Store (unless they are signed by a trusted/known Certificate Authority).

RadiantOne loads all client certificates from the default Java truststore (<RLI_HOME>/jdk/jre/lib/security/cacerts) when it starts. Then, it dynamically loads all other certificates from the Client Certificate Trust Store. This allows client certificates to be dynamically added at any time without needing to restart the RadiantOne service. When RadiantOne is deployed in a cluster, all nodes share the contents of the Client Certificate Trust Store.

>[!note] It is not recommended to import client certificates into the default Java truststore (<RLI_HOME>/jdk/jre/lib/security/cacerts) since this is overwritten each time there is a RadiantOne patch that requires a Java update and requires a restart of the RadiantOne service every time you add new certificates. For these reasons, it is recommended to use the RadiantOne Client Certificate Trust Store instead.

Import client certificates into the truststore from the Main Control Panel > Settings Tab > Security section > Client Certificate Truststore. Certificates can be viewed, imported, exported or deleted from here.

>[!warning] when RadiantOne is deployed in a cluster, the public key associated with each server node must be stored in the client certificate truststore if you want the nodes to be able to communicate with each other over SSL. Keep this in mind if you ever change the server certificates on any of the cluster nodes.

## Viewing Client Certificates

To view a certificate, select the certificate in the list and click **View**. Valuable information about the certificate is shown (who issued the certificate, who the certificate was issued to, when the certificate is set to expire, status…etc.).

### Adding Client Certificates

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

>[!note] If RadiantOne is deployed in a cluster, all nodes share the contents of the client certificate truststore.
