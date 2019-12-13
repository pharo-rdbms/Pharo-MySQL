"
MySQL command to close statement
"
Class {
	#name : #MySQLCommandCloseStatement,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'statementId'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #defaults }
MySQLCommandCloseStatement >> commandArg [
	ByteArray
		streamContents: [ :strm | 
			strm
				nextPut: (statementId byteAt: 1);
				nextPut: (statementId byteAt: 2);
				nextPut: (statementId byteAt: 3);
				nextPut: (statementId byteAt: 4).
			^ strm contents ]
]

{ #category : #defaults }
MySQLCommandCloseStatement >> commandCode [
	^ ComStmtClose
	

]

{ #category : #operating }
MySQLCommandCloseStatement >> readResponse [
	^ nil
	
]

{ #category : #accessing }
MySQLCommandCloseStatement >> statementId: idValue [ 
	"4 byte integer"
	statementId := idValue
	
	
]
