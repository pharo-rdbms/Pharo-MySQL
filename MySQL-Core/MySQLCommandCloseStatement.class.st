Class {
	#name : #MySQLCommandCloseStatement,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'statementId'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
MySQLCommandCloseStatement >> commandCode [
	^ ComStmtClose
	

]

{ #category : #'as yet unclassified' }
MySQLCommandCloseStatement >> readResponse [
	^ nil
	
]

{ #category : #'as yet unclassified' }
MySQLCommandCloseStatement >> statementId: idValue [ "4 byte integer"
	statementId := idValue
	
	
]
