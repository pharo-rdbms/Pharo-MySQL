Class {
	#name : #MySQLCommandPrepare,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'query'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> commandArg [
	^ query 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> commandCode [
	^ ComStmtPrepare 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> gotEof [
	| resp |
	resp := MySQLPacket from: session peek.
	^ resp isEof 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> queryString: queryString [ 
	query := queryString
	
]

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> readColumnDescr [
	^ MySQLField from: session read.

]

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> readEof [
	^ MySQLEof from: session read
	
]

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> readParamDescr [
	^ MySQLField from: session read.

]

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> readPrepareOkay [
	| prepOkay params columns paramEof columnEof indx |
	
	prepOkay := MySQLPrepareOkay from: session read.
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
		
	^ MySQLPrepareResponse new
		prepareOkay: prepOkay;
		paramDescriptors: params;
		paramEof: paramEof;
		columnDescriptors: columns;
		columnEof: columnEof;
		yourself
	
]

{ #category : #'as yet unclassified' }
MySQLCommandPrepare >> readResponse [
	| resp |
	resp := MySQLPacket from: session peek.
	resp isError ifTrue: [^ MySQLError from: session read].
	resp isOkay ifTrue: [^ self readPrepareOkay]

]
