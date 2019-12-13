Class {
	#name : #MysqlComCloseStmt,
	#superclass : #MysqlComBase,
	#instVars : [
		'statementId'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MysqlComCloseStmt >> commandArg [
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
MysqlComCloseStmt >> commandCode [
	^ ComStmtClose
	

]

{ #category : #'as yet unclassified' }
MysqlComCloseStmt >> readResponse [
	^ nil
	
]

{ #category : #'as yet unclassified' }
MysqlComCloseStmt >> statementId: idValue [ "4 byte integer"
	statementId := idValue
	
	
]
