Class {
	#name : #MysqlError,
	#superclass : #MysqlResult,
	#instVars : [
		'fieldCount',
		'errNo',
		'sqlStateMarker',
		'sqlState',
		'message'
	],
	#category : #'MySQL-Packet'
}

{ #category : #'as yet unclassified' }
MysqlError >> errNo [
	^ errNo 
]

{ #category : #'as yet unclassified' }
MysqlError >> isError [
	^ true
]

{ #category : #'as yet unclassified' }
MysqlError >> message [
	^ message 
]

{ #category : #'as yet unclassified' }
MysqlError >> parse [
	fieldCount := inStream next. "always 0xFF"
	errNo := inStream next + (inStream next bitShift: 8).	
	sqlStateMarker := inStream next asCharacter. "always #"
	sqlState := (inStream next: 5) asString .
	message := inStream upToEnd asString.

]

{ #category : #'as yet unclassified' }
MysqlError >> sqlState [
	^ sqlState 
]
