"
MySQL fetch command
"
Class {
	#name : 'MySQLCommandFetch',
	#superclass : 'MySQLCommandWithStatement',
	#instVars : [
		'numRows',
		'resultSetContext'
	],
	#category : 'MySQL-Core-Command',
	#package : 'MySQL-Core',
	#tag : 'Command'
}

{ #category : 'defaults' }
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

{ #category : 'defaults' }
MySQLCommandFetch >> commandCode [
	^ ComStmtFetch 
	
]

{ #category : 'accessing' }
MySQLCommandFetch >> numRows: count [
	numRows := count
	
]

{ #category : 'reading' }
MySQLCommandFetch >> readResponse [
	| resp |
	resp := self readResult.
	^ resp
	
]

{ #category : 'reading' }
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

{ #category : 'accessing' }
MySQLCommandFetch >> resultSetContext: partialResultSet [
	resultSetContext := partialResultSet 
	
]
