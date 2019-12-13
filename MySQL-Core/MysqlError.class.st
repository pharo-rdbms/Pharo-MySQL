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
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLError >> errNo [
	^ errNo 
]

{ #category : #'as yet unclassified' }
MySQLError >> isError [
	^ true
]

{ #category : #'as yet unclassified' }
MySQLError >> message [
	^ message 
]

{ #category : #'as yet unclassified' }
MySQLError >> parse [
	fieldCount := inStream next. "always 0xFF"
	errNo := inStream next + (inStream next bitShift: 8).	
	sqlStateMarker := inStream next asCharacter. "always #"
	sqlState := (inStream next: 5) asString .
	message := inStream upToEnd asString.

]

{ #category : #'as yet unclassified' }
MySQLError >> sqlState [
	^ sqlState 
]
