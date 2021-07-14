Class {
	#name : #MySQLStatementReadCSVTest,
	#superclass : #MySQLTestCase,
	#category : #'MySQL-CSV-Tests'
}

{ #category : #accessing }
MySQLStatementReadCSVTest >> scenarios [
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
MySQLStatementReadCSVTest >> testReadBlobTypes [
	| prep stmtId params resp stmt csv |
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
			csv := resp asCSV.
		
			self assert: resp rows size equals: 2.
			self assert: csv lines first equals: '"id","tinyblobValue","blobValue","mediumblobValue","longblobValue"'.
			self assert: csv lines second equals: '"1","0123456789","0123456789","0123456789","0123456789"'.
			self assert: csv lines third equals: '"2","1234567890","","","1234567890"'.
			
			self assert: (resp rows first atIndex: 2) equals: '0123456789' asByteArray.
			self assert: (resp rows first atIndex: 3) equals: '0123456789' asByteArray.
			self assert: (resp rows first atIndex: 4) equals: '0123456789' asByteArray.
			self assert: (resp rows first atIndex: 5) equals: '0123456789' asByteArray.
			self assert: (resp rows second atIndex: 2) equals: '1234567890' asByteArray.
			self assert: (resp rows second atIndex: 3) isNil.
			self assert: (resp rows second atIndex: 4) isNil.
			self assert: (resp rows second atIndex: 5) equals: '1234567890' asByteArray ]
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadCharTypes [
	| prep stmtId params resp stmt csv |
	self withFixtures: #(#chars) do: [:conn |
		prep := conn prepare: 'select * from testChars where id < ? order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := Array with: (MySQLBindParameter withValue: 5).

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.    
		self assert: resp isResultSet.
		csv := resp asCSV. 
		self assert: csv lines size equals: 3.
		self assert: csv lines first equals: '"id","charValue","varcharValue"'.
		self assert: csv lines second equals: '"1","smalltalk","An awesome programming environment"'.
		self assert: csv lines third equals: '"2","lisp","So is this one"' ]
	
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadIntegerTypes [
	| prep stmtId params resp stmt csv |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 'select * from testIntegers order by id'.
		stmtId := prep prepareOkay stmtHandlerId.
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		csv := resp asCSV.
		self assert: resp rows size equals: 5.
		self assert: csv lines size equals: 6.
		self assert: csv lines first equals: '"id","tinyintValue","smallintValue","mediumintValue","intValue","bigintValue"'.
		self assert: csv lines second equals: '"1","0","300","40000","100000","6000000000"'.
		self assert: csv lines last equals: '"5","-101","-301","-40001","-100001","-6000000001"'.
		]
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadIntegerTypesNeg [
	| prep stmtId params resp stmt csv |
	self withFixtures: #(#integers) do: [:conn |
		prep := conn prepare: 'select * from testIntegers where tinyintValue < ? order by id'.
		stmtId := prep prepareOkay stmtHandlerId.
	
		params := MySQLBindParameter 
					listOfSize: prep prepareOkay numParams 
					forDescriptors: prep paramDescriptors.
		params first bindValue: -100.
		

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		csv := resp asCSV.

		self assert: resp rows size equals: 1.
		self assert: csv lines size equals: 2.
		self assert: csv lines first equals: '"id","tinyintValue","smallintValue","mediumintValue","intValue","bigintValue"'.
		self assert: csv lines last equals: '"5","-101","-301","-40001","-100001","-6000000001"'
		]
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadIntegerTypesNull [
	| prep stmtId params resp stmt csv |
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
			csv := resp asCSV.

			self assert: resp rows size = 5.
			self assert: csv lines size equals: 6.
			self assert: csv lines first equals: '"id","tinyintValue","smallintValue","mediumintValue","intValue","bigintValue"'.
			self assert: csv lines fourth equals: '"3","2","","","","6000000002"'.
			self assert: (resp rows third atIndex: 4) isNil.
			self assert: (resp rows third atIndex: 6) equals: 6000000002.
			self assert: (resp rows fourth atIndex: 4) equals: 40003.
			self assert: (resp rows fourth atIndex: 6) isNil ]
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadRealTypes [
	| prep stmtId params resp stmt csv |
	self withFixtures: #(#reals) do: [:conn |
		prep := conn prepare: 'select * from testReals order by id'.
		stmtId := prep prepareOkay stmtHandlerId.
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		csv := resp asCSV.
		self assert: resp rows size equals: 3.
		self assert: csv lines size equals: 4.
		self assert: csv lines first equals: '"id","floatValue","doubleValue","realValue","decimalValue","numericValue"'.
		self assert: csv lines second equals: '"1","1.100000023841858","11.11","222.222","3333.333333s6","4444.444444s6"'.
		self assert: ((resp rows first atIndex: 2) closeTo: 1.1).
		self assert: ((resp rows first atIndex: 3) closeTo: 11.11).
		self assert: ((resp rows first atIndex: 4) closeTo: 222.222).
		self assert: (resp rows first atIndex: 5)  = ((3333333333 / 1000000) asScaledDecimal: 6).
		self assert: (resp rows first atIndex: 6) = (((4444444444 / 1000000) asScaledDecimal: 6)).
		]
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadRealTypesNeg [
	| prep stmtId params resp stmt csv |
	self withFixtures: #(#reals) do: [:conn |
		prep := conn prepare: 'select * from testReals order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		csv := resp asCSV.
		self assert: resp rows size equals: 3.
		self assert: csv lines size equals: 4.
		self assert: csv lines first equals: '"id","floatValue","doubleValue","realValue","decimalValue","numericValue"'.
		self assert: csv lines fourth equals: '"3","-1.100000023841858","-11.11","-222.222","-3333.333333s6","-4444.444444s6"'.
		self assert: ((resp rows third atIndex: 2) closeTo: -1.1).
		self assert: ((resp rows third atIndex: 3) closeTo: -11.11).
		self assert: ((resp rows third atIndex: 4) closeTo: -222.222).
		self assert: (resp rows third atIndex: 5) = ((-3333333333 / 1000000) asScaledDecimal: 6).
		self assert: (resp rows third atIndex: 6) = ((-4444444444 / 1000000) asScaledDecimal: 6).
		]
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadRealTypesNull [
	| prep stmtId params resp stmt csv |
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
			csv := resp asCSV.
			self assert: resp rows size equals: 3.
			self assert: csv lines size equals: 4.
			self assert: csv lines first equals: '"id","floatValue","doubleValue","realValue","decimalValue","numericValue"'.
			self assert: csv lines third equals: '"2","","","","","-5555.555555s6"'.
			self assert: (resp rows second atIndex: 2) isNil.
			self assert: (resp rows second atIndex: 3) isNil.
			self assert: (resp rows second atIndex: 4) isNil.
			self assert: (resp rows second atIndex: 5) isNil.
			self assert: (resp rows second atIndex: 6) = (-5555555555 / 1000000 asScaledDecimal: 6) ]
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadTimeTypes [
	| prep stmtId params resp stmt csv |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 'select * from testTimes order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		csv := resp asCSV.
		self assert: resp rows size equals: 4.
		self assert: csv lines size equals: 5.
		self assert: csv lines first equals: '"id","dateValue","timeValue","datetimeValue","timestampValue","yearValue"'.
		self assert: csv lines second equals: '"1","1 July 2011","6:35:23 pm","2011-07-02T10:12:45+00:00","1980-01-12T00:45:56+00:00","1999"'.
		self assert: (resp rows first atIndex: 2) equals: (Date fromString: '07-01-2011').
		self assert: (resp rows first atIndex: 3) equals: (Time fromString: '18:35:23').
		self assert: (resp rows first atIndex: 4) equals: 
			(DateAndTime 
				localTimeZone: TimeZone default;  
				fromString: '2011-07-02T10:12:45.000000000').
		self assert: (resp rows first atIndex: 5) equals: 
			(DateAndTime 
				localTimeZone: TimeZone default; 
				fromString: '01-12-1980 00:45:56-00:00').
		self assert: (resp rows first atIndex: 6) equals: 1999.

		self assert: (resp rows second atIndex: 2) equals: (Date fromString: '06-01-2011').
		self assert: (resp rows second atIndex: 3) equals: (Duration fromString: '03:17:34:22').
		self assert: (resp rows second atIndex: 4) equals: 
			(DateAndTime 
				localTimeZone: TimeZone default; 
				fromString: '2011-06-02T09:11:44.000000').
		self assert: (resp rows second atIndex: 5) equals: 
					(DateAndTime  
						localTimeZone: TimeZone default; 
						fromString: '02-13-1980 01:44:55')]
		
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadTimeTypesNeg [
	| prep stmtId params resp stmt csv |
	self withFixtures: #(#times) do: [:conn |
		prep := conn prepare: 'select * from testTimes order by id'.
		stmtId := prep prepareOkay stmtHandlerId..
		params := #().

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; params: params.

		resp := stmt execute.
		self assert: resp isResultSet.
		csv := resp asCSV.
		self assert: resp rows size equals: 4.
		self assert: csv lines size equals: 5.
		self assert: csv lines first equals: '"id","dateValue","timeValue","datetimeValue","timestampValue","yearValue"'.
		self assert: csv lines fifth equals: '"4","","-0:16:33:21","","1980-03-14T02:43:54+00:00","2002"'.
		self assert: (resp rows fourth atIndex: 3) equals: (Duration fromString: '-00:16:33:21')]
	
]

{ #category : #tests }
MySQLStatementReadCSVTest >> testReadTimeTypesNull [
	| prep stmtId params resp stmt csv |
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
			csv := resp asCSV.
			self assert: resp rows size equals: 4.
			self assert: csv lines size equals: 5.
			self assert: csv lines first equals: '"id","dateValue","timeValue","datetimeValue","timestampValue","yearValue"'.
			self assert: csv lines fourth equals: '"3","","","","",""'.
			self assert: (resp rows third atIndex: 2) isNil.
			self assert: (resp rows third atIndex: 3) isNil.
			self assert: (resp rows third atIndex: 4) isNil.
			self assert: (resp rows third atIndex: 5) isNil.
			self assert: (resp rows fourth atIndex: 5) isNotNil ]
]
