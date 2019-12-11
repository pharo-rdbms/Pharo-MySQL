Class {
	#name : #MysqlComLongData,
	#superclass : #MysqlComBase,
	#instVars : [
		'dataBytes',
		'statementId',
		'paramNum'
	],
	#category : #'MysqlDriver-Command'
}

{ #category : #'as yet unclassified' }
MysqlComLongData >> commandArg [
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
MysqlComLongData >> commandCode [
	^ ComStmtSendLongData 
	
]

{ #category : #'as yet unclassified' }
MysqlComLongData >> dataBytes: aByteArray [
	dataBytes := aByteArray 
	
]

{ #category : #'as yet unclassified' }
MysqlComLongData >> paramNum: aNumber [
	paramNum := aNumber
	
]

{ #category : #'as yet unclassified' }
MysqlComLongData >> readResponse [
	"This command does not hae any response from server"
	^ nil
	
]

{ #category : #'as yet unclassified' }
MysqlComLongData >> statementId: anId [
	statementId := anId
	
]
