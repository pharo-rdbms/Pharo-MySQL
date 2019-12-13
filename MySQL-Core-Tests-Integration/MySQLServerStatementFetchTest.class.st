Class {
	#name : #MySQLServerStatementFetchTest,
	#superclass : #MySQLTestCase,
	#instVars : [
		'stmt'
	],
	#category : #'MySQL-Core-Tests-Integration-Base'
}

{ #category : #'as yet unclassified' }
MySQLServerStatementFetchTest >> scenarios [
^ '
- should read zero rows
- should read one row
- should read some rows
- should read all rows in batches 
'

]

{ #category : #'as yet unclassified' }
MySQLServerStatementFetchTest >> setUp [
	|  stmtId resp |
	super setUp.
	
	self withFixtures: #(#zero) do: [:conn | 
		resp := conn prepare: 
			'select name, value, entryOn, notes from testMisc 
			where entryOn < ?'.
		stmtId := resp prepareOkay stmtHandlerId.

		stmt := MySQLDriverStatement onConnection: conn.
		stmt stmtId: stmtId; cursoredFetch: true]
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementFetchTest >> tearDown [
	super tearDown.
	stmt close
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementFetchTest >> testReadAllRowsAtATime [
	| rs rd |
	stmt params: (Array with: (MySQLBindParameter withValue: '2011-09-01')) .
	rs := stmt execute.
	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.
	rd := stmt fetchRows: 1000.
	self assert: rd rows size = 10; assert: rs hasOpenCursor; assert: rd hasLastRowSent.
	rd := stmt fetchRows: 1.
	self assert: rd isError
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementFetchTest >> testReadOneRowAtATime [
	| rs rd |
	stmt params: (Array with:  (MySQLBindParameter withValue: '2011-09-01')).
	rs := stmt execute.
	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.
	10 timesRepeat: [
		rd := stmt fetchRows: 1.
		self assert: rd rows size = 1; deny: rd hasLastRowSent].
	rd := stmt fetchRows: 1.
	self 
		assert: rd rows isEmpty; 
		assert: rd hasLastRowSent.
	
]

{ #category : #'as yet unclassified' }
MySQLServerStatementFetchTest >> testReadSomeRowsAtATime [
	| rs rd |
	stmt params: (Array with: (MySQLBindParameter withValue: '2011-09-01')).
	rs := stmt execute.
	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.
	3 timesRepeat: [
		rd := stmt fetchRows: 3.
		self assert: rd rows size = 3; deny: rd hasLastRowSent].
	rd := stmt fetchRows: 3.
	self assert: rd rows size = 1; assert: rd hasLastRowSent.
		
]
