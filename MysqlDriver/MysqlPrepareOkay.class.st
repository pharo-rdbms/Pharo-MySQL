Class {
	#name : #MysqlPrepareOkay,
	#superclass : #MysqlPacket,
	#instVars : [
		'warningCount',
		'numColumns',
		'numParams',
		'stmtId'
	],
	#category : #'MysqlDriver-Packet'
}

{ #category : #'as yet unclassified' }
MysqlPrepareOkay >> isOkay [
	^ true
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareOkay >> numColumns [
	^ numColumns
]

{ #category : #'as yet unclassified' }
MysqlPrepareOkay >> numParams [
	^ numParams
]

{ #category : #'as yet unclassified' }
MysqlPrepareOkay >> parse [ 
	inStream next.	"always 0, marker for oaky pakcet"
	stmtId := inStream next + (inStream next bitShift: 8) + 
			(inStream next bitShift: 16) + (inStream next bitShift: 24).
	numColumns := inStream next + (inStream next bitShift: 8).
	numParams := inStream next + (inStream next bitShift: 8).
	inStream next.	"filler, always 0"
	warningCount := inStream next + (inStream next bitShift: 8)
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareOkay >> stmtHandlerId [
	^ stmtId
]

{ #category : #'as yet unclassified' }
MysqlPrepareOkay >> warningCount [
	^ warningCount
	
]
