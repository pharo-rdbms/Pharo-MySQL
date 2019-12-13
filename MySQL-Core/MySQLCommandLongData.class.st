"
MySQL command for long datas
"
Class {
	#name : #MySQLCommandLongData,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'dataBytes',
		'statementId',
		'paramNum'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #defaults }
MySQLCommandLongData >> commandArg [
	ByteArray
		streamContents: [ :strm | 
			strm
				nextPut: (statementId byteAt: 1);
				nextPut: (statementId byteAt: 2);
				nextPut: (statementId byteAt: 3);
				nextPut: (statementId byteAt: 4).
			strm
				nextPut: (paramNum byteAt: 1);
				nextPut: (paramNum byteAt: 2).
			strm nextPutAll: dataBytes.
			^ strm contents ]
]

{ #category : #defaults }
MySQLCommandLongData >> commandCode [
	^ ComStmtSendLongData 
	
]

{ #category : #accessing }
MySQLCommandLongData >> dataBytes: aByteArray [
	dataBytes := aByteArray 
	
]

{ #category : #accessing }
MySQLCommandLongData >> paramNum: aNumber [
	paramNum := aNumber
	
]

{ #category : #reading }
MySQLCommandLongData >> readResponse [
	"This command does not have any response from server"
	^ nil
	
]

{ #category : #accessing }
MySQLCommandLongData >> statementId: anId [
	statementId := anId
	
]
