Class {
	#name : #MysqlComFetch,
	#superclass : #MysqlComBase,
	#instVars : [
		'stmtId',
		'numRows',
		'mapResultsToNativeTypes',
		'resultSetContext'
	],
	#category : #'MysqlDriver-Command'
}

{ #category : #'as yet unclassified' }
MysqlComFetch >> commandArg [
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
MysqlComFetch >> commandCode [
	^ ComStmtFetch 
	
]

{ #category : #'as yet unclassified' }
MysqlComFetch >> gotEof [
	^ (MysqlPacket from: session peek) isEof 

]

{ #category : #'as yet unclassified' }
MysqlComFetch >> initialize [
	super initialize.
	mapResultsToNativeTypes := true
	
]

{ #category : #'as yet unclassified' }
MysqlComFetch >> mapResultsToNativeTypes: aBoolean [
	mapResultsToNativeTypes := aBoolean
	
]

{ #category : #'as yet unclassified' }
MysqlComFetch >> numRows: count [
	numRows := count
	
]

{ #category : #'as yet unclassified' }
MysqlComFetch >> readEof [
	^ MysqlEof from: session read

]

{ #category : #'as yet unclassified' }
MysqlComFetch >> readOneRow: fields [ 
	| row |
	row := mapResultsToNativeTypes 
		ifTrue: [ MysqlBinRowData new ]
		ifFalse: [ MysqlStringRowData new ].
	row columnDescriptors: fields.
	row read: session read.
	^ row
]

{ #category : #'as yet unclassified' }
MysqlComFetch >> readResponse [
	| resp |
	resp := self readResult.
	^ resp
	
]

{ #category : #'as yet unclassified' }
MysqlComFetch >> readResult [
	| pkt fieldsEof rows fields rowsEof |
	pkt := MysqlPacket from: session peek.
	pkt isError ifTrue: [^ MysqlError from: session read].
	
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
MysqlComFetch >> readRowData: fields [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each row and save it"
		row := self readOneRow: fields.
		respRows add: row].
		
	^ respRows asArray

]

{ #category : #'as yet unclassified' }
MysqlComFetch >> resultSetContext: partialResultSet [
	resultSetContext := partialResultSet 
	
]

{ #category : #'as yet unclassified' }
MysqlComFetch >> statementId: id [
	stmtId := id
	
]
