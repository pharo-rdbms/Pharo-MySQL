"
I am a Glorp database driver implementation for using MySQL with Glorp.

The Glorp database driver provides a unifying common interface for interacting with SQL databases.
"
Class {
	#name : #MySQLDatabaseDriver,
	#superclass : #DatabaseDriver,
	#instVars : [
		'rowCount'
	],
	#category : #'MySQL-Glorp'
}

{ #category : #executing }
MySQLDatabaseDriver >> basicExecuteSQLString: aString [
	| result |
	Transcript show: aString; cr.
	result := connection query: aString.
	rowCount := result rows size.
	^result rowsStream
]

{ #category : #transactions }
MySQLDatabaseDriver >> beginTransaction [
	connection execute: 'START TRANSACTION'
]

{ #category : #transactions }
MySQLDatabaseDriver >> commitTransaction [
	connection execute: 'COMMIT'
]

{ #category : #accessing }
MySQLDatabaseDriver >> connect: aLogin [
	| spec |
	connection := self connectionClass new.
	spec := (MySQLDriverSpec new)
		host: aLogin host;
		port: aLogin port asInteger;
		database: aLogin databaseName;
		user: aLogin username;
		password: aLogin password;
		yourself.
	connection connect: spec
]

{ #category : #accessing }
MySQLDatabaseDriver >> connectionClass [
	^ MySQLDriver 
]

{ #category : #accessing }
MySQLDatabaseDriver >> isConnected [
	^ connection notNil and: [ connection connected ]
]

{ #category : #accessing }
MySQLDatabaseDriver >> logout [
	connection ifNotNil: [ 
		connection disconnect.
		connection := nil ]
]

{ #category : #accessing }
MySQLDatabaseDriver >> rollbackTransaction [
	connection execute: 'ROLLBACK'
]

{ #category : #accessing }
MySQLDatabaseDriver >> rowCount [
	^ rowCount
]
