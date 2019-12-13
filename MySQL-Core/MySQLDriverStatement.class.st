Class {
	#name : #MySQLDriverStatement,
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
MySQLDriverStatement class >> onConnection: aDriver [
	^ self new
		driver: aDriver;
		yourself
		
]

{ #category : #'as yet unclassified' }
MySQLDriverStatement >> addBinding: anObject [
	
	params add: (MySQLBindParameter new bindValue: anObject)
]

{ #category : #accessing }
MySQLDriverStatement >> close [
	| cmd |
	cmd := MySQLCommandCloseStatement onSession: driver netSession.
	cmd statementId: stmtId.
	^ cmd execute.
	
]

{ #category : #accessing }
MySQLDriverStatement >> cursoredFetch [
	^ cursoredFetch
]

{ #category : #accessing }
MySQLDriverStatement >> cursoredFetch: aBoolean [ 
	cursoredFetch := aBoolean
]

{ #category : #accessing }
MySQLDriverStatement >> driver: aDriver [
	driver := aDriver
	
]

{ #category : #accessing }
MySQLDriverStatement >> execute [
	| cmd resp |
	resp := self resetStmt.
	resp isError ifTrue: [ ^ resp ].
	self sendLongData.
	cmd := MySQLCommandExecute onSession: driver netSession.
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
MySQLDriverStatement >> fetchRows: num [
	| cmd |
	cmd := MySQLCommandFetch onSession: driver netSession.
	cmd
		resultSetContext: rsContext;
		statementId: stmtId;
		numRows: num.		
	^ cmd execute
	 
]

{ #category : #accessing }
MySQLDriverStatement >> fetchSize [
	
	^ fetchSize
]

{ #category : #cursor }
MySQLDriverStatement >> fetchSize: anInteger [ 
	
	self cursoredFetch: true.
	fetchSize := anInteger
]

{ #category : #'initialize-release' }
MySQLDriverStatement >> initialize [
	params := OrderedCollection new.
	cursoredFetch := false.
	typeMapResults := true
]

{ #category : #accessing }
MySQLDriverStatement >> params: bindParams [
	params := bindParams
	
]

{ #category : #accessing }
MySQLDriverStatement >> resetStmt [
	| cmd |
	cmd := MySQLCommandResetStatement onSession: driver netSession.
	cmd statementId: stmtId.
	^ cmd execute.
	
]

{ #category : #private }
MySQLDriverStatement >> sendLongData [
	| |
	params doWithIndex: [:aParam :indx |
		aParam isLongData ifTrue: [
			self sendLongParam: aParam withNum: indx - 1. "first param index is 0"
			aParam sentAsLongData: true "mark that it has been sent as long data"]]
	
]

{ #category : #private }
MySQLDriverStatement >> sendLongParam: aParam withNum: paramNum [
	| cmd dataStream dataPart |
	
	dataStream := ReadStream on: aParam stringOrBlobBytesRaw.
	[
		dataPart := dataStream next: 1048576. "1 MB; default"
		cmd := MySQLCommandLongData onSession: driver netSession.
		cmd 
			paramNum: paramNum;
			statementId: stmtId; 
			dataBytes: dataPart.
		cmd execute] doWhileFalse: [dataStream atEnd]
	
]

{ #category : #accessing }
MySQLDriverStatement >> stmtId: anId [
	stmtId := anId
	
]

{ #category : #accessing }
MySQLDriverStatement >> typeMapResults: aBoolean [
	typeMapResults := aBoolean
	
]
