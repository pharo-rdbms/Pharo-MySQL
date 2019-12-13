Class {
	#name : #MySQLEof,
	#superclass : #MySQLPacket,
	#instVars : [
		'fieldCount',
		'warningCount',
		'serverStatus'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLEof >> hasLastRowSent [
	^ (serverStatus bitAnd: MySQLServerStatus statusLastRowSent) ~= 0
	
]

{ #category : #'as yet unclassified' }
MySQLEof >> hasMoreResults [
	^ (serverStatus bitAnd: MySQLServerStatus moreResultsExist) ~= 0
	
]

{ #category : #'as yet unclassified' }
MySQLEof >> hasOpenCursor [
	^ (serverStatus bitAnd: MySQLServerStatus statusCursorExists) ~= 0
	
]

{ #category : #'as yet unclassified' }
MySQLEof >> isEof [
	^ true
]

{ #category : #'as yet unclassified' }
MySQLEof >> parse [
	fieldCount := inStream next.
	warningCount := inStream next + (inStream next bitShift: 8).
	serverStatus := inStream next + (inStream next bitShift: 8).

]

{ #category : #'as yet unclassified' }
MySQLEof >> serverStatus [
	^ serverStatus 
]

{ #category : #'as yet unclassified' }
MySQLEof >> warningCount [
	^ warningCount 
]
