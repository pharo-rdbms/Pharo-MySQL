Class {
	#name : #MySQLOkay,
	#superclass : #MySQLResult,
	#instVars : [
		'message',
		'fieldCount',
		'affectedRows',
		'insertId',
		'warningCount',
		'serverStatus'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLOkay >> affectedRows [
	^ affectedRows 
]

{ #category : #'as yet unclassified' }
MySQLOkay >> hasMoreResults [
	^ (serverStatus bitAnd: MySQLServerStatus moreResultsExist) ~= 0
	
]

{ #category : #'as yet unclassified' }
MySQLOkay >> inTransaction [
	| autoCommit inTx |
	autoCommit := (serverStatus bitAnd: MySQLServerStatus statusInTransaction) ~= 0.
	inTx := (serverStatus bitAnd: MySQLServerStatus statusInTransaction) ~= 0.
	^ autoCommit and: inTx
	
]

{ #category : #'as yet unclassified' }
MySQLOkay >> insertId [
	^ insertId 
]

{ #category : #'as yet unclassified' }
MySQLOkay >> isOkay [
	^ true
]

{ #category : #'as yet unclassified' }
MySQLOkay >> message [
	^ message 
]

{ #category : #'as yet unclassified' }
MySQLOkay >> parse [ 
	fieldCount := self decodeLcbFrom: inStream . "always 0"
	affectedRows := self decodeLcbFrom: inStream .
	insertId := self decodeLcbFrom: inStream .
	serverStatus := inStream next + (inStream next bitShift: 8) .
	warningCount := inStream next + (inStream next bitShift: 8) .
	message := (inStream upToEnd) asString.
	
]

{ #category : #'as yet unclassified' }
MySQLOkay >> serverStatus [
	^ serverStatus 
]

{ #category : #'as yet unclassified' }
MySQLOkay >> warningCount [
	^ warningCount 
]
