Class {
	#name : #MysqlSvrStmtReadStringTest,
	#superclass : #MysqlTestCase,
	#category : #'MySQL-Test-Integ'
}

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> scenarios [
^ '
- should read results of integer types  
	- tinyint, smallint, mediumint, (long)int, bigint
- should read results of real types 
	- float, double, real (approx values)
- should read results of real types 
	- decimal, numeric (exact values)
- should read results of date types 
	- date, time, datetime, timestamp, year
- should read results of char types 
	- char, varchar
- should read results of binary types 
	- binary, varbinary
- should read results of blob types 
	- tinyblob, blob, mediumblob longblob
- should read results of text types 
	- tinytext, text, mediumtext, longtext
'

]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadBlobTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#blobs) do: [:conn |
		prep := conn prepare: 'select * from testBlobs where id < ? order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array with: (MysqlBindParam withValue: 5).

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 2.
		self assert: (resp rows first atIndex: 2) = '0123456789'.
		self assert: (resp rows first atIndex: 3) = '0123456789'.
		self assert: (resp rows first atIndex: 4) = '0123456789'.
		self assert: (resp rows first atIndex: 5) = '0123456789'.
		
		self assert: (resp rows second atIndex: 2) = '1234567890'.
		self assert: (resp rows second atIndex: 3) = 'NULL'.
		self assert: (resp rows second atIndex: 4) = 'NULL'.
		self assert: (resp rows second atIndex: 5) = '1234567890']
	
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadCharTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#chars) do: [:conn |
		prep := conn prepare: 'select * from testChars where id < ? order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array with: (MysqlBindParam withValue: 5).

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
				                                                                                                		self assert: resp isResultSet.
		self assert: resp rows size = 2.
		
		self assert: (resp rows first atIndex: 2) = 'smalltalk'.
		self assert: (resp rows first atIndex: 3) = 'An awesome programming environment'.
		
		self assert: (resp rows second atIndex: 2) = 'lisp'.
		self assert: (resp rows second atIndex: 3) = 'So is this one' ]
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadIntegerTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 'select * from testIntegers order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 5.
		self assert: (resp rows first atIndex: 4) = '40000'.
		self assert: (resp rows first atIndex: 6) = '6000000000'.
		self assert: (resp rows second atIndex: 4) = '40001'.
		self assert: (resp rows second atIndex: 6) = '6000000001']
	
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadIntegerTypesNeg [
	| prep stmtId params resp stmt |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 'select * from testIntegers where tinyintValue < ? order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
	
		params := MysqlBindParam 
					listOfSize: prep prepareOkay numParams 
					forDescriptors: prep paramDescriptors.
		params first bindValue: -100.

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 1.
		self assert: (resp rows first atIndex: 2) = '-101'.
		self assert: (resp rows first atIndex: 3) = '-301'.
		self assert: (resp rows first atIndex: 4) = '-40001'.
		self assert: (resp rows first atIndex: 5) = '-100001'.
		self assert: (resp rows first atIndex: 6) = '-6000000001']
	
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadIntegerTypesNull [
	| prep stmtId params resp stmt |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 'select * from testIntegers order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 5.
		self assert: (resp rows third atIndex: 4) = 'NULL'.
		self assert: (resp rows third atIndex: 6) = '6000000002'.
		self assert: (resp rows fourth atIndex: 4) = '40003'.
		self assert: (resp rows fourth atIndex: 6) = 'NULL']
	
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadRealTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#reals) do: [:conn |
		prep := conn prepare: 'select * from testReals order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 3.
		self assert: ((resp rows first atIndex: 2) asNumber closeTo: 1.1).
		self assert: ((resp rows first atIndex: 3) asNumber closeTo: 11.11).
		self assert: ((resp rows first atIndex: 4) asNumber closeTo: 222.222).
		self assert: 
			(resp rows first atIndex: 5)  = ((3333333333 / 1000000) asScaledDecimal: 6) asString.
		self assert: 
			(resp rows first atIndex: 6) = ((4444444444 / 1000000) asScaledDecimal: 6) asString]
		
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadRealTypesNeg [
	| prep stmtId params resp stmt |
	self withFixtures: #(#reals) do: [:conn |
		prep := conn prepare: 'select * from testReals order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 3.
		self assert: ((resp rows third atIndex: 2) asNumber closeTo: -1.1).
		self assert: ((resp rows third atIndex: 3) asNumber closeTo: -11.11).
		self assert: ((resp rows third atIndex: 4) asNumber closeTo: -222.222).
		self assert: 
			(resp rows third atIndex: 5) = ((-3333333333 / 1000000) asScaledDecimal: 6) asString.
		self assert: 
			(resp rows third atIndex: 6) = ((-4444444444 / 1000000) asScaledDecimal: 6) asString]
		
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadRealTypesNull [
	| prep stmtId params resp stmt |
	self withFixtures: #(#reals) do: [:conn |
		prep := conn prepare: 'select * from testReals order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 3.
		self assert: (resp rows second atIndex: 2) = 'NULL'.
		self assert: (resp rows second atIndex: 3) = 'NULL'.
		self assert: (resp rows second atIndex: 4) = 'NULL'.
		self assert: (resp rows second atIndex: 5) = 'NULL'.
		self assert: 
			(resp rows second atIndex: 6) = 
				((-5555555555 / 1000000) asScaledDecimal: 6) asString]
			
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadTimeTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 'select * from testTimes order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 4.

		self assert: (resp rows first atIndex: 2) = '2011-07-01'.
		self assert: (resp rows first atIndex: 3) = '18:35:23'.
		self assert: (resp rows first atIndex: 4) = '2011-07-02T10:12:45+00:00'.
		self assert: (resp rows first atIndex: 5) = '1980-01-12T00:45:56+00:00'.
		self assert: (resp rows first atIndex: 6) = '1999'.

		self assert: (resp rows second atIndex: 2) = '2011-06-01'.
		self assert: (resp rows second atIndex: 3) = '3:17:34:22'.
		self assert: (resp rows second atIndex: 4) = '2011-06-02T09:11:44+00:00'.
		self assert: (resp rows second atIndex: 5) = '1980-02-13T01:44:55+00:00']
		
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadTimeTypesNeg [
	| prep stmtId params resp stmt |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 'select * from testTimes order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 4.
		self assert: (resp rows fourth atIndex: 3) = '-0:16:33:21']
	
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtReadStringTest >> testReadTimeTypesNull [
	| prep stmtId params resp stmt |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 'select * from testTimes order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MysqlDriverStmt onConnection: conn.
		stmt stmtId: stmtId; params: params; typeMapResults: false.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 4.

		self assert: (resp rows third atIndex: 2) = 'NULL'.
		self assert: (resp rows third atIndex: 3) = 'NULL'.
		self assert: (resp rows third atIndex: 4) = 'NULL'.
		self deny: (resp rows third atIndex: 5) = 'NULL'.
		]
]
