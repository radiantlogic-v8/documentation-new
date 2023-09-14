# Kafka Connector 

The RadiantOne Kafka capture connector leverages the Apache Kafka Consumer API to subscribe to topics and process streams of records produced by them. The RadiantOne Kafka apply connector leverages the Apache Kafka Producer API to publish a stream of records to one or more Kafka topics.

The Kafka capture and apply connectors are independent, meaning that they do not need to be deployed together. The source(s) and target(s) could be any combination of Kafka topics, LDAP-accessible data stores, JDBC-accessible data stores, or web-services (SCIM or REST accessible).

This section assumes that you have Kafka installed and configured. Once you have installed and configured Kafka, follow the instructions in this section.

To sync between RadiantOne and Kafka topics, you need to configure the following. 

- [Properties file](#configuring-the-properties-files)
- [Data sources](#configuring-data-sources)
- [Schemas](#configuring-the-schema) 
- [Views](#mounting-the-virtual-view)
- [Sync topologies](#configuring-global-sync-as-a-kafka-consumer)

## Configuring the Properties File

You can configure the properties file either for unencrypted, anonymous connections, or for connections where encryption and authentication are required. This section describes how to configure both versions of the properties file.

### Configuring the Properties File for Unencryped Anonymous Connections

In a text editor, enter the path on your RadiantOne server containing the bootstrap.servers value with the name and port of your Kafka server. i.e. kafka.mycompany.com:9092.

![producer properties](media/producer-properties.jpg)

Figure 1: Producer.properties text file for unencrypted anonymous connections

### Configuring the Properties File for Encryption and Authentication

In cases where encryption and authentication are required, additional properties must be included in the producer.properties file.

In this example, PLAIN SASL is used to specify a username and password for authentication. Because the connection is encrypted, you must create a Java truststore containing the trusted CAs which issued the certificate used by the Kafka broker. The ssl.truststore.location needs to be the full path to the file on your RadiantOne server. It is recommended that you store both the producer.properties and truststore.jks file in your $RLI_HOME/vds_server/custom directory so that it replicates to follower nodes in your cluster.

![producer.properties file for encryption](media/producer-properties-encryption.jpg)

Figure 2: Producer.properties text file for a Kafka broker requiring encryption and authentication

>[!note] Once you start using your Kafka producer to publish to a Kafka topic in a Global Sync topology, any changes you make to the producer.properties file require that you restart the RadiantOne FID service.

## Configuring Data Sources

In this section, the producer and consumer data sources are created. 

### Configuring the Producer Data Source 

To configure the producer data source:

1. In the Main Control Panel, navigate to Settings > Server Backend > Custom Data Sources.

1. Click Add Custom.

1. Name the data source. In this example, the data source is named kafkaproducer. 

1. Under Custom Properties, click **Add**. 

1. Add each of the following properties and accompanying values. After you define a property, click OK and then click Add to start adding the next property until the properties in the table below are defined. 

  	|Property Name | Value|
    -|-
	Classname| KafkaApplyChangeEvent.java (this is built into the product)
	producer.properties.file | (the location of the properties file, i.e. $RLI_HOME/vds_server/custom/producer.properties).
	Topic name |(the name of the topic to which you wish to publish)
	Messageformat | (the name of the changeEventConvertor, such as GoldenGateJSONConvertor)

    ![kafka producer](media/kafka-producer.jpg)

    Figure 3: Configuring the Kafka Producer Properties File

1. Click Save. 

	>[!note] If a note displays stating that the connection to the data source failed, click Yes to save anyway. 

### Configuring the Consumer Data Source

A data source is also required for the Consumer connector, but the settings are configured within Global Sync itself and all settings for a Consumer data source are ignored.

1. In the Main Control Panel, navigate to Settings > Server Backend > Custom Data Sources.

1. Click Add Custom.

1. Name the data source. In this example, the data source is named kafkaconsumer. 

1. Click Save. 

	>[!note] If a note displays stating that the connection to the data source failed, click Yes to save anyway.

## Configuring the Schema

Based on the JSON messages you expect to process with your Kafka connector, you need to define appropriate schema.

1. In the Main Control Panel, navigate to the Context Builder tab.

1.	On the Schema Manager tab, click ![create schema](media/create-schema.jpg).

1.	Select **Custom** and click OK. 

1.	Select the Kafka data source you created in [Configuring the Producer Data Source](#configuring-the-producer-data-source) and click Next. 

1.	Enter a name for your Kafka schema. In this example, the schema is named kafkaexample.

1. Click **Create Schema**. The new schema is displayed. 

1.	In the pane on the left, expand the Objects node in the tree view. 

1.	Right click on Tables and click **Add New Object**. 

    ![add new object](media/add-new-object.jpg)

    Figure 4: Adding a new table

1.	Name the table and enter an LDAP Object Class name. In this example, the table is named **worker**. Click OK. 

1.	In the pane on the left, expand the table you created in the previous step.

1.	Right click on Fields and select **Add New Attribute**.

1.	Complete the Add New Attribute dialog box.

1.	Repeat the above step for all fields which will be processed through your Kafka connector. 

    ![kafka schema](media/kakfa-schema.jpg)

    Figure 5: Kafka Schema

1.	Click **Save**.

>[!note] If you use the same schema for both your consumer and producer, no further schema configuration is required. If you plan to use a different message format for publishing to Kafka, that schema must also be created.

## Mounting the Virtual View

In this section, a new naming context representing the incoming Kafka Consumer is added. If you plan to publish identity data to a Kafka topic, you will need a separate view.

1. In the Main Control Panel, navigate to the Context Builder tab. 

1.	On the View Designer tab, click ![create schema](media/create-schema.jpg).

1.	Name the view. In this example, the schema is named kafkaexample.

1. Select the schema you created in [Configuring the Schema](#configuring-the-schema). Click OK. 

1.	In the pane on the left, select the view’s folder icon and click New Content.

1.	Select your table name and click OK.

    ![new view definition](media/new-view-definition.jpg)

    Figure 6: New View Definition

1.	Make any updates you need for the RDN and Attribute settings.

    ![view with attributes](media/view-with-attributes.jpg)

    Figure 7: New View with Attributes

1.	Click Save. 

1.	Navigate to the Directory Namespace tab. 

1.	Click ![new naming context](media/new-naming-context.jpg). 

1.	Enter a context name, i.e. o=kafkaexample.

1.	Choose Virtual Tree and click Next.

1.	Select **Use an existing view**.

1. 	Click Browse. Navigate to the saved .dvx file for the view you created. Click OK.

1.	Click OK.

1.	Click OK to acknowledge the alert that your virtual tree has been created. 

If you’re configuring Global Sync to act as both a consumer and producer with Kafka, you need a separate mounted view with the appropriate schema.

## Configuring Global Sync as a Kafka Consumer

1.	In the Main Control Panel, navigate to the Global Sync tab. 

1.	Click ![new topology](media/new-topology.jpg).

1.	Select your source and destination naming contexts and click OK. 

1.	Click Configure. 

1.	Click the Capture tile and fill in the following fields. 

    Field Name | Description
    -|-
    Topic Name| The name of your topic (i.e. Workday).
    Kafka Consumer Properties |Contains bootstrap.servers= followed by the name and port number for your Kafka server. See note below for more information.
    Message Format |The name of your changeConvertor, such as GoldenGateJSONConvertor or KafkaExample (without .java on the end)
    Table Name | Required only if you are using KafkaGoldenGate formatting

    ![new topology](media/kafka-example.jpg)

    Figure 8: Capture connector properties using Kafkaexample changeConvertor

>[!note] The minimum requirement for the Kafka Consumer Properties field is the bootstrap.servers property specifying your Kafka broker and port number. The example shown above is for an unencrypted session without authentication. If your Kafka broker requires encryption and/or authentication, additional properties can be added to the field in a comma-separated list. For example, the same parameters shown in the example above for the producer.properties file would be entered as the following  string. <br> bootstrap.servers=kafka.mycompany.com:9094,sasl.mechanism=PLAIN,
security.protocol=SASL_SSL,ssl.truststore.location=/radiantone/vds/vds_server/custom/truststore.jks,sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="accountname" password="password";

>[!note] For encrypted Kafka connections, the same Java truststore requirement applies as above for the producer.properties; you must specify the full path via the ssl.truststore.location property. <br> <br> If you make changes to the Capture connector configuration once your pipeline has been started, you will need to stop and start the pipeline to pick up those changes.

1.	Click Save. 

1. 	Click the Transformation tile. Select a Transformation Type from the drop-down menu.

1. Expand the Mappings section and map attributes as required.

    ![sample mappings](media/sample-mappings.jpg)

    Figure 9: Sample Mappings

1. 	Click the Apply tile and start your pipeline. 

## Configuring Global Sync as a Kafka Producer

Global Sync uses the settings you configured for your kafkaproducer data source to call the correct changeConvertor, connect to your Kafka endpoint, and publish to the specified topic.

1. In the Main Control Panel, navigate to the Global Sync tab.

1.	Click ![new topology](media/new-topology.jpg).

1.	Select your Source and Destination naming contexts (i.e. the destination should be the kafkaproducer data source configured in [Configuring the Producer Data Source](#configuring-the-producer-data-source)) and click OK.

1.	Click **Configure**. 

    >[!note]Assuming you are using an HDAP source, nothing is required to be configured on the Capture tile.

1.	Click the Transformation tile and configure your mappings.

1.	Click the Apply tile and start the pipeline.
