---
title: Introduction to Schemas
description: Learn how to manage schemas.
---

## Overview

A schema file in RadiantOne Identity Data Management contains the metadata pertaining to objects in identity data sources. This metadata is the basis for configuring identity views. Each identity data source must have at least one schema file.

Schemas are managed from Control Panel > SETUP > Data Catalog > Data Sources > Selected data source > SCHEMA tab.

It is important to understand that RadiantOne publishes an LDAP schema for clients to query using a base DN of cn=schema. Some clients leverage this information to integrate with the service, while others do not. This schema likely differs from the schemas of the identity data sources (backends). Therefore, if you have client applications that rely on metadata published in the RadiantOne LDAP schema, ensure that you either [Map the Backend Metadata](#mapping-metadata) to objects and attributes in the RadiantOne LDAP schema, or [Extend the RadiantOne LDAP Schema](#Include-in-RadiantOne-LDAP-Schema) with the metadata from the schema files associated with the backends.

## Concepts

The following concepts are important to understand for managing schemas in RadiantOne Identity Data Management.

### Primary Key

In a well-designed relational database, every table has a column, or combination of columns, known as the primary key of the table. These values uniquely identify each row in the table. Occasionally you will find tables that were created in the database, but the uniquely identifying column(s) were not documented in the system catalog as the primary key. Declaring implicit primary keys is one of the schema refining processes you perform in the Data Catalog. 

>[!warning] All objects you want to virtualize in an identity view must have a primary key defined, and any attribute that you declare as the primary key in the schema file must be unique for all entries in your database source table.

In a directory, there is a notion of a “unique identifier” which is an attribute in each entry that uniquely identifies it from the sibling entries. This is not something that is explicitly documented in the directory schema; therefore, you must declare the primary key for the object class in the schema file. Typically, the unique identifier in the directory comprises the RDN. For example, if a user DN associated with the *person* object class were: uid=lcallahan,dc=ldap,dc=com, the unique identifier for the person object class would be the uid attribute.

The yellow key next to the name in the attributes list denotes it as the primary key for the object (see screen shot below). If no primary key is defined, you can use the right-click menu to edit/define one. For more information see [Declaring Primary Keys](#declaring-primary-keys). 
 
![An image showing ](../Media/ldap-pk.jpg)

### Display Name 

You can create a RDN Attribute and Value Name, or alias/display name, for a Primary Key. This allows the consumer browsing the directory to be shown more useful information. For example, if the Primary Key of a Customer table is CustID with an integer attribute type, then a list of numbers is displayed in the identity view at run time. Chances are, the person who created the database is the only one for whom those numbers mean anything. Therefore, a display name could be created using the customer’s first name and last name. Instead of the consumer of the identity view seeing a number, they now see a more meaningful customer name. The display name is a combination of the primary key and one or more attributes. Because it is comprised of the Primary Key, an RDN Attribute and Value Name is always unique and can qualify as a candidate key. For more information, see [Declaring RDN Attribute Name and Value](#declaring-rdn-attribute-name-and-value). 

### Derived View 

Derived views result from queries to a base object. These views are built by promoting one of the attributes of the base object to the entity level. Once the view is created, it is added into the schema file and this new relationship can be used to create more detailed, flexible views of information. 

For example, let’s say your database includes a table that lists Customers and related attributes, including Country. You can create a list of all countries in which you have customers. Derived views allow you to create a view that lists all applicable countries. Derived views contain summary data. For example, in the Customers.Countries derived view shown below all occurrences of one country are combined into one record. 

![An image showing ](../Media/Image3.2.jpg)

You can create derived views by using the right-click menu on the object that contains the attribute you want to create a derived view from. 

![An image showing ](../Media/derived-view-option.jpg)

For more information on derived views, see [Creating Derived Views](#creating-derived-views). 

### Relationships 

If relationships exist in a database and are not explicitly declared in the system catalog, then the schema extraction process does not capture them. Some relationships are created implicitly (exist in the application, but are not recorded within the database dictionary). This is fine if you do not need to build a virtual view based on the relationships. On the other hand, if you want to use the existing relationships to build virtual views, then you must define the relationships in the schema file. 

To evaluate missing relationships in the schema file, you need a working knowledge of the underlying database application on which the schema is based. Once you have determined which relationships are missing, you can declare them by using the Define Relationships option from the right-click menu available when an object is selected. For more information, see [Declaring Implicit Relationships](#declaring-implicit-relationships). 

### Recursive Relationships 

A recursive relationship is an object related to itself. For example, an employee may be managed by another employee. Therefore, an Employee table would have a recursive relationship with itself. Please see [Declaring Recursive Relationships](#declaring-recursive-relationships) to see how this can be accomplished with the Schema Manager. 

## Extracting Schemas
Each identity data source must have at least one schema file associated with it. For LDAP data sources, a schema is extracted when the data source is defined. For all other data sources, the schema must be extracted. If you select a data source that does not have any schemas, a notice appears and prompts the user to extract the schema.

![An image showing No Schemas Found Message ](../Media/no-schema.jpg)

Schemas can also be extracted using the **...** > Extract New Schema option.

![An image showing No Schemas Found Message ](../Media/extract-new-schema.jpg)

### LDAP-Accessible Backend 

Examples of LDAP-accessible backends are Sun Java Directory, Microsoft Active Directory, IBM Tivoli Directory, eDirectory, Red Hat Directory, and OpenLDAP. The LDAP data source must be created before completing the schema extraction steps below. See [Data Sources](/data-sources.md) for details about creating data sources.

1. In the Control Panel > SETUP > Data Catalog > Data Sources > Selected Data Source > SCHEMA Tab, click **...** > Extract New Schema.

1.	Enter a schema file name and click **OK**.

 ![An image showing ](../Media/extract-new-schema.png)

 >[!warning] DO NOT USE HYPHENS (-) IN FILE NAMES. 

1. You can view/modify this schema by selecting if from the drop-down list. Any changes made (such as attribute name remapping), do not affect the underlying schema. 

**Handling Auxiliary Object Classes from LDAP Backends** 

Sometimes, an LDAP entry in a directory is comprised of more than one object class where the object classes do not necessarily inherit from each other. This is referred to as an auxiliary class. For example, a person entry in the directory can be a part of an object class such as inetOrgPerson and also contain attributes from a custom object class like rliuser (this is the auxiliary class). During the schema extraction, since the object classes do not inherit from each other, they are displayed as two separate objects each having their own list of attributes. To retrieve the proper information from the directory in the virtual view, you must merge the objects together in the schema file. 

To merge object classes together: 

1.	 Right-click on the structured object class in the list and select Merge Objects. 

2.  Enter an object name for the merged object to be created.
  
3.	 Select the auxiliary object class from the list that you would like to merge with (RLIUser for example).

4.	Click **OK**. 

![An image showing ](../Media/define-merged-object.jpg)

A new object is created below the Views branch and contains all attributes from both object classes. A virtual view can be created from this merged object and the entries can contain attributes from either of the object classes. 

>[!warning] The direction in which you merge the objects is significant because the ‘base’ object (the structured object class) is used in the filter for the query that is sent to the backend directory. Note that the attributes defined for this merged object come from both the structured objectclass inetorgperson (uid, cn, displayName) and the auxiliary objectclass, RLIUser (rliuserattribute2, rliuserattribute3).

![An image showing ](../Media/example-merged-object.jpg)

### JDBC-Accessible Database Backend 

Examples of JDBC-accessible backends are Microsoft SQL Server, Oracle, DB2, and Sybase. 

The database data source must be created before completing the schema extraction steps below. See [Data Sources](/data-sources.md) for details about creating data sources.
1.	In the Control Panel > SETUP > Data Catalog > Data Sources > Selected Data Source > SCHEMA Tab, click **...** > Extract New Schema.

1.	Enter a schema file name and click **OK**.
    >[!note] DO NOT USE HYPHENS (-) IN FILE NAMES.
 
1. The ANSI standard syntax for naming relational database tables is catalog.schema.table. Therefore, if you are authenticating as a user who has access to multiple different schemas, and want to narrow the search, you can enter in the specific schema name in the Database Schema property.

1.	Limit the types of objects to be returned by selecting tables, views, system tables, or synonyms. If you would like all types of objects returned, then select all options. If you only want a subset of the selected objects returned, then you can enter a pattern for the Table Pattern parameter using the “%” for a wildcard character. For example, if you want to return only tables that start with “N”, then for the Table Pattern you can enter N%.

1.	Click **NEXT** to proceed and select the desired Tables and Views from the list.
 
![An image showing ](../Media/Image3.11.jpg)

1.	Click **EXTRACT**. This creates the schema file and adds it into the drop-down list next to *Schema Name*.

You can view/modify this schema by selecting if from the drop-down list. Any changes made (such as declaring primary keys or creating relationships), do not affect the underlying schema. 

### SCIMv2 Backends

The SCIMv2 data source must be created before completing the schema extraction steps below. See [Data Sources](/data-sources.md) for details about creating data sources.

1.	 In the Control Panel > SETUP > Data Catalog > Data Sources > Selected Data Source > SCHEMA Tab.

1.	 In the upper-right corner, click **...** > Extract New Schema.

1.	 Enter a schema file name and click OK. This creates the schema file and adds it into the drop-down list next to *Schema Name*.

      >[!note] DO NOT USE HYPHENS (-) IN FILE NAMES.
      
You can view/modify this schema by selecting it from the drop-down list. Any changes made do not affect the underlying schema.

### Custom Backends

The custom data source must be created before completing the steps below. See [Data Sources](/data-sources.md) for details about creating data sources. The schemas associated with custom sources cannot be extracted. You must manually define the objects and attributes matching the custom data source API after providing a schema name. Every object (e.g. user) that stores identity data must be defined.

1.	 In the Control Panel > SETUP > Data Catalog > Data Sources > Selected Data Source > SCHEMA Tab, click **...** > Extract New Schema.
1.	 Enter a schema file name. Click OK.

      >[!note] DO NOT USE HYPHENS (-) IN FILE NAMES.

1.  Expand Objects.
1.  Right-click on *Tables* and choose **Add New Object**.

1.  Enter an object name and an (optional) LDAP object class to associate with it.
1.  Click OK.
1.  Repeat steps 3-6 to add all objects. 
1.  Expand below *Tables* to see the new object. Right-click on the object and choose **Add New Attribute**.
2.  Repeat step 8 to add all attributes.
   
## Managing Schemas

### Displaying Objects and Relationships 

When you select a schema file next to the *Schema Name* drop-down list, the objects are displayed in alphabetical order. Objects are tables and views (for databases), or object classes (for LDAP directories). As you select an object, information about that object appears on the right side.

>[!note] 
>If you select the Fields (for database objects) or Attributes (for LDAP objects) node (below a specific object) the Nullable column on the right side indicates which attributes are required. Attributes that have a ‘false’ value in the Nullable column are required. Attributes that have a ‘true’ value are optional. This is important to know if you want to insert users into the backend. Make sure that all required attributes are populated for the new entry or else the insert operation will fail in the underlying source.

Relationships between database objects are displayed below the relationships node. 

The figure shown below displays all tables, views and relationships from the sample Northwind schema file installed with RadiantOne. Notice that the top level is the name of the file followed by a section named Objects. When the objects node is selected, the Properties tab on the right side displays important summary information. A blue icon designates Tables. A green icon designates Views, and Relationships are designated by the relationship icon (two connected tables). 
 
![An image showing ](Media/Image3.5.jpg)


### Declaring Primary Keys

Once the metadata has been captured, the next step is to improve it in a way that best serves your needs. This may involve declaring primary keys.

>[!note] Changes made in the schema settings do not affect the underlying schema.

Primary keys that are implicit, but not declared in the data dictionary, are not included in schema files unless you declare them. 

>[!warning] All objects you want to create virtual views from must have a primary key defined, and any attribute that you declare as the primary key in the schema file must be unique for all entries in your table.

For directory schemas, declare the attribute that uniquely identifies each entry as the primary key. 

To declare and modify the primary keys: 

1.	 Right-click on the desired object and choose Edit Primary Key. 

![An image showing ](../Media/edit-primary-key.jpg)

1.	 Choose the column(s) from the Attributes List that you want to use as the primary key and click the right arrow button. 

1. 	To remove the column(s) from the key(s) list, choose the column(s) and click the left arrow button. 

![An image showing ](../Media/set-primary-keys.jpg)
 
1. 	Click **OK** when finished. The key(s) you selected are now declared as the primary key. 

### Declaring Implicit Relationships

Once the metadata has been captured, the next step is to improve it in a way that best serves your needs. This may involve declaring implicit relationships.

>[!note] Changes made in the schema file do not affect the underlying schema.

Sometimes a database schema does not contain all relationships that can exist between objects. The schema extraction process cannot capture these implicit relationships that are known by the programmers but not declared in the database data dictionary. You should declare any relationships you will need for your virtual views. 

The declaration process is a critical step as it affects the quality of the virtual views that are created. Any undeclared relationships or primary keys result in a meaningless path, directly affecting the quality or availability of information displayed in the virtual views.

The Relationships dialog box requires source and destination tables (or views). When setting relationships, it does not matter which entity is the source and which is the destination. 

>[!note] Declaring implicit relationships relates to database schemas only.

To set a relationship between two objects:

1.	Right-click on the desired object and choose the Define Relationships option. The Relationships dialog box appears. 

![An image showing ](Media/Image3.15.jpg)

2.	Select the Relationship Type. Choose *Regular* for relationships across unique objects and *Recursive* for an object that has a relationship with itself.
3. Select an object from the Source Object drop-down list.
4. Select the attribute from the Source Attribute drop-down list that contains the value to be used to relate to the secondary object.
5.	Select the destination object that has a relationship with the source object from the Related Object drop-down list. 
6.	Choose the attribute from the Related Attribute drop-down list that contains the value to be used to relate to the source object. 

![An image showing ](Media/definerelationships.jpg)

7.	Click **OK**. The relationships are created and appear at the bottom of the list of relationships in the schema file.

### Declaring Recursive Relationships

Once the metadata has been captured, the next step is to improve it in a way that best serves your needs. This may involve declaring recursive relationships.

>[!note] Changes made in the schema settings do not affect the underlying schema.

If a table has a relationship to itself, the Schema Manager can be used to establish this recursive relationship. 

To create a recursive relationship: 

1.	Right-click on the object that has a recursive relationship and select Define Recursive Relationship. 

![An image showing ](Media/Image3.16.jpg)

2.	Select the foreign key and enter the number of recursions possible (the depth level).

![An image showing ](Media/Image3.17.jpg)

3.	Click OK.

You should now see new views created corresponding to the depth level entered, and new relationships between these objects.

![An image showing ](Media/Image3.18.jpg)

Once the recursive relationship is described in the schema file, a hierarchical virtual directory view can be created. For details on how to build virtual views, please see [View Designer](view-designer.md). 

>[!note] If you do not know the depth of recursion, there is a way to build a virtual view without first defining the recursive relationships in the Schema Manager. For detailed steps, please see the article titled Building a Hierarchical Virtual View Based on Recursive Relationships in a Database in the RadiantOne Knowledge Base at: https://support.radiantlogic.com. You will need a user ID and password for accessing the knowledge base. If you do not have one, please contact Radiant Logic at support@radiantlogic.com.

### Creating Synonyms

Once the metadata has been captured, the next step is to improve it in a way that best serves your needs. This may involve declaring synonyms. 

>[!note] Changes made in the schema settings do not affect the underlying schema.

For flexibility in modeling virtual views, you can create a synonym from any object in the schema. A synonym is a complete replica of the object with a new name. 

To create a synonym for an object: 

1.	Right-click on the object and select Define Synonym.

![An image showing ](Media/Image3.19.jpg)

2.	Enter a name for the Synonym when prompted. 

>[!note] Synonyms may NOT have the same name as an existing object in the schema.

![An image showing ](Media/Image3.20.jpg)

The new object appears under the list of Views. This new object does not change the underlying schema but can be used when building virtual views. For details on building custom virtual views, please see [View Designer](view-designer.md). 

### Declaring RDN Attribute Name and Value

Once the metadata has been captured, the next step is to improve it in a way that best serves your needs. This may involve defining RDN attribute name and values. 

>[!note] Changes made in the schema settings do not affect the underlying schema.

RDN Attribute Name and Display Columns are a combination of the primary key and at least one other attribute. You can also declare RDN Attribute Name and Display Columns using the View Designer, see Declaring an RDN Attribute Name and Value for more details.

To declare or Modify RDN Attribute Name and Value: 

1.	Right-click on the desired table or view and choose the Edit RDN option. 

2.	Enter an RDN Name (the value that comprises the DN) and select the attributes that you want to comprise the RDN value (remember that these attributes are used in addition to the primary key). 

3.	Click Apply when finished. 

![An image showing ](Media/Image3.21.jpg)

>[!warning] The attributes that you select as the display attribute(s) should not allow NULL values.

To remove attribute(s) from the RDN Display Attribute(s) list, choose the column(s) and click the left arrow button. 

This RDN attribute name becomes the default name (for a container or content object) when the corresponding object is used to build a virtual view in the View Designer. 

For example, if you set the RDN attribute name for the Employee table to equal Name, then when you access the Employee table to create a container or content level in the View Designer, the default RDN attribute name for that specific level will be Name. The RDN will be Name = First Name Last Name {Employee Primary Key value}. An example of this is shown in the screen shot below. 

![An image showing ](Media/Image3.22.jpg)
 
### Removing Objects, Attributes or Relationships from the Schema 

Unwanted tables, views, attributes, or relationships can be removed from the schema. Remember to save the schema after making any changes. 

**Removing Objects**

Objects in a database schema are tables or views. Objects in an LDAP schema are object classes. Right-click on the desired object and choose Delete. 

>[!note] If any of the objects are involved in a relationship, the corresponding relationship must be removed first.

![An image showing ](Media/Image3.23.jpg)

**Removing Attributes**

Some attributes can be removed from objects. Primary keys and attributes involved in relationships cannot be removed. Right-click on the attribute you want to remove and choose Delete. 

![An image showing ](Media/Image3.24.jpg)
 
**Removing Relationships**

To remove a relationship, right-click on the desired relationship and choose Delete. 
 
![An image showing ](Media/Image3.25.jpg)
 
### Creating Derived Views

Derived views are created from a base table and consist of one attribute that contains normalized data, such as a single column table for countries, postal codes, city names, etc. Derived views are objects that are added to the schema file to allow for more flexibility when creating virtual views. 

See [Derived View](#derived-view) in the Schema Manager basic terms for more information. 

To create a derived view, follow the steps below. 
1.	Right-click on a table or view and select **Define Derived View**. 
2.	Select the appropriate object from the drop-down list. 
3.	Select the column you want to use and click **OK**.

![An image showing ](Media/Image3.26.jpg)

The new derived view object appears in the list of views in the Schema Manager tab. This new object can be used when building virtual views in the [View Designer](view-designer.md). 

>[!note] A derived view may NOT be created from the same attribute twice.

### Mapping Metadata 

Mapping metadata into a common vocabulary is essential for facilitating a global search. Clients searching the RadiantOne service should be able to use one common naming structure to locate information no matter which backend source the data resides. This can only be achieved by properly mapping the metadata. 

Default LDAP object classes and attributes are generated for all database objects. This default object class is comprised of a “vd” prefix, followed by the name of the database (and/or schema/owner), and the name of the database object. The object class assigned to the database object is stored as an LDAP Object Class property in the schema file. The default attributes are based on the attribute names as they exist in the database. 

In the example shown below, the LDAP object class generated by default is vdAPPCUSTOMERS. The attribute names in the entries built from the database schema matches the names as they exist in the database. 

![An image showing ](Media/Image3.27.jpg)

For LDAP backends, the object class(es) from the schema definition is the default value shown in the Schema Manager. The # sign is used to separate the class hierarchy. The default attribute names also match the underlying schema definition. 

![An image showing ](Media/Image3.28.jpg)

The default object class can be changed if needed. Database and LDAP objects can be mapped to an existing object class definition or you can manually enter your own custom one.

### Mapping Database Objects to LDAP Object Classes and Attributes

1.	Open the database schema containing the objects you want to map in the Schema Manager tab. 

2.	Right-click on the database object you want to map and choose Object Mapping. 

![An image showing ](Media/Image3.29.jpg)

3.	Select the object class from the drop-down list that you want mapped to the database object. 

4.	When mapping database columns to LDAP attributes, you can map each attribute individually based on the object class definition selected in step 3 or manually enter your own mapped attribute name. To map to an existing LDAP attribute, select the corresponding LDAP attribute from the drop-down list. The attribute list is based on the definition of the LDAP object class selected in step 3. In the example shown in the screen shot below, inetOrgPerson has been selected and two attributes have been mapped to LDAP attributes of the inetOrgPerson class. 

![An image showing ](Media/Image3.30.jpg)

5.	If you prefer to enter your own custom object class name, you can type it in the LDAP Object Class parameter. 

6.	If you prefer to enter your own custom attribute names, type them in the LDAP attribute parameter next to the database attribute name.

7.	Click OK when finished. 

### Mapping LDAP Objects to New Object Classes and Attributes

To map LDAP object classes and attribute to other LDAP object classes and attributes:

1.	Open the LDAP schema containing the object classes you want to change the mapping for in the Schema Manager tab. 

2.	Right-click on the LDAP object class you want to map and choose Object Mapping. 

3.	Select the object class from the drop-down list that you want to map to. 

4.	When mapping attributes, map each attribute individually based on the object class definition selected in step 2 or manually enter your own mapped attribute name. To map to an existing LDAP attribute, select the corresponding LDAP attribute from the drop-down list. The attribute list is based on the definition of the LDAP object class selected in step 2. In the example shown in the screen shot below, inetOrgPerson has been selected and two attributes have been mapped to LDAP attributes of the inetOrgPerson class.

5.	If you prefer to enter your own custom object class name, you can type it in the LDAP Object Class parameter. 

6.	If you prefer to enter your own custom attribute names, type them in the LDAP attribute parameter next to the source attribute name.

7.	Click **OK** when finished. 

### Merging Schema Files

Merging schema files is helpful if you have extracted and enhanced (declared keys, relationships, mapping…etc.) a very large schema and you need to bring in new objects from that same server. You can extract just these new objects and merge them with the existing schema. This saves time over having to extract and enhance the entire schema again. 

To merge schema files:

1.	Extract the new objects on the Schema Manager tab. 
2.	Open the existing schema file in Schema Manager. 
3.	Right-click at the top node of the schema and choose Merge with Other Schema. 

![An image showing ](Media/Image3.34.jpg)

4.	Browse to the schema file that you extracted/saved in step 1 above. 

5.	Check the objects you want to merge with the schema. You can use Select All to save time if there are many. Click OK. 

6.	The newly merged objects appear in the opened schema. 

7.	Save the schema file. 

## Deleting Schema Files 

Schema files should be deleted from the Control Panel. 

To delete a schema file: 

1. In the Control Panel, navigate to SETUP > Data Catalog > Data Sources. 

2. Select a data source. 

3. Click the data source's Schema tab.

4.	From the Options menu ("..."), select *Delete Schema*. 

![An image showing ](Media/Image3.36.jpg)

5.	Click *Delete* to confirm the deletion. 

## Comparing Schema Files

## Include in RadiantOne LDAP Schema
