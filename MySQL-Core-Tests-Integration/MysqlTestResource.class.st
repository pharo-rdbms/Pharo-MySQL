"
Test resource for MySQL testing
"
Class {
	#name : #MySQLTestResource,
	#superclass : #TestResource,
	#instVars : [
		'conn',
		'testConn'
	],
	#category : #'MySQL-Core-Tests-Integration-Test-Resources'
}

{ #category : #accessing }
MySQLTestResource class >> alternativeUser [
	^ 'sodbxtest2'
]

{ #category : #accessing }
MySQLTestResource class >> alternativeUsername [
	^ 'sodbxtest2'
]

{ #category : #accessing }
MySQLTestResource class >> dbName [
	^ 'sodbxtest2'
]

{ #category : #accessing }
MySQLTestResource class >> driverSpecNoDb [
	^ MySQLDriverSpec new
		host: 'localhost';
		port: 3306;
		user: 'sodbxtest';
		password: 'sodbxtest';
		yourself
]

{ #category : #accessing }
MySQLTestResource class >> driverSpecWithDb [
	^ self driverSpecNoDb
		db: self dbName;
		yourself
		
]

{ #category : #cleanup }
MySQLTestResource >> clearTestTables [
	#(
	'nameValue' 'warn' 'mix' 'testMisc' 'testIntegers' 'testReals' 'testTimes' 'testChars'
	'testBinaries' 'testBlobs' 'testTexts') 
		do: [:each | conn query: 'truncate table ', each]

]

{ #category : #utilities }
MySQLTestResource >> connectToServer [
	| resp |
	conn := MySQLDriver new.
	resp := conn connect: self class driverSpecNoDb.
	resp isOkay 
		ifFalse: [ ^ self error: 'Failed to connect to MySQL server' ]
]

{ #category : #utilities }
MySQLTestResource >> createAlternativeUser [
	"Creates an alternative user with the same password as the main test user"
	| resp |
	resp := conn query: 'CREATE USER ''', self class alternativeUsername , '''@''%''IDENTIFIED BY ''', self class driverSpecNoDb password , ''';'.
	resp isOkay ifFalse: [^ self error: 'Can not create second user'].
]

{ #category : #utilities }
MySQLTestResource >> createMiscTestTables [
	| resp |
	self ddlMiscTestTables do: [:each |
		resp := conn query: each.
		resp isError ifTrue: [^ self error: 'Error creating misc test table: ', resp message]]
	
]

{ #category : #utilities }
MySQLTestResource >> createTestDb [
	| resp |
	resp := conn query: 'create database if not exists ', self class dbName, ' DEFAULT CHARACTER SET latin1'.
	resp isOkay ifFalse: [^ self error: 'Can not create test database'].
	
	resp := conn query: 'use ', self class dbName.
	resp isError ifTrue: [^ self error: 'Failed to use test database'].	

]

{ #category : #utilities }
MySQLTestResource >> createTypeTestTables [
	| resp |
	self ddlTypeTestTables do: [:each |
		resp := conn query: each.
		resp isError ifTrue: [^ self error: 'Error creating type test table: ', resp message]]
	
]

{ #category : #utilities }
MySQLTestResource >> ddlMiscTestTables [
	^ #(
	'create table if not exists nameValue (
		id int not null auto_increment primary key,
		name varchar(256) not null unique key,
		value varchar(1024) not null default ''aeiou''
	) engine = InnoDB'
	
	'/* for testing warnings */
	create table if not exists warn (
		c1 tinyint not null,
		c2 varchar(32)
	)'

	'create table if not exists mix (
		name varchar(256) not null primary key,
		value decimal(21,9) default null
	) engine = InnoDB'
		
	'create table if not exists testMisc (
		name varchar(100) not null primary key,
		value varchar(1000) not null,
		entryOn date not null,
		notes varchar(1000)
	) engine = InnoDB'
	
	'create table if not exists testWideTable (
		id int auto_increment not null primary key,
		name varchar(100),
		shortDescription varchar(200),
		longDescription varchar(1000),
		categotyCode int,
		categoryName varchar(200),
		supplierCode int,
		supplierName varchar(200),
		colorCode int,
		colorName varchar(100),
		colorSource int,
		colorSourceName varchar(100),
		size int,
		attributeA varchar(100),
		attributeB varchar(100),
		attributeC varchar(100),
		attributeD varchar(100),
		attributeE varchar(100),
		attributeF varchar(100),
		attributeG varchar(100),
		attributeH varchar(100),
		attributeI varchar(100),
		attributeJ varchar(100),
		attributeK varchar(100),
		attributeL varchar(100),
		attributeM varchar(100),
		attributeN varchar(100),
		attributeO varchar(100),
		attributeP varchar(100),
		attributeQ varchar(100),
		attributeR varchar(100),
		attributeS varchar(100),
		attributeT varchar(100),
		attributeU varchar(100),
		attributeV varchar(100),
		attributeW varchar(100),
		attributeX varchar(100),
		attributeY varchar(100),
		attributeZ varchar(100)
	) engine = InnoDB'
	)
]

{ #category : #utilities }
MySQLTestResource >> ddlTypeTestTables [
	^ #(
	
	'create table if not exists testIntegers (
		id int auto_increment primary key,
		tinyintValue tinyint,
		smallintValue smallint,
		mediumintValue mediumint,
		intValue int,
		bigintValue bigint
	) engine = InnoDB'
	
	'create table if not exists testReals (
		id int auto_increment primary key,
		floatValue float,
		doubleValue double,
		realValue real,
		decimalValue decimal(10,6),
		numericValue numeric(10, 6)
	) engine = InnoDB'
	
	'create table if not exists testTimes (
		id int auto_increment primary key,
		dateValue date,
		timeValue time,
		datetimeValue datetime,
		timestampValue timestamp,
		yearValue year
	) engine = InnoDB'
	
	'create table if not exists testChars (
		id int auto_increment primary key,
		charValue char(100),
		varcharValue varchar(1000)
	) engine = InnoDB'
	
	'create table if not exists testBinaries (
		id int auto_increment primary key,
		binaryValue binary,
		varbinaryValue varbinary(256)
	) engine = InnoDB'
	
	'create table if not exists testBlobs (
		id int auto_increment primary key,
		tinyblobValue tinyblob,
		blobValue blob,
		mediumblobValue mediumblob,
		longblobValue longBlob
	) engine = InnoDB'
	
	'create table if not exists testTexts (
		id int auto_increment primary key,
		tinytextValue tinytext,
		textValue text,
		mediumtextValue mediumtext,
		longtextValue longtext
	) engine = InnoDB'
	
	)
]

{ #category : #utilities }
MySQLTestResource >> deleteAlternativeUser [
	| resp |
	resp := conn query: 'DROP USER ''', self class alternativeUsername, ''';'.
	resp isOkay ifFalse: [^ self error: 'Can not create second user'].
]

{ #category : #utilities }
MySQLTestResource >> deleteTestDb [
	| resp |
	resp := conn query: 'drop database if exists ', self class dbName.
	resp isOkay ifFalse: [^ self error: 'Can not create test database']	
]

{ #category : #utilities }
MySQLTestResource >> disconnecTestConnection [
	testConn ifNotNil:[
		[testConn disconnect] on: MySQLNoConnectionError do: [:ex |]]

]

{ #category : #utilities }
MySQLTestResource >> disconnectFromServer [
	[conn disconnect] on: MySQLNoConnectionError do: [:ex |].

]

{ #category : #utilities }
MySQLTestResource >> resourceConnection [
	^ conn
	
]

{ #category : #running }
MySQLTestResource >> setUp [
	self 
		connectToServer;
		createTestDb;
		createAlternativeUser;
		createMiscTestTables;
		createTypeTestTables.
		
]

{ #category : #running }
MySQLTestResource >> tearDown [
	self disconnecTestConnection.	
	self deleteTestDb.
	self deleteAlternativeUser.
	self disconnectFromServer.

]

{ #category : #utilities }
MySQLTestResource >> testConnection [
	"Returns a connection to be used for the testXyz methods. 
	Not to be confused with the internal connection instance 
	for setting up schemas and tables"
	(testConn isNil or: [ testConn connected not ]) 
		ifTrue: [
			testConn := MySQLDriver new.
			testConn connect: self class driverSpecWithDb].
	^ testConn
]
