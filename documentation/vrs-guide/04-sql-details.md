---
title: VRS Guide
description: VRS Guide
---

# SQL Details

The following section describes the SQL supported statements, clauses, syntax and limitations of the VRS driver. Also included are some sample select, insert, update and delete statements.

## Statements and Supported Clauses

Statement | Syntax & supported SQL clauses
-|-
SELECT | SELECT [ALL &#124; DISTINCT] {column name&#124; aggregation&#124; expression} [AS remapping name] [, {column name&#124; aggregation &#124; expression} [AS remapping name]] <br> FROM Table name <br>[ [ [ LEFT&#124;RIGHT [OUTER] ] &#124; [INNER] ] JOIN Table name [ON conditions &&#124; predicates]<br>&#124; [, Table name 2 [, Table name n]] ] <br> [WHERE conditions &&#124; predicates] <br>[GROUP BY column name] <br>[ORDER BY column name [DESC/ASC]]
INSERT | INSERT INTO Table name [(column name [,column name 2 [,column name n]])] <br>VALUES (`<expressions value>`)
UPDATE | UPDATE Table name <br>SET column name = expressions value [, column name 2= expressions value [, column name n= expressions value]] <br>[WHERE predicates]
DELETE | DELETE FROM Table name <br>[WHERE predicates]
CREATE | CREATE VIEW View name AS SELECT STATEMENT
DROP | DROP VIEW View name

>[!note] 
>An expression in a select statement can be a numeric value or anything delimited with simple quote.**
 
## SQL 92 Identifiers

Delimited identifiers are identifiers surrounded by double quotation marks. A delimited identifier can contain any characters.

Column name syntax:

[{table name | correlation name}.] column name

Table name syntax:

```
[schema name .] table [correlation name]
```

>[!note] 
>Correlation name means alias. Schema name is either vds (for LDAP mode) or vcs (for Context mode).

## Schema

-	Catalog: no catalog.

-	Schema: In Context Mode, the schema name is vcs. In LDAP mode, the schema name is vds. For more information on these two types of modes, please see [Client Options](03-jdbc-client-settings#client-options).

The objects (tables) returned in the schema are the same whether you are using context or ldap mode and is based on the LDAP schema that is defined for the RadiantOne service. To view the LDAP schema, use the Main Control Panel -> Settings Tab -> Configuration section LDAP Schema node. The only difference between the schema returned in context mode and LDAP mode is at the level of the attributes. In context mode, each object (table) has the contextid and parentcontext attributes and in LDAP mode, each object (table) has the dn attribute.

>[!warning] 
>If you are using computed attributes, or attributes that have been remapped to a name that is not defined as an attribute in the RadiantOne LDAP schema, you cannot access them in SQL queries. You must define an attribute in the RadiantOne LDAP schema with the same name as the computed/remapped attribute before you can access them in VRS. For more information on computed attributes and the LDAP schema, please see the RadiantOne System Administration Guide.

-	Tables: There is a special table in the schema named context. This table is defined with all the possible columns from the RadiantOne service and allows SQL results from any object in RadiantOne. It is a join and union of all columns from the RadiantOne LDAP schema. In addition to the context table, there is one table per objectclass defined in the RadiantOne LDAP schema. All these tables are a projection (or a view) on the context table.

-	Columns: The primary key defined for each table depends on which mode VRS is using to access the RadiantOne service. In LDAP mode, the primary key of the tables is the dn attribute. In Context mode (which is the default mode), the primary key is contextid and a foreign key named parentcontext. For more information on these two types of modes, please see [Client Options](03-jdbc-client-settings#client-options). All other columns defined for the table are based on the attributes owned or inherited by the object class.

-	Data Types: The data types currently used by VRS are varchar, integer and binary.

## VRS Queries Translated to RadiantOne Queries

This section details some important aspects about how queries to VRS are translated into LDAP requests to the RadiantOne service.

### Select Queries

-	Columns requested in the select query to VRS become the attributes requested in the ldap search to the RadiantOne service.

-	The table name(s) and columns used in the VRS query filter translate into the LDAP filter sent to the RadiantOne service.

-	Select queries to VRS are translated into subtree search requests to the RadiantOne service starting from the context (if any) specified in the JDBC connection. However, it is possible to change the operation’s context in the where clause of the select statement if needed. The syntax required varies depending on the [mode](03-jdbc-client-settings#mode) used to connect to the RadiantOne service and each is described below.

The following examples result in a subtree search below a branch in the RadiantOne namespace named ou=Accounting,o=companydirectory:

```
ldap://vds:2389/ou=Accounting,o=companydirectory?cn,mail,uid?sub?(objectclass=inetOrgPerson)
```

LDAP Mode – prefix the dn in the where clause (using LIKE) with % as shown in the example below. This gives you a subset of the inetOrgPerson table (all entries found below and including ou=Accounting,o=companydirectory will be returned).

```
SELECT dn,cn,mail,uid FROM inetorgperson WHERE dn LIKE '%ou=Accounting,o=companydirectory'
```

Context Mode - append % to the contextid in the where clause (using LIKE) as shown in the example below. This gives you a subset of the inetOrgPerson table (all entries found below and including ou=people,o=mycompany will be returned).

```
SELECT cn,mail,uid FROM inetorgperson WHERE contextid LIKE 'o=companydirectory/ou=Accounting%'
```

>[!note] 
>Ending the contextid value with /% will tell VRS to ignore the current context, meaning that the parent/base entry will not be included in the result set. Below is an example of a select statement using this syntax: 
SELECT cn,mail,uid FROM inetorgperson WHERE contextid = 'o=mycompany/ou=people/%'

The following examples results in a one level search below a branch in the virtual namespace named ou=Accounting,o=companydirectory.

LDAP Mode – prefix the dn in the where clause (using LIKE) with %, as shown in the example below. This gives you a subset of the inetOrgPerson table (only those entries found ONE level below ou=Accounting,o=companydirectory).

```
SELECT dn,cn,mail,uid FROM inetorgperson WHERE dn LIKE '%,ou=Accounting,o=companydirectory'
```

Context Mode – To issue a one level search in context mode, use the parentcontext attribute in the where clause (using LIKE) as shown in the example below. This gives you a subset of the inetOrgPerson table (only those entries found one level below ou=Accounting,o=companydirectory).

```
SELECT cn,mail,uid FROM inetorgperson WHERE parentcontext = 'o=companydirectory/ou=Accounting'
```

>[!note] 
>Multi-value attributes are returned by the RadiantOne service as one column, with each value separated by ' # '.

Please see [Sample VRS Queries](#sample-vrs-queries) for more examples.

### Insert Queries

-	All insert queries sent to VRS must contain the primary key column. Remember, if accessing the RadiantOne service in LDAP mode, the primary key is dn. If accessing the RadiantOne service in Context mode, the primary key is contextid.

-	If the objectclass is omitted in the insert query to VRS, it is automatically added with the 'top' objectclass and the tablename when the LDAP insert is sent to the RadiantOne service. If the objectclass is given, VRS checks that the 'top' objectclass and the tablename are present otherwise they are added to the LDAP insert sent to the RadiantOne service.

-	The objectclass column must be present in any insert statements sent to VRS for the 'context' table. Otherwise, VRS throws an SQLException to the jdbc client and not send the insert to the RadiantOne service.

Please see [Sample VRS Queries](#sample-vrs-queries) for examples.

### Update Queries

Any update query sent to VRS is translated automatically to an LDAP modification (ADD, REPLACE, REMOVE) when sent to the RadiantOne service.
Please see [Sample VRS Queries](#sample-vrs-queries) for examples.

## Sample VRS Queries

### SELECT

Return all entries from the inetOrgPerson table with the following attributes: dn, cn, mail, and uid:

```
SELECT dn, cn, mail, uid FROM inetorgperson 
```

Return all entries from the inetOrgPerson table that have a uid attribute starting with the letter a. Return the following attributes for these entries: dn, cn, mail, and uid:

```
SELECT dn,cn,mail,uid FROM inetorgperson WHERE uid LIKE 'a%'
```

Return all entries from the inetOrgPerson table that have a uid attribute starting with the letter a. Return the following attributes for these entries: dn, cn, mail, uid, sn with an alias of LastName, and givenName with an alias of FirstName:

```
SELECT dn,cn,mail,uid,sn AS "LastName", givenname AS FirstName FROM inetorgperson WHERE uid LIKE 'a%'
```

Return all attributes for all entries from the inetOrgPerson table that have a uid attribute starting with the letter a. 

```
SELECT * from inetorgperson where uid like 'a%'
```

Return the dn attribute for all entries in the Context table that have an objectclass attribute value of inetorgperson or groupofnames. 

```
SELECT dn from context where (objectclass=inetorgperson) OR (objectclass=groupofnames)
```

Return a summary (total count) for the different possible values of “l” from entries in the inetorgperson table that are located below the o=enterprisecontext context. 

```
SELECT l,count(*) FROM inetOrgPerson WHERE dn Like '%o=EnterpriseContext' GROUP BY  l
```

HR is the alias of the table inetorgperson in the context ou=Human Resources. PAY is the alias of the table inetorgperson in ou=Payroll context. This select statement does a join between these two datasets based on the mail column that is common between the two. HR and PAY are just two aliases in the sql query. It's necessary here because we are using the same table (inetorgperson) but they are pointing to two different datasets.

```
SELECT HR.dn,PAY.dn FROM inetOrgPerson HR, inetOrgPerson PAY 
WHERE HR.dn Like '%,ou=Human Resources, o=EnterpriseContext' AND PAY.dn Like '%,ou=Payroll,o=EntrepriseContext' AND PAY.mail=HR.mail
```

### INSERT

Insert an entry identified by a dn of “uid=Nico,ou=dev,o=radiantlogic.com” into the inetorgperson table with a uid value of “Nicog”, a cn value of “Nico Guyot” and a telephone number of “555-555-5555”.

```
INSERT INTO inetorgperson (dn,uid,cn,telephonenumber) VALUES ('uid=Nico,ou=dev,o=radiantlogic.com','Nicog','Nico Guyot','555-555-5555')
```

Insert an entry identified by a dn of “c=Sweden,dc=se” into the country table. Since the attribute names to insert are not specified in the insert statement, the order is based on the metadata for the country table. In this example, the first attribute is dn (‘c=Sweden,dc=se’), followed by c (‘Sweden’), searchguide (empty), description (‘The country of Sweden’), and objectclass (‘top’) respectively.

```
INSERT INTO country VALUES ('c=Sweden,dc=se','Sweden','','The country of Sweden','top')
```

### UPDATE

Update the telephone number for the user in the inetOrgPerson table identified by the dn of “uid=Nico,ou=dev,o=radiantlogic.com”:

```
UPDATE inetorgperson SET telephonenumber='555-888-8888' WHERE dn='uid=Nico,ou=dev,o=radiantlogic.com'
```

Update the facsimileTelephoneNumber and description column for all entries in the ou=hr container in the “mycompany” context:

```
UPDATE inetorgperson SET facsimileTelephoneNumber='555-555-8888', description='mycompany's employee' WHERE dn LIKE '%ou=hr,o=mycompany'
```

Set the telephonenumber to '555-888-8888' for all entries in the inetorgperson table where sn='Guyot':

```
UPDATE inetorgperson SET telephonenumber='555-888-8888' WHERE sn='Guyot'
```

Remove all telephonenumbers in the inetorgperson table:

```
UPDATE inetorgperson SET telephonenumber=null
```

### DELETE

Accessing the RadiantOne service in LDAP mode (because ‘dn’ is used in the query), delete the entry from the inetorgperson table identitied by a dn value of “uid=name,ou=hr,o=mycompany”:

```
DELETE FROM inetorgperson WHERE dn='uid=name,ou=hr,o=mycompany'
```

Accessing the RadiantOne service in context mode (because ‘contextid’ is used in the query), delete the entry from the inetorgperson table identitied by a dn value of “uid=name,ou=hr,o=mycompany”:

```
DELETE FROM inetorgperson WHERE contextid='o=mycompany/ou=hr/uid=name'
```

Accessing the RadiantOne service in LDAP mode (because ‘dn’ is used in the query), delete the object from the Context table identified by a dn value of “uid=name,ou=hr,o=mycompany”:

```
DELETE FROM context WHERE dn='uid=name,ou=hr,o=mycompany'
```

Accessing the RadiantOne service in LDAP mode (because ‘dn’ is used in the query), delete all rows in any table that contains a dn attribute with a suffix of “ou=hr,o=mycompany”:

```
DELETE FROM context WHERE dn LIKE '%ou=hr,o=mycompany'
```

Accessing the RadiantOne service in Context mode (because ‘contextid’ is used in the query), delete all rows in any table that contains a contextid attribute with a suffix of “o=mycompany/ou=hr”.

```
DELETE FROM context WHERE contextid LIKE 'o=mycompany/ou=hr% '
```

Delete all rows of any table which have the column sn that begins with “on”.

```
DELETE FROM context WHERE sn like 'on%'
```

## Limitations

VRS currently has the following limitations.

1.	No sub-queries (nested queries) are allowed.

2.	Delimited identifiers can be used through VRS only when the remote backend accept the double quotation marks as identifiers delimiter.

3.	IN clause not yet supported (this limitation can be bypassed with OR).

4.	Embedded SQL is not supported.

## Joins

VRS currently supports the join operations described in the table below.

SQL Clause | JOIN TYPE | Syntax
-|-|-
WHERE clause | Inner Join | FROM <br>Table name T1,table name 2 T2,… <br>WHERE <br>T1.columnName=T2.columnName <br>….
JOIN clause | Inner Join <br> <br> <br><br>Outer Join | FROM main table name <br> [INNER] JOIN table name ON Conditions<br> <br><br>FROM main table name <br> LEFT [OUTER] JOIN table name ON Conditions<br> RIGHT [OUTER] JOIN table name ON Conditions

## Union

Syntax : {Select statement} UNION [ALL] {Select statement} [UNION [ALL] {Select statement}] […]

UNION: builds a ResultSet with all of the rows returned from both queries and eliminates the duplicate rows.

UNION ALL: returns all rows from both queries as the result.
The number of columns on each query used in the UNION must be the same (or use expression for missing columns).

## Special Characters and Case Sensitivity

Single quotation marks delimit character strings.

Within a character string, use 2 single quotation marks to represent a single quotation mark or apostrophe.

SQL keywords are case-insensitive.

`*` is the wildcard character.

% is the character wildcard within a string expression that follows a LIKE operator.

## Support Functions and Aggregates

In some cases, using computed attributes in the virtual view can work as an alternative to using a SQL expression. For details on computed attributes, see the RadiantOne System Administration Guide.

If computed attributes are inadequate and you need to support classic functions and aggregates, it is advised to synchronize the entries that are staged (cached) in RadiantOne into a relational database of your choice and then issue the needed SQL queries against this database. This approach is more efficient and bypasses the need to translate the SQL expression into an LDAP call. The synchronization could be configured using the RadiantOne Global Sync module. For details on synchronizing from LDAP to a database, please see the RadiantOne Global Sync Guide.

## Type Conversion Supported in the Cast Function

Types | S<br>M<br>A<br>L<br>L<br>I<br>N<br>T | I<br>N<br>T | B<br>I<br>G<br>I<br>N<br>T | D<br>E<br>C<br>I<br>M<br>A<br>L | R<br>E<br>A<br>L | D<br>O<br>U<br>B<br>L<br>E | F<br>L<br>O<br>A<br>T | C<br>H<br>A<br>R | V<br>A<br>R<br>C<br>H<br>A<br>R | L<br>O<br>N<br>G<br>V<br>A<br>R<br>C<br>H<br>A<br>R | C<br>H<br>A<br>R <br>F<br>O<br>R B<br>I<br>T D<br>A<br>T<br>A | V<br>A<br>R<br>C<br>H<br>A<br>R<br>F<br>O<br> R B<br>I<br>T D<br>A<br>T<br>A | L<br>O<br>N<br>G V<br>A<br>R<br>C<br>H<br>A<br>R<br>F<br>O<br>R B<br>I<br>T D<br>A<br>T<br>A | C<br>L<br>O<br>B<br> | B<br>L<br>O<br>B | D<br>A<br>T<br>E | T<br>I<br>M<br>E | T<br>I<br>M<br>E<br>S<br>T<br>A<br>M<br>P | X<br>M<br>L
-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-     
SMALLINT | Y | Y | Y | Y | Y | Y | Y | Y | N | N | N | N | N | N | N | N | N | N | N
INT	 | Y | Y | Y | Y | Y | Y | Y | Y | N | N | N | N | N | N | N | N | N | N | N
BIGINT | Y | Y | Y | Y | Y | Y | Y | Y | N | N | N | N | N | N | N | N | N | N | N
DECIMAL	| Y | Y | 	Y | Y | Y | Y | Y | Y | N | N | N | N | N | N | N | N | N | N | N
REAL | Y | Y | Y | Y | Y | Y | Y | N | N | N | N | N | N | N | N | N | N | N | N
DOUBLE | Y | Y | Y | Y | Y | Y | Y | N | N | N | N | N | N | N | N | N | N | N | N
FLOAT | Y | Y | Y | Y | Y | Y | Y | N | N | N | N | N | N | N | N | N | N | N | N
CHAR | Y | Y | Y | Y | N | N | N | Y | Y | Y | N | N | N | Y | N | Y | Y | Y | N
VAR-<br>CHAR | Y | Y | Y | Y | N | N | N | Y | Y | Y | N | N | N | Y | N | Y | Y | Y | N
LONG <br>VARCHAR | N | N | N | N | N | N | N | Y | Y | Y | N | N | N | Y | N | N | N | N | N
CHAR FOR BIT DATA | N | N | N | N | N | N | N | N | N | N | Y | Y | Y | Y | Y | N | N | N | N
VARCHAR FOR BIT DATA | N | N | N | N | N | N | N | N | N | Y | Y | Y | Y | Y | N | N | N | N
LONG VARCHAR FOR BIT DATA | N | N | N | N | N | N | N | N | N | N | Y | Y | Y | Y | Y| N| N| N| N
CLOB| N| N| N| N| N| N| N | Y | Y | Y | N | N | N | Y | N | N | N | N | N
BLOB | N | N | N | N | N | N | N | N | N | N | N | N | 	N | N | Y | N | N | N | N
DATE | N | N | N | N | N | N | N | Y | Y | N | N | N | N | N | N | Y | N | N | N
TIME | N | N | N | N | N | N | Y | Y | N | N | N | N | N | N | N | Y | N | N | N
TIMESTAMP | N | N | N | N | N | N| N| Y | Y | N | N | N | N | N | N | Y | Y | Y | N
XML | N | N | N | N | N | N | N	 | N | N | N | N | N | N | N | N | N | N | N | Y
