"
MySQL reset statement command
"
Class {
	#name : #MySQLCommandResetStatement,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'statementId'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #defaults }
MySQLCommandResetStatement >> commandArg [
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
MySQLCommandResetStatement >> commandCode [
	^ ComStmtReset 
	

]

{ #category : #reading }
MySQLCommandResetStatement >> readResponse [
	| pkt |

	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [^ pkt] 
		ifFalse: [self error: 'Unrecognized response for command']
		
]

{ #category : #accessing }
MySQLCommandResetStatement >> statementId: idValue [ "4 byte integer"
	statementId := idValue
	
	
]
