Class {
	#name : #MySQLServerStatementInputTest,
	#superclass : #MySQLTestCase,
	#category : #'MySQL-Core-Tests-Integration-Base'
}

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> scenarios [
^
'
Statement
- should accept no param and return no result set
- should accept no param and return result set
- should accept param and return no result set
- should accept param and return result set
- should accept positive value for integers
- should accept negative value for integers
- should accept null value for for integers
- should accept positive value for reals
- should accept negative value for reals
- should accept null value for reals
- should accept chars
- should accept null value for chars
- should accept binaries
- should accept null value for binaries
- should accept blobs
- should accept nulls value for blobs
- should accept texts
- should accept nulls value for texts
- should accept times
- should accept negative value for times (typeTIME)
- should accept null value for times
'

]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testAcceptLongParams [
	| prep stmtId resp params stmt |
	
	"
	NOTE: This is guided by the settings of mx_allowed_packet value. Default is 1 MB.
	You can check it with 'select @@max_allowed packet' command or cahange it by
	issuing 'set global max_allowed_packet = <another value>'. We test the long params
	within the default bounds.
	"

	prep := self connection prepare: 
		'insert into 
			testBlobs (tinyblobValue, blobValue, mediumblobValue, longBlobValue) 
			values (NULL, NULL, NULL, ?)'.
	stmtId := prep prepareOkay stmtHandlerId.
	params := MySQLBindParameter 
				listOfSize: prep prepareOkay numParams 
				forDescriptors: prep paramDescriptors.
	"try a blob just less than default max_allowed_packet, which is 1M"
	params first bindValue: (ByteArray new: 1023*1024 withAll: 16r55).
	stmt := MySQLDriverStatement onConnection: self connection.
	stmt stmtId: stmtId; params: params.

	resp := stmt execute.	
	self assert: resp isOkay.
	self assert: resp affectedRows = 1.
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testAcceptNegativeIntegers [
	| prep stmtId params resp stmt |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 
			'select * from testIntegers 
			where 
				tinyintValue = ? and smallintValue = ? and
				mediumintValue = ? and intValue = ? and
				bigintValue = ? 
			order by id'.
		stmtId := prep prepareOkay stmtHandlerId.

		params := MySQLBindParameter 
					listOfSize: prep prepareOkay numParams 
					forDescriptors: prep paramDescriptors.
		params first bindValue: -101.
		(params at: 2) bindValue: -301.
		(params at: 3) bindValue: -40001.
		(params at: 4) bindValue: -100001.
		(params at: 5) bindValue: -6000000001.

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 1.
		self assert: (resp rows first atIndex: 2) = -101.
		self assert: (resp rows first atIndex: 3) = -301.
		self assert: (resp rows first atIndex: 4) = -40001.
		self assert: (resp rows first atIndex: 5) = -100001.
		self assert: (resp rows first atIndex: 6) = -6000000001]	
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testAcceptNullForIntegers [
	| conn resp params stmtId stmt |
	conn := self connection.
	resp := conn prepare: 'insert into testIntegers 
			(tinyintValue, smallintValue, mediumintValue, intValue, bigintValue)
		values (?, ?, ?, ?, ?)'.
	stmtId := resp prepareOkay stmtHandlerId.
	params := Array new: resp prepareOkay numParams.
	params
		at: 1
			put: (MySQLBindParameter withValue: nil);
		at: 2
			put: (MySQLBindParameter withValue: nil);
		at: 3
			put: (MySQLBindParameter withValue: nil);
		at: 4
			put: (MySQLBindParameter withValue: nil);
		at: 5
			put: (MySQLBindParameter withValue: 9999999999).
	stmt := MySQLDriverStatement onConnection: conn.
	stmt
		stmtId: stmtId;
		params: params.
	resp := stmt execute.
	self assert: resp isOkay.
	self assert: resp insertId = 1.
	self assert: resp warningCount = 0.
	resp := conn prepare: 'select * from testIntegers limit 1'.
	stmtId := resp prepareOkay stmtHandlerId.
	params := #().
	stmt := MySQLDriverStatement onConnection: conn.
	stmt
		stmtId: stmtId;
		params: params.
	resp := stmt execute.
	self assert: resp isResultSet.
	self assert: resp rows size = 1.
	self assert: (resp rows first atIndex: 1) = 1.
	self assert: (resp rows first atIndex: 2) isNil.
	self assert: (resp rows first atIndex: 3) isNil.
	self assert: (resp rows first atIndex: 4) isNil.
	self assert: (resp rows first atIndex: 5) isNil.
	self assert: (resp rows first atIndex: 6) = 9999999999
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testAcceptPositiveIntegers [
	| prep stmtId params resp stmt |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 
			'select * from testIntegers 
			where 
				tinyintValue = ? and smallintValue = ? and
				mediumintValue = ? and intValue = 100001 and
				bigintValue = 6000000001 
			order by id'.
		stmtId := prep prepareOkay stmtHandlerId.
	
		params := MySQLBindParameter 
					listOfSize: prep prepareOkay numParams 
					forDescriptors: prep paramDescriptors.
		params first bindValue: 1.
		(params at: 2) bindValue: 301.
		(params at: 3) bindValue: 40001.

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.		
		self assert: resp isResultSet.
		self assert: resp rows size = 1.
		self assert: (resp rows first atIndex: 2) = 1.
		self assert: (resp rows first atIndex: 3) = 301.
		self assert: (resp rows first atIndex: 4) = 40001.
		self assert: (resp rows first atIndex: 5) = 100001.
		self assert: (resp rows first atIndex: 6) = 6000000001]
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testInputParamExpectingNoResultSet [
	| prep stmtId params resp stmt |
	self withFixtures: #(#zero) do: [:conn |
		prep := conn 
			prepare: 
				'delete from testMisc 
				where name in (?, ?, ?, ?)'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array new: (prep prepareOkay numParams).
		params 
			at: 1 put: (MySQLBindParameter withValue: 'key-0006');
			at: 2 put: (MySQLBindParameter withValue: 'key-0007');
			at: 3 put: (MySQLBindParameter withValue: 'key-0008');
			at: 4 put: (MySQLBindParameter withValue: 'key-0009').

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isOkay.
		self assert: (resp affectedRows = 4)]  
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testInputParamExpectingResultSet [
	| prep stmtId params resp stmt |
	self withFixtures: #(#zero) do: [:conn |
		prep := conn 
			prepare: 
				'select * from testMisc 
				where name in (?, ?, ?, ?, ?)'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array new: (prep prepareOkay numParams).
		params
			at: 1 put: (MySQLBindParameter withValue: 'key-0002');
			at: 2 put: (MySQLBindParameter withValue: 'key-0004');
			at: 3 put: (MySQLBindParameter withValue: 'key-0006');
			at: 4 put: (MySQLBindParameter withValue: 'key-0008'); 
			at: 5 put: (MySQLBindParameter withValue: 'key-0010'). 

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 5.
		self assert: (resp rows first atIndex: 1) = 'key-0002'.
		self assert: (resp rows last atIndex: 1) = 'key-0010'.
		self assert: (resp rows last atIndex: 3) = (Date fromString: 'Jul 01 2011')]  
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testInputTimeTypes [
	| prep stmtId params stmt resp |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 
			'update testTimes
			set dateValue = ?, timeValue = ?, dateTimeValue = ?,
				timeStampValue = ?, yearValue = ?
			where id = 1'.
		self assert: prep isOkay.
		
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array new: (prep prepareOkay numParams).
		params 
			at: 1 put: (MySQLBindParameter withValue: '2011-11-15');
			at: 2 put: (MySQLBindParameter withValue: '17:28');
			at: 3 put: (MySQLBindParameter withValue: '2010-10-31 22;11:33');
			at: 4 put: (MySQLBindParameter withValue: nil);
			at: 5 put: (MySQLBindParameter withValue: 2020).

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.
		resp := stmt execute.
		self assert: resp isOkay.
		self assert: resp affectedRows = 1.
		self assert: resp warningCount = 0]
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testInputTimeTypesNeg [
	| prep stmtId params stmt resp |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 
			'update testTimes
			set dateValue = ?, timeValue = ?, dateTimeValue = ?,
				timeStampValue = ?, yearValue = ?
			where id = 1'.
		self assert: prep isOkay.
		
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array new: (prep prepareOkay numParams).
		params 
			at: 1 put: (MySQLBindParameter withValue: '2011-11-15');
			at: 2 put: (MySQLBindParameter withValue:  '-10 16:33:21'); "same as -256:33;21"
			at: 3 put: (MySQLBindParameter withValue: '2010-10-31 22:11:33');
			at: 4 put: (MySQLBindParameter withValue: nil);
			at: 5 put: (MySQLBindParameter withValue: 2020).

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.
		resp := stmt execute.
		self assert: resp isOkay.
		self assert: resp affectedRows = 1.
		self assert: resp warningCount = 0].
		
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testInputTimeTypesNull [
	| prep stmtId params stmt resp |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 
			'update testTimes
			set dateValue = ?, timeValue = ?, dateTimeValue = ?, yearValue = ?
			where id = 1'.
		self assert: prep isOkay.
		
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array new: (prep prepareOkay numParams).
		params 
			at: 1 put: (MySQLBindParameter withValue: nil);
			at: 2 put: (MySQLBindParameter withValue:  nil); 
			at: 3 put: (MySQLBindParameter withValue: nil);
			at: 4 put: (MySQLBindParameter withValue: nil).

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.
		resp := stmt execute.
		self assert: resp isOkay.
		self assert: resp affectedRows = 1.
		self assert: resp warningCount = 0].
		
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testNoInputParamExpectingNoResultSet [
	| prep stmtId params resp stmt |
	self withFixtures: #(#zero) do: [:conn |
		prep := conn 
			prepare:
				'delete from testMisc 
				where name in (''key-0006'', ''key-0007'',''key-0008'',''key-0009'')'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isOkay.
		self assert: (resp affectedRows = 4)]  
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementInputTest >> testNoInputParamExpectingResultSet [
	| prep stmtId params resp stmt |
	self withFixtures: #(#zero) do: [:conn |
		prep := conn 
			prepare:
				'select * from testMisc 
				where name in (''key-0002'', ''key-0004'', ''key-0006'', ''key-0008'', ''key-0010'')
				order by name'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		self assert: resp rows size = 5.
		self assert: (resp rows first atIndex: 1) = 'key-0002'.
		self assert: (resp rows last atIndex: 1) = 'key-0010'.
		self assert: (resp rows last atIndex: 3) = (Date fromString: 'Jul 01 2011')
	]  
	
]
