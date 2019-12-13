"
End of File (EOF) received
"
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

{ #category : #testing }
MySQLEof >> hasLastRowSent [
	^ (serverStatus bitAnd: MySQLServerStatus statusLastRowSent) ~= 0
	
]

{ #category : #testing }
MySQLEof >> hasMoreResults [
	^ (serverStatus bitAnd: MySQLServerStatus moreResultsExist) ~= 0
	
]

{ #category : #testing }
MySQLEof >> hasOpenCursor [
	^ (serverStatus bitAnd: MySQLServerStatus statusCursorExists) ~= 0
	
]

{ #category : #testing }
MySQLEof >> isEof [
	^ true
]

{ #category : #accessing }
MySQLEof >> parse [
	fieldCount := inStream next.
	warningCount := inStream next + (inStream next bitShift: 8).
	serverStatus := inStream next + (inStream next bitShift: 8).

]

{ #category : #accessing }
MySQLEof >> serverStatus [
	^ serverStatus 
]

{ #category : #accessing }
MySQLEof >> warningCount [
	^ warningCount 
]
