"
MySQL fetch command
"
Class {
	#name : #MySQLCommandFetch,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'stmtId',
		'numRows',
		'mapResultsToNativeTypes',
		'resultSetContext'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #defaults }
MySQLCommandFetch >> commandArg [
	ByteArray
		streamContents: [ :strm | 
			strm
				nextPut: (stmtId byteAt: 1);
				nextPut: (stmtId byteAt: 2);
				nextPut: (stmtId byteAt: 3);
				nextPut: (stmtId byteAt: 4);
				nextPut: (numRows byteAt: 1);
				nextPut: (numRows byteAt: 2);
				nextPut: (numRows byteAt: 3);
				nextPut: (numRows byteAt: 4).
			^ strm contents ]
]

{ #category : #defaults }
MySQLCommandFetch >> commandCode [
	^ ComStmtFetch 
	
]

{ #category : #accessing }
MySQLCommandFetch >> gotEof [
	^ (MySQLPacket from: session peek) isEof 

]

{ #category : #initialization }
MySQLCommandFetch >> initialize [
	super initialize.
	mapResultsToNativeTypes := true
	
]

{ #category : #accessing }
MySQLCommandFetch >> mapResultsToNativeTypes: aBoolean [
	mapResultsToNativeTypes := aBoolean
	
]

{ #category : #accessing }
MySQLCommandFetch >> numRows: count [
	numRows := count
	
]

{ #category : #reading }
MySQLCommandFetch >> readEof [
	^ MySQLEof from: session read

]

{ #category : #reading }
MySQLCommandFetch >> readOneRow: fields [ 
	| row |
	row := mapResultsToNativeTypes 
		ifTrue: [ MySQLBinaryRowData new ]
		ifFalse: [ MySQLStringRowData new ].
	row columnDescriptors: fields.
	row read: session read.
	^ row
]

{ #category : #reading }
MySQLCommandFetch >> readResponse [
	| resp |
	resp := self readResult.
	^ resp
	
]

{ #category : #reading }
MySQLCommandFetch >> readResult [
	| pkt fieldsEof rows fields rowsEof |
	pkt := MySQLPacket from: session peek.
	pkt isError ifTrue: [^ MySQLError from: session read].
	
	"If not error then zero or more row data packets followed by eof packet"
	fields := resultSetContext fields.
	fieldsEof := resultSetContext fieldsEof.
	fieldsEof hasOpenCursor ifTrue: [	
		rows := self readRowData: fields.
		rowsEof := self readEof. "eof"].
	
	^ resultSetContext
		rows: rows asOrderedCollection;
		rowsEof: rowsEof;
		yourself
		
]

{ #category : #reading }
MySQLCommandFetch >> readRowData: fields [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each row and save it"
		row := self readOneRow: fields.
		respRows add: row].
		
	^ respRows asArray

]

{ #category : #accessing }
MySQLCommandFetch >> resultSetContext: partialResultSet [
	resultSetContext := partialResultSet 
	
]

{ #category : #accessing }
MySQLCommandFetch >> statementId: id [
	stmtId := id
	
]
