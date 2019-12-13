Class {
	#name : #MysqlOkay,
	#superclass : #MysqlResult,
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
MysqlOkay >> affectedRows [
	^ affectedRows 
]

{ #category : #'as yet unclassified' }
MysqlOkay >> hasMoreResults [
	^ (serverStatus bitAnd: MysqlServerStatus moreResultsExist) ~= 0
	
]

{ #category : #'as yet unclassified' }
MysqlOkay >> inTransaction [
	| autoCommit inTx |
	autoCommit := (serverStatus bitAnd: MysqlServerStatus statusInTransaction) ~= 0.
	inTx := (serverStatus bitAnd: MysqlServerStatus statusInTransaction) ~= 0.
	^ autoCommit and: inTx
	
]

{ #category : #'as yet unclassified' }
MysqlOkay >> insertId [
	^ insertId 
]

{ #category : #'as yet unclassified' }
MysqlOkay >> isOkay [
	^ true
]

{ #category : #'as yet unclassified' }
MysqlOkay >> message [
	^ message 
]

{ #category : #'as yet unclassified' }
MysqlOkay >> parse [ 
	fieldCount := self decodeLcbFrom: inStream . "always 0"
	affectedRows := self decodeLcbFrom: inStream .
	insertId := self decodeLcbFrom: inStream .
	serverStatus := inStream next + (inStream next bitShift: 8) .
	warningCount := inStream next + (inStream next bitShift: 8) .
	message := (inStream upToEnd) asString.
	
]

{ #category : #'as yet unclassified' }
MysqlOkay >> serverStatus [
	^ serverStatus 
]

{ #category : #'as yet unclassified' }
MysqlOkay >> warningCount [
	^ warningCount 
]
