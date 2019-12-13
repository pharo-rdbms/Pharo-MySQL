Class {
	#name : #MysqlCommandsTest,
	#superclass : #MysqlTestCase,
	#category : #'MySQL-Test-Integ'
}

{ #category : #'as yet unclassified' }
MysqlCommandsTest >> testChangeUser [
	| spec altSpec conn |
	spec := self driverSpec.
	spec db: nil.
	altSpec := spec copy.
	altSpec user: self class resourceClass alternativeUsername.
	conn := self connection.
	
	self assert: (conn changeUser: altSpec) isOkay.
	self assert: (conn changeUser: spec) isOkay.
	self assert: (conn changeUser: altSpec) isOkay.
	self assert: (conn changeUser: spec) isOkay.
	conn disconnect.
	self should: [conn changeUser: spec] raise: MysqlNoConnectionError. 
]

{ #category : #'as yet unclassified' }
MysqlCommandsTest >> testDescribeTable [
	| results |
	results := self connection query: 'describe nameValue'.
	self assert: (results rows size = 3).

]

{ #category : #'as yet unclassified' }
MysqlCommandsTest >> testPing [
	| conn |
	conn := self connection.
	self assert: conn ping isOkay.
	conn disconnect.
	self should: [conn ping] raise: MysqlNoConnectionError 
]

{ #category : #'as yet unclassified' }
MysqlCommandsTest >> testStmtClose [
	| resp paramList prepResp conn stmt |

	conn := self connection.
	conn query: 'insert into mix values(''key01'', ''111222333444.555666777'')'.
	conn query: 'insert into mix values(''key02'', NULL)'.
	prepResp := conn prepare: 'select * from mix where name = ?'.

	stmt := MysqlDriverStmt onConnection: conn.
	paramList := Array with: (MysqlBindParam new bindValue: 'key01').
	stmt stmtId: prepResp prepareOkay stmtHandlerId; params: paramList.
	
	stmt close. "will try to use after close"
	resp := stmt execute.		
	self assert: resp isError.
	self assert: (resp sqlState = 'HY000').
	self assert: (resp errNo = 1243).
	
]

{ #category : #'as yet unclassified' }
MysqlCommandsTest >> testStmtExecute [
	| resp paramList prepResp conn stmt |
	conn := self connection.
	conn query: 'insert into mix values(''key01'', ''111222333444.555666777'')'.
	conn query: 'insert into mix values(''key02'', NULL)'.
	prepResp := conn prepare: 'select * from mix where name = ?'.
	stmt := MysqlDriverStmt onConnection: conn.
	paramList := Array with: (MysqlBindParam new bindValue: 'key01').
	stmt
		stmtId: prepResp prepareOkay stmtHandlerId;
		params: paramList.
	resp := stmt execute.
	self assert: resp isResultSet.
	self assert: resp rows size = 1.
	self assert: (resp rows first atIndex: 1) = 'key01'.
	self assert: (resp rows first atIndex: 2) = 111222333444.555666777s9.
	paramList :=  Array with: (MysqlBindParam new bindValue: 'key02').
	stmt params: paramList.
	resp := 	stmt execute.
	self assert: resp isResultSet.
	self assert: resp rows size = 1.
	self assert: (resp rows first atIndex: 1) = 'key02'.
	self assert: (resp rows first atIndex: 2) isNil
	
]

{ #category : #'as yet unclassified' }
MysqlCommandsTest >> testStmtPrepare [
	| resp conn |
	conn := self connection.
	resp := conn query: 'insert into nameValue values(''1'', ''key01'', ''value01'')'.
	self assert: resp isOkay.
	self assert: resp affectedRows = 1.
	resp := conn query: 'insert into nameValue values
					(''2'', ''key02'', ''value02''), 
					(''3'', ''key03'', ''value03'')'.
	self assert: resp isOkay.
	self assert: resp affectedRows = 2.
	resp := conn prepare: 'select * from nameValue where name = ?'.
	self assert: resp isPrepareResponse.
	self assert: resp prepareOkay warningCount = 0.
	self assert: resp prepareOkay numParams = 1.
	self assert: (resp paramDescriptors first) name = '?'.
	self assert: resp prepareOkay numColumns = 3.
	self assert: (resp columnDescriptors first) name = 'id'.
	self assert: (resp columnDescriptors at: 2) name = 'name'.
	self assert: (resp columnDescriptors at: 3) name = 'value'
]
