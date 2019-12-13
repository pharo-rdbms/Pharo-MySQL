"
- error
	syntax
	schema
- warning
	syntax
	truncation
	depracated(?)
- Genral
	DDL: create, alter, drop, truncate, comment, rename, ...
	DML: select, insert, update, delete, call, explain, lock, ...
	DCL: grant, revoke, ...
	TCL: begin, commit, savepoint, rollback, ...
- In and out of transaction state (server status flag)

"
Class {
	#name : #MysqlQueryStatusTest,
	#superclass : #MysqlTestCase,
	#category : #'MySQL-Test-Integ'
}

{ #category : #'as yet unclassified' }
MysqlQueryStatusTest >> testAffectedRows [
	| conn resp |
	conn := self connection.

	resp := conn query: 'insert into nameValue values(''0'', ''statusKey01'', ''statusValue01'')'.
	self assert: resp isOkay.
	self assert: resp affectedRows = 1.

	resp := conn query: 'insert into nameValue values(''0'', ''statusKey02'', ''statusValue03'')'.
	self assert: resp isOkay.
	self assert: resp affectedRows = 1.

	resp := conn query: 'delete from nameValue where id in (''1'', ''2'')'.
	self assert: resp isOkay.
	self assert: resp affectedRows = 2.

]

{ #category : #'as yet unclassified' }
MysqlQueryStatusTest >> testAutoCommitMode [
	| conn resp |
	conn := self connection.
	resp := conn query: 'set autocommit = 0'.
	self assert: (resp serverStatus bitAnd: MysqlServerStatus statusAutoCommit) = 0 .
	resp := conn query: 'set autocommit = 1'.
	self deny: (resp serverStatus bitAnd: MysqlServerStatus statusAutoCommit) = 0.

]

{ #category : #'as yet unclassified' }
MysqlQueryStatusTest >> testInsertId [
	| conn resp |
	conn := self connection.

	resp := conn query: 'insert into nameValue values(''0'', ''statusKey01'', ''statusValue02'')'.
	self assert: resp isOkay.
	self assert: resp insertId = 1.

	resp := conn query: 'insert into nameValue values(''0'', ''statusKey02'', ''statusValue03'')'.
	self assert: resp isOkay.
	self assert: resp insertId = 2.

]

{ #category : #'as yet unclassified' }
MysqlQueryStatusTest >> testServerStatus [
	| conn resp |
	conn := self connection.

	resp := conn query: 'insert into nameValue values(''0'', ''statusKey01'', ''statusValue01'')'.
	self assert: resp isOkay.
	self deny: (resp serverStatus bitAnd: MysqlServerStatus statusAutoCommit) = 0.

	resp := conn query: 'insert into nameValue values(''0'', ''statusKey02'', ''statusValue02'')'.
	self assert: resp isOkay.
	self deny: (resp serverStatus bitAnd: MysqlServerStatus statusAutoCommit) = 0.
	
	resp := conn query: 'select * from nameValue'.
	self assert: resp isResultSet.
	self deny: (resp serverStatus bitAnd: MysqlServerStatus statusNoIndexUsed) = 0.
	self deny: (resp serverStatus bitAnd: MysqlServerStatus statusAutoCommit) = 0.

]

{ #category : #'as yet unclassified' }
MysqlQueryStatusTest >> testTransactionModeCommit [
	| conn resp |
	conn := self connection.
	resp := conn query: 'start transaction'.
	self assert: resp isOkay.
	self assert: (resp serverStatus bitAnd: MysqlServerStatus statusInTransaction) 
				= MysqlServerStatus statusInTransaction.
	resp := conn query: 'set autocommit = 0'.
	self assert: resp isOkay.
	self assert: (resp serverStatus bitAnd: MysqlServerStatus statusAutoCommit) = 0.

	resp := conn query: 'insert into nameValue values(''0'', ''statusKey01'', ''statusValue02'')'.
	self assert: resp isOkay.
	resp := conn query: 'insert into nameValue values(''0'', ''statusKey02'', ''statusValue03'')'.
	self assert: resp isOkay.

    resp := conn query: 'set autocommit = 1'.
    self assert: resp isOkay.

    resp := conn query: 'commit'.
    self assert: resp isOkay.

	resp := conn query: 'select count(*) from nameValue'.
	self assert: resp isResultSet.
	self assert: resp fields size = 1.
	self assert: resp rows size = 1.
	self assert: (resp rows first atIndex: 1) asInteger = 2.

]

{ #category : #'as yet unclassified' }
MysqlQueryStatusTest >> testTransactionModeRollback [
	| conn resp |
	conn := self connection.
	resp := conn query: 'start transaction'.
	self assert: resp isOkay.
	
	resp := conn query: 'insert into nameValue values(''0'', ''statusKey01'', ''statusValue02'')'.
	self assert: resp isOkay.
	resp := conn query: 'insert into nameValue values(''0'', ''statusKey02'', ''statusValue03'')'.
	self assert: resp isOkay.

	resp := conn query: 'rollback'.
	self assert: resp isOkay.
	self assert: resp warningCount = 0.

	resp := conn query: 'select count(*) from nameValue'.
	self assert: resp isResultSet.
	self assert: resp fields size = 1.
	self assert: resp rows size = 1.
	self assert: (resp rows first atIndex: 1) asInteger = 0.


]

{ #category : #'as yet unclassified' }
MysqlQueryStatusTest >> testTransactionStatus [
	| conn resp |
	conn := self connection.
	resp := conn query: 'start transaction'.
	self deny: (resp serverStatus bitAnd: MysqlServerStatus statusInTransaction) = 0.

	resp := conn query: 'rollback'.
	self assert: (resp serverStatus bitAnd: MysqlServerStatus statusInTransaction) = 0.

]

{ #category : #'as yet unclassified' }
MysqlQueryStatusTest >> testWarnings [
	| conn resp |
	conn := self connection.
	
	"Change the sql_mode for the current session test (in case of strict mode enabled)"
	conn query: 'SET SESSION sql_mode = ''NO_ENGINE_SUBSTITUTION'';'.
	
	resp := conn query: 'insert into warn values(''1000'', ''value one'')'.
	self assert: resp isOkay.
	self assert: resp warningCount = 1.
		
	resp := conn query: 'insert into warn values
				(''256'', ''value one two three four five six seven eight none ten'')'.
	self assert: resp isOkay.
	self assert: resp warningCount = 2.

]
