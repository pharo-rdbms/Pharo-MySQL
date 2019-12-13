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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
MySQLCommandLongData >> commandCode [
	^ ComStmtSendLongData 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandLongData >> dataBytes: aByteArray [
	dataBytes := aByteArray 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandLongData >> paramNum: aNumber [
	paramNum := aNumber
	
]

{ #category : #'as yet unclassified' }
MySQLCommandLongData >> readResponse [
	"This command does not hae any response from server"
	^ nil
	
]

{ #category : #'as yet unclassified' }
MySQLCommandLongData >> statementId: anId [
	statementId := anId
	
]
