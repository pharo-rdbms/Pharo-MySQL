"
MySQL Error packet
"
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
	#category : #'MySQL-Core-Packet-Results'
}

{ #category : #accessing }
MySQLOkay >> affectedRows [
	^ affectedRows 
]

{ #category : #testing }
MySQLOkay >> hasMoreResults [
	^ (serverStatus bitAnd: MySQLServerStatus moreResultsExist) ~= 0
	
]

{ #category : #accessing }
MySQLOkay >> inTransaction [
	| autoCommit inTx |
	autoCommit := (serverStatus bitAnd: MySQLServerStatus statusInTransaction) ~= 0.
	inTx := (serverStatus bitAnd: MySQLServerStatus statusInTransaction) ~= 0.
	^ autoCommit and: inTx
	
]

{ #category : #accessing }
MySQLOkay >> insertId [
	^ insertId 
]

{ #category : #testing }
MySQLOkay >> isOkay [
	^ true
]

{ #category : #accessing }
MySQLOkay >> message [
	^ message 
]

{ #category : #parsing }
MySQLOkay >> parse [ 
	fieldCount := self decodeLcbFrom: inStream . "always 0"
	affectedRows := self decodeLcbFrom: inStream .
	insertId := self decodeLcbFrom: inStream .
	serverStatus := inStream next + (inStream next bitShift: 8) .
	warningCount := inStream next + (inStream next bitShift: 8) .
	message := (inStream upToEnd) asString.
	
]

{ #category : #accessing }
MySQLOkay >> serverStatus [
	^ serverStatus 
]

{ #category : #accessing }
MySQLOkay >> warningCount [
	^ warningCount 
]
