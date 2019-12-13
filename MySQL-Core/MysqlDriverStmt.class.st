Class {
	#name : #MysqlDriverStmt,
	#superclass : #Object,
	#instVars : [
		'driver',
		'typeMapResults',
		'stmtId',
		'params',
		'rsContext',
		'cursoredFetch',
		'fetchSize'
	],
	#category : #'MySQL-Core-Driver'
}

{ #category : #'as yet unclassified' }
MysqlDriverStmt class >> onConnection: aDriver [
	^ self new
		driver: aDriver;
		yourself
		
]

{ #category : #'as yet unclassified' }
MysqlDriverStmt >> addBinding: anObject [
	
	params add: (MysqlBindParam new bindValue: anObject)
]

{ #category : #accessing }
MysqlDriverStmt >> close [
	| cmd |
	cmd := MysqlComCloseStmt onSession: driver netSession.
	cmd statementId: stmtId.
	^ cmd execute.
	
]

{ #category : #accessing }
MysqlDriverStmt >> cursoredFetch [
	^ cursoredFetch
]

{ #category : #accessing }
MysqlDriverStmt >> cursoredFetch: aBoolean [ 
	cursoredFetch := aBoolean
]

{ #category : #accessing }
MysqlDriverStmt >> driver: aDriver [
	driver := aDriver
	
]

{ #category : #accessing }
MysqlDriverStmt >> execute [
	| cmd resp |
	resp := self resetStmt.
	resp isError ifTrue: [ ^ resp ].
	self sendLongData.
	cmd := MysqlComExecute onSession: driver netSession.
	cmd
		cursoredFetch: cursoredFetch;
		mapResultsToNativeTypes: typeMapResults;
		statementId: stmtId;
		params: params asArray.
	resp := cmd execute.
	resp isError ifTrue: [ self error: resp message ].
	
	
	rsContext := resp isResultSet 
		ifTrue: [ 
			resp statement: self.
			resp ]
		ifFalse: [ nil ].
	^ resp
]

{ #category : #accessing }
MysqlDriverStmt >> fetchRows: num [
	| cmd |
	cmd := MysqlComFetch onSession: driver netSession.
	cmd
		resultSetContext: rsContext;
		statementId: stmtId;
		numRows: num.		
	^ cmd execute
	 
]

{ #category : #accessing }
MysqlDriverStmt >> fetchSize [
	
	^ fetchSize
]

{ #category : #cursor }
MysqlDriverStmt >> fetchSize: anInteger [ 
	
	self cursoredFetch: true.
	fetchSize := anInteger
]

{ #category : #'initialize-release' }
MysqlDriverStmt >> initialize [
	params := OrderedCollection new.
	cursoredFetch := false.
	typeMapResults := true
]

{ #category : #accessing }
MysqlDriverStmt >> params: bindParams [
	params := bindParams
	
]

{ #category : #accessing }
MysqlDriverStmt >> resetStmt [
	| cmd |
	cmd := MysqlComResetStmt onSession: driver netSession.
	cmd statementId: stmtId.
	^ cmd execute.
	
]

{ #category : #private }
MysqlDriverStmt >> sendLongData [
	| |
	params doWithIndex: [:aParam :indx |
		aParam isLongData ifTrue: [
			self sendLongParam: aParam withNum: indx - 1. "first param index is 0"
			aParam sentAsLongData: true "mark that it has been sent as long data"]]
	
]

{ #category : #private }
MysqlDriverStmt >> sendLongParam: aParam withNum: paramNum [
	| cmd dataStream dataPart |
	
	dataStream := ReadStream on: aParam stringOrBlobBytesRaw.
	[
		dataPart := dataStream next: 1048576. "1 MB; default"
		cmd := MysqlComLongData onSession: driver netSession.
		cmd 
			paramNum: paramNum;
			statementId: stmtId; 
			dataBytes: dataPart.
		cmd execute] doWhileFalse: [dataStream atEnd]
	
]

{ #category : #accessing }
MysqlDriverStmt >> stmtId: anId [
	stmtId := anId
	
]

{ #category : #accessing }
MysqlDriverStmt >> typeMapResults: aBoolean [
	typeMapResults := aBoolean
	
]
