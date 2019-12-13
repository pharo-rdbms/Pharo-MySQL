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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> commandCode [
	^ ComStmtFetch 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> gotEof [
	^ (MySQLPacket from: session peek) isEof 

]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> initialize [
	super initialize.
	mapResultsToNativeTypes := true
	
]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> mapResultsToNativeTypes: aBoolean [
	mapResultsToNativeTypes := aBoolean
	
]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> numRows: count [
	numRows := count
	
]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> readEof [
	^ MySQLEof from: session read

]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> readOneRow: fields [ 
	| row |
	row := mapResultsToNativeTypes 
		ifTrue: [ MySQLBinaryRowData new ]
		ifFalse: [ MySQLStringRowData new ].
	row columnDescriptors: fields.
	row read: session read.
	^ row
]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> readResponse [
	| resp |
	resp := self readResult.
	^ resp
	
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> readRowData: fields [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each row and save it"
		row := self readOneRow: fields.
		respRows add: row].
		
	^ respRows asArray

]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> resultSetContext: partialResultSet [
	resultSetContext := partialResultSet 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandFetch >> statementId: id [
	stmtId := id
	
]
