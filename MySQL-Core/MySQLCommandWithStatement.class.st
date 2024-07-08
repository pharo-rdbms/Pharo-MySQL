Class {
	#name : 'MySQLCommandWithStatement',
	#superclass : 'MySQLCommandWithResults',
	#instVars : [
		'stmtId',
		'mapResultsToNativeTypes'
	],
	#category : 'MySQL-Core-Command',
	#package : 'MySQL-Core',
	#tag : 'Command'
}

{ #category : 'initialization' }
MySQLCommandWithStatement >> initialize [
	super initialize.
	mapResultsToNativeTypes := true
]

{ #category : 'accessing' }
MySQLCommandWithStatement >> mapResultsToNativeTypes: aBoolean [
	mapResultsToNativeTypes := aBoolean
]

{ #category : 'reading' }
MySQLCommandWithStatement >> readOneRow: fields [ 
	^self rowClass new
		columnDescriptors: fields;
		read: session read;
		yourself
]

{ #category : 'reading' }
MySQLCommandWithStatement >> readRowData: fields [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each row and save it"
		row := self readOneRow: fields.
		respRows add: row].
		
	^ respRows asArray
]

{ #category : 'accessing' }
MySQLCommandWithStatement >> rowClass [
	^mapResultsToNativeTypes 
		ifTrue: [ MySQLBinaryRowData ]
		ifFalse: [ MySQLStringRowData ]
]

{ #category : 'accessing' }
MySQLCommandWithStatement >> statementId: id [
	stmtId := id
]
