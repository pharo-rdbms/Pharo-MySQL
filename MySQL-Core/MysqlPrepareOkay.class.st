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

{ #category : #'as yet unclassified' }
MySQLPrepareOkay >> isOkay [
	^ true
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareOkay >> numColumns [
	^ numColumns
]

{ #category : #'as yet unclassified' }
MySQLPrepareOkay >> numParams [
	^ numParams
]

{ #category : #'as yet unclassified' }
MySQLPrepareOkay >> parse [ 
	inStream next.	"always 0, marker for oaky pakcet"
	stmtId := inStream next + (inStream next bitShift: 8) + 
			(inStream next bitShift: 16) + (inStream next bitShift: 24).
	numColumns := inStream next + (inStream next bitShift: 8).
	numParams := inStream next + (inStream next bitShift: 8).
	inStream next.	"filler, always 0"
	warningCount := inStream next + (inStream next bitShift: 8)
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareOkay >> stmtHandlerId [
	^ stmtId
]

{ #category : #'as yet unclassified' }
MySQLPrepareOkay >> warningCount [
	^ warningCount
	
]
