"
MySQL Error packet
"
Class {
	#name : #MySQLError,
	#superclass : #MySQLResult,
	#instVars : [
		'fieldCount',
		'errNo',
		'sqlStateMarker',
		'sqlState',
		'message'
	],
	#category : #'MySQL-Core-Packet-Results'
}

{ #category : #accessing }
MySQLError >> errNo [
	^ errNo 
]

{ #category : #testing }
MySQLError >> isError [
	^ true
]

{ #category : #accessing }
MySQLError >> message [
	^ message 
]

{ #category : #parsing }
MySQLError >> parse [
	fieldCount := inStream next. "always 0xFF"
	errNo := inStream next + (inStream next bitShift: 8).	
	sqlStateMarker := inStream next asCharacter. "always #"
	sqlState := (inStream next: 5) asString .
	message := inStream upToEnd asString.

]

{ #category : #accessing }
MySQLError >> sqlState [
	^ sqlState 
]
