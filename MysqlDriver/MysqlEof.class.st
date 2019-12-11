Class {
	#name : #MysqlEof,
	#superclass : #MysqlPacket,
	#instVars : [
		'fieldCount',
		'warningCount',
		'serverStatus'
	],
	#category : #'MysqlDriver-Packet'
}

{ #category : #'as yet unclassified' }
MysqlEof >> hasLastRowSent [
	^ (serverStatus bitAnd: MysqlServerStatus statusLastRowSent) ~= 0
	
]

{ #category : #'as yet unclassified' }
MysqlEof >> hasMoreResults [
	^ (serverStatus bitAnd: MysqlServerStatus moreResultsExist) ~= 0
	
]

{ #category : #'as yet unclassified' }
MysqlEof >> hasOpenCursor [
	^ (serverStatus bitAnd: MysqlServerStatus statusCursorExists) ~= 0
	
]

{ #category : #'as yet unclassified' }
MysqlEof >> isEof [
	^ true
]

{ #category : #'as yet unclassified' }
MysqlEof >> parse [
	fieldCount := inStream next.
	warningCount := inStream next + (inStream next bitShift: 8).
	serverStatus := inStream next + (inStream next bitShift: 8).

]

{ #category : #'as yet unclassified' }
MysqlEof >> serverStatus [
	^ serverStatus 
]

{ #category : #'as yet unclassified' }
MysqlEof >> warningCount [
	^ warningCount 
]
