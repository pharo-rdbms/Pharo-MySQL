Class {
	#name : #MysqlSvrStmtInputConversionTest,
	#superclass : #MysqlTestCase,
	#category : #'MySQL-Test-Integ'
}

{ #category : #'as yet unclassified' }
MysqlSvrStmtInputConversionTest >> scenarios [
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
MysqlSvrStmtInputConversionTest >> testAcceptEmptyLongParams [
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
	params := MysqlBindParam 
				listOfSize: prep prepareOkay numParams 
				forDescriptors: prep paramDescriptors.
	"try a blob just less than default max_allowed_packet, which is 1M"
	params first bindValue: ''.
	stmt := MysqlDriverStmt onConnection: self connection.
	stmt stmtId: stmtId; params: params.

	resp := stmt execute.	
	self assert: resp isOkay.
	self assert: resp affectedRows = 1.
	
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtInputConversionTest >> testAcceptLongParams [
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
	params := MysqlBindParam 
				listOfSize: prep prepareOkay numParams 
				forDescriptors: prep paramDescriptors.
	"try a blob just less than default max_allowed_packet, which is 1M"
	params first bindValue: (String new: 1023*1024 withAll: $@).
	stmt := MysqlDriverStmt onConnection: self connection.
	stmt stmtId: stmtId; params: params.

	resp := stmt execute.	
	self assert: resp isOkay.
	self assert: resp affectedRows = 1.
	
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtInputConversionTest >> testAcceptNegativeIntegers [
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

		params := MysqlBindParam 
					listOfSize: prep prepareOkay numParams 
					forDescriptors: prep paramDescriptors.
		params first bindValue: '-101'.
		(params at: 2) bindValue: '-301'.
		(params at: 3) bindValue: '-40001'.
		(params at: 4) bindValue: '-100001'.
		(params at: 5) bindValue: '-6000000001'.

		stmt := MysqlDriverStmt onConnection: conn.
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
MysqlSvrStmtInputConversionTest >> testAcceptNullForIntegers [
	| conn resp params stmtId stmt |
	conn := self connection.
	
	"Change the sql_mode for the current session test (in case of strict mode enabled)"
	conn query: 'SET SESSION sql_mode = ''NO_ENGINE_SUBSTITUTION'';'.
	
	resp := conn prepare: 'insert into testIntegers 
			(tinyintValue, smallintValue, mediumintValue, intValue, bigintValue)
		values (?, ?, ?, ?, ?)'.
	stmtId := resp prepareOkay stmtHandlerId.
	params := Array new: resp prepareOkay numParams.
	params
		at: 1 put: (MysqlBindParam withValue: 'NULL');
		at: 2 put: (MysqlBindParam withValue: nil);
		at: 3 put: (MysqlBindParam withValue: nil);
		at: 4 put: (MysqlBindParam withValue: nil);
		at: 5 put: (MysqlBindParam withValue: 9999999999).
	stmt := MysqlDriverStmt onConnection: conn.
	stmt
		stmtId: stmtId;
		params: params.
	resp := stmt execute.
	self assert: resp isOkay.
	self assert: resp insertId = 1.
	self assert: resp warningCount = 1. "String 'NULL' to int conversion"
	resp := conn prepare: 'select * from testIntegers limit 1'.
	stmtId := resp prepareOkay stmtHandlerId.
	params := #().
	stmt := MysqlDriverStmt onConnection: conn.
	stmt
		stmtId: stmtId;
		params: params.
	resp := stmt execute.
	self assert: resp isResultSet.
	self assert: resp rows size = 1.
	self assert: (resp rows first atIndex: 1) = 1.
	self assert: (resp rows first atIndex: 2) = 0. "The string 'NULL' got conerted to 0"
	self assert: (resp rows first atIndex: 3) isNil.
	self assert: (resp rows first atIndex: 4) isNil.
	self assert: (resp rows first atIndex: 5) isNil.
	self assert: (resp rows first atIndex: 6) = 9999999999
]

{ #category : #'as yet unclassified' }
MysqlSvrStmtInputConversionTest >> testAcceptPositiveIntegers [
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
	
		params := MysqlBindParam 
					listOfSize: prep prepareOkay numParams 
					forDescriptors: prep paramDescriptors.
		params first bindValue: '1'.
		(params at: 2) bindValue: '301'.
		(params at: 3) bindValue: '40001'.

		stmt := MysqlDriverStmt onConnection: conn.
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
