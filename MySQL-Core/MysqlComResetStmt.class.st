Class {
	#name : #MysqlComResetStmt,
	#superclass : #MysqlComBase,
	#instVars : [
		'statementId'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MysqlComResetStmt >> commandArg [
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
MysqlComResetStmt >> commandCode [
	^ ComStmtReset 
	

]

{ #category : #'as yet unclassified' }
MysqlComResetStmt >> readResponse [
	| pkt |

	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [^ pkt] 
		ifFalse: [self error: 'Unrecognized response for command']
		
]

{ #category : #'as yet unclassified' }
MysqlComResetStmt >> statementId: idValue [ "4 byte integer"
	statementId := idValue
	
	
]
