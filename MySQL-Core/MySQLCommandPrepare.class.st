"
MySQL prepare command
"
Class {
	#name : #MySQLCommandPrepare,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'query'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #defaults }
MySQLCommandPrepare >> commandArg [
	^ query 
	
]

{ #category : #defaults }
MySQLCommandPrepare >> commandCode [
	^ ComStmtPrepare 
	
]

{ #category : #testing }
MySQLCommandPrepare >> gotEof [
	| resp |
	resp := MySQLPacket from: session peek.
	^ resp isEof 
	
]

{ #category : #accessing }
MySQLCommandPrepare >> queryString: queryString [ 
	query := queryString
	
]

{ #category : #reading }
MySQLCommandPrepare >> readColumnDescr [
	^ MySQLField from: session read.

]

{ #category : #reading }
MySQLCommandPrepare >> readEof [
	^ MySQLEof from: session read
	
]

{ #category : #reading }
MySQLCommandPrepare >> readParamDescr [
	^ MySQLField from: session read.

]

{ #category : #reading }
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

{ #category : #reading }
MySQLCommandPrepare >> readResponse [
	| resp |
	resp := MySQLPacket from: session peek.
	resp isError ifTrue: [^ MySQLError from: session read].
	resp isOkay ifTrue: [^ self readPrepareOkay]

]
