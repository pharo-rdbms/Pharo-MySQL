Class {
	#name : #MysqlComPrepare,
	#superclass : #MysqlComBase,
	#instVars : [
		'query'
	],
	#category : #'MySQL-Command'
}

{ #category : #'as yet unclassified' }
MysqlComPrepare >> commandArg [
	^ query 
	
]

{ #category : #'as yet unclassified' }
MysqlComPrepare >> commandCode [
	^ ComStmtPrepare 
	
]

{ #category : #'as yet unclassified' }
MysqlComPrepare >> gotEof [
	| resp |
	resp := MysqlPacket from: session peek.
	^ resp isEof 
	
]

{ #category : #'as yet unclassified' }
MysqlComPrepare >> queryString: queryString [ 
	query := queryString
	
]

{ #category : #'as yet unclassified' }
MysqlComPrepare >> readColumnDescr [
	^ MysqlField from: session read.

]

{ #category : #'as yet unclassified' }
MysqlComPrepare >> readEof [
	^ MysqlEof from: session read
	
]

{ #category : #'as yet unclassified' }
MysqlComPrepare >> readParamDescr [
	^ MysqlField from: session read.

]

{ #category : #'as yet unclassified' }
MysqlComPrepare >> readPrepareOkay [
	| prepOkay params columns paramEof columnEof indx |
	
	prepOkay := MysqlPrepareOkay from: session read.
	params := Array new: prepOkay numParams.
	columns := Array new: prepOkay numColumns.
	
	prepOkay numParams > 0 ifTrue: [
		indx := 1.	
		[self gotEof] whileFalse: [
			params at: indx put: self readParamDescr.
			indx := indx + 1 ].
		paramEof := self readEof "eof"].

	prepOkay numColumns > 0 ifTrue: [	
		indx := 1.
		[self gotEof ] whileFalse: [
			columns at: indx put: self readColumnDescr.
			indx := indx + 1 ].
		columnEof := self readEof "eof"].
		
	^ MysqlPrepareResp new
		prepareOkay: prepOkay;
		paramDescriptors: params;
		paramEof: paramEof;
		columnDescriptors: columns;
		columnEof: columnEof;
		yourself
	
]

{ #category : #'as yet unclassified' }
MysqlComPrepare >> readResponse [
	| resp |
	resp := MysqlPacket from: session peek.
	resp isError ifTrue: [^ MysqlError from: session read].
	resp isOkay ifTrue: [^ self readPrepareOkay]

]
