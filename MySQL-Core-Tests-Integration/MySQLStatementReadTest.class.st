Class {
	#name : #MySQLStatementReadTest,
	#superclass : #MySQLTestCase,
	#category : #'MySQL-Core-Tests-Integration-Base'
}

{ #category : #accessing }
MySQLStatementReadTest >> scenarios [
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

{ #category : #tests }
MySQLStatementReadTest >> testReadBlobTypes [
	| prep stmtId params resp stmt |
	self 
		withFixtures: #(#blobs )
		do: 
			[ :conn | 
			prep := conn prepare: 'select * from testBlobs where id < ? order by id'.
			stmtId := prep prepareOkay stmtHandlerId.
			params := Array with: (MySQLBindParameter withValue: 5).
			stmt := MySQLDriverStatement onConnection: conn.
			stmt
				stmtId: stmtId;
				params: params.
			resp := stmt execute.
			self assert: resp isResultSet.
			self assert: resp rows size = 2.
			self assert: (resp rows first atIndex: 2) = '0123456789' asByteArray.
			self assert: (resp rows first atIndex: 3) = '0123456789' asByteArray.
			self assert: (resp rows first atIndex: 4) = '0123456789' asByteArray.
			self assert: (resp rows first atIndex: 5) = '0123456789' asByteArray.
			self assert: (resp rows second atIndex: 2) = '1234567890' asByteArray.
			self assert: (resp rows second atIndex: 3) isNil.
			self assert: (resp rows second atIndex: 4) isNil.
			self assert: (resp rows second atIndex: 5) = '1234567890' asByteArray ]
]

{ #category : #tests }
MySQLStatementReadTest >> testReadCharTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#chars) do: [:conn |
		prep := conn prepare: 'select * from testChars where id < ? order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array with: (MySQLBindParameter withValue: 5).

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.                                                                                           	self assert: resp isResultSet.
		self assert: resp rows size = 2.
		
		self assert: (resp rows first atIndex: 2) = 'smalltalk'.
		self assert: (resp rows first atIndex: 3) = 'An awesome programming environment'.
		
		self assert: (resp rows second atIndex: 2) = 'lisp'.
		self assert: (resp rows second atIndex: 3) = 'So is this one' ]
	
]

{ #category : #tests }
MySQLStatementReadTest >> testReadIntegerTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 'select * from testIntegers order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 5.
		self assert: (resp rows first atIndex: 4) = 40000.
		self assert: (resp rows first atIndex: 6) = 6000000000.
		self assert: (resp rows second atIndex: 4) = 40001.
		self assert: (resp rows second atIndex: 6) = 6000000001.
		]
]

{ #category : #tests }
MySQLStatementReadTest >> testReadIntegerTypesNeg [
	| prep stmtId params resp stmt |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 'select * from testIntegers where tinyintValue < ? order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
	
		params := MySQLBindParameter 
					listOfSize: prep prepareOkay numParams 
					forDescriptors: prep paramDescriptors.
		params first bindValue: -100.
		

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 1.
		self assert: (resp rows first atIndex: 2) = -101.
		self assert: (resp rows first atIndex: 3) = -301.
		self assert: (resp rows first atIndex: 4) = -40001.
		self assert: (resp rows first atIndex: 5) = -100001.
		self assert: (resp rows first atIndex: 6) = -6000000001.
		]
]

{ #category : #tests }
MySQLStatementReadTest >> testReadIntegerTypesNull [
	| prep stmtId params resp stmt |
	self 
		withFixtures: #(#integers )
		do: 
			[ :conn | 
			prep := conn prepare: 'select * from testIntegers order by id'.
			stmtId := prep prepareOkay stmtHandlerId.
			params := #().
			stmt := MySQLDriverStatement onConnection: conn.
			stmt
				stmtId: stmtId;
				params: params.
			resp := stmt execute.
			self assert: resp isResultSet.
			self assert: resp rows size = 5.
			self assert: (resp rows third atIndex: 4) isNil.
			self assert: (resp rows third atIndex: 6) = 6000000002.
			self assert: (resp rows fourth atIndex: 4) = 40003.
			self assert: (resp rows fourth atIndex: 6) isNil ]
]

{ #category : #tests }
MySQLStatementReadTest >> testReadRealTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#reals) do: [:conn |
		prep := conn prepare: 'select * from testReals order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 3.
		self assert: ((resp rows first atIndex: 2) closeTo: 1.1).
		self assert: ((resp rows first atIndex: 3) closeTo: 11.11).
		self assert: ((resp rows first atIndex: 4) closeTo: 222.222).
		self assert: (resp rows first atIndex: 5)  = ((3333333333 / 1000000) asScaledDecimal: 6).
		self assert: (resp rows first atIndex: 6) = (((4444444444 / 1000000) asScaledDecimal: 6)).
		]
]

{ #category : #tests }
MySQLStatementReadTest >> testReadRealTypesNeg [
	| prep stmtId params resp stmt |
	self withFixtures: #(#reals) do: [:conn |
		prep := conn prepare: 'select * from testReals order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 3.
		self assert: ((resp rows third atIndex: 2) closeTo: -1.1).
		self assert: ((resp rows third atIndex: 3) closeTo: -11.11).
		self assert: ((resp rows third atIndex: 4) closeTo: -222.222).
		self assert: (resp rows third atIndex: 5) = ((-3333333333 / 1000000) asScaledDecimal: 6).
		self assert: (resp rows third atIndex: 6) = ((-4444444444 / 1000000) asScaledDecimal: 6).
		]
]

{ #category : #tests }
MySQLStatementReadTest >> testReadRealTypesNull [
	| prep stmtId params resp stmt |
	self 
		withFixtures: #(#reals )
		do: 
			[ :conn | 
			prep := conn prepare: 'select * from testReals order by id'.
			stmtId := prep prepareOkay stmtHandlerId.
			params := #().
			stmt := MySQLDriverStatement onConnection: conn.
			stmt
				stmtId: stmtId;
				params: params.
			resp := stmt execute.
			self assert: resp isResultSet.
			self assert: resp rows size = 3.
			self assert: (resp rows second atIndex: 2) isNil.
			self assert: (resp rows second atIndex: 3) isNil.
			self assert: (resp rows second atIndex: 4) isNil.
			self assert: (resp rows second atIndex: 5) isNil.
			self assert: (resp rows second atIndex: 6) = (-5555555555 / 1000000 asScaledDecimal: 6) ]
]

{ #category : #tests }
MySQLStatementReadTest >> testReadTimeTypes [
	| prep stmtId params resp stmt |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 'select * from testTimes order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 4.

		self assert: (resp rows first atIndex: 2) = (Date fromString: '07-01-2011').
		self assert: (resp rows first atIndex: 3) = (Time fromString: '18:35:23').
		self assert: (resp rows first atIndex: 4) = 
			(DateAndTime 
				localTimeZone: TimeZone default;  
				fromString: '2011-07-02T10:12:45.000000000').
		self assert: (resp rows first atIndex: 5) = 
			(DateAndTime 
				localTimeZone: TimeZone default; 
				fromString: '01-12-1980 00:45:56-00:00').
		self assert: (resp rows first atIndex: 6) = 1999.

		self assert: (resp rows second atIndex: 2) = (Date fromString: '06-01-2011').
		self assert: (resp rows second atIndex: 3) = (Duration fromString: '03:17:34:22').
		self assert: (resp rows second atIndex: 4) = 
			(DateAndTime 
				localTimeZone: TimeZone default; 
				fromString: '2011-06-02T09:11:44.000000').
		self assert: (resp rows second atIndex: 5) = 
					(DateAndTime  
						localTimeZone: TimeZone default; 
						fromString: '02-13-1980 01:44:55')]
		
]

{ #category : #tests }
MySQLStatementReadTest >> testReadTimeTypesNeg [
	| prep stmtId params resp stmt |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 'select * from testTimes order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 4.
		self assert: (resp rows fourth atIndex: 3) = (Duration fromString: '-00:16:33:21')]
	
]

{ #category : #tests }
MySQLStatementReadTest >> testReadTimeTypesNull [
	| prep stmtId params resp stmt |
	self 
		withFixtures: #(#times )
		do: 
			[ :conn | 
			prep := conn prepare: 'select * from testTimes order by id'.
			stmtId := prep prepareOkay stmtHandlerId.
			params := #().
			stmt := MySQLDriverStatement onConnection: conn.
			stmt
				stmtId: stmtId;
				params: params.
			resp := stmt execute.
			self assert: resp isResultSet.
			self assert: resp rows size = 4.
			self assert: (resp rows third atIndex: 2) isNil.
			self assert: (resp rows third atIndex: 3) isNil.
			self assert: (resp rows third atIndex: 4) isNil.
			self assert: (resp rows fourth atIndex: 5) isNotNil ]
]
