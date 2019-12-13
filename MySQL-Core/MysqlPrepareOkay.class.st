"
Prepare okay packet for MySQL
"
Class {
	#name : #MySQLPrepareOkay,
	#superclass : #MySQLPacket,
	#instVars : [
		'warningCount',
		'numColumns',
		'numParams',
		'stmtId'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #testing }
MySQLPrepareOkay >> isOkay [
	^ true
	
]

{ #category : #accessing }
MySQLPrepareOkay >> numColumns [
	^ numColumns
]

{ #category : #accessing }
MySQLPrepareOkay >> numParams [
	^ numParams
]

{ #category : #parsing }
MySQLPrepareOkay >> parse [ 
	inStream next.	"always 0, marker for oaky pakcet"
	stmtId := inStream next + (inStream next bitShift: 8) + 
			(inStream next bitShift: 16) + (inStream next bitShift: 24).
	numColumns := inStream next + (inStream next bitShift: 8).
	numParams := inStream next + (inStream next bitShift: 8).
	inStream next.	"filler, always 0"
	warningCount := inStream next + (inStream next bitShift: 8)
	
]

{ #category : #accessing }
MySQLPrepareOkay >> stmtHandlerId [
	^ stmtId
]

{ #category : #accessing }
MySQLPrepareOkay >> warningCount [
	^ warningCount
	
]
