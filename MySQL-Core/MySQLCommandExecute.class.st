Class {
	#name : #MySQLCommandExecute,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'stmtId',
		'params',
		'cursoredFetch',
		'mapResultsToNativeTypes'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> commandArg [
	| paramType nonLongs |
	ByteArray
		streamContents: [ :strm | 
			strm
				nextPut: (stmtId byteAt: 1);
				nextPut: (stmtId byteAt: 2);
				nextPut: (stmtId byteAt: 3);
				nextPut: (stmtId byteAt: 4).
			cursoredFetch
				ifTrue: [ strm nextPut: 1	"flags => READ_CURSOR" ]
				ifFalse: [ strm nextPut: 0	"flags => NO_CURSOR" ].
			strm
				nextPut: 1;
				nextPut: 0;
				nextPut: 0;
				nextPut: 0.	"iterationCount"
			strm nextPutAll: self nullBitMap.
			self hasNewParamBound
				ifTrue: [ strm nextPut: 1.	"new params bound <- true"
					params
						do: [ :each | 
							paramType := each paramType.
							strm
								nextPut: (paramType byteAt: 1);
								nextPut: (paramType byteAt: 2) ] ]
				ifFalse: [ strm nextPut: 0 ].	"new params bound <- false"
			nonLongs := params
				ifNil: [ Array new ]
				ifNotNil: [ params reject: [ :each | each isLongData ] ].
			nonLongs do: [ :each | each storeBinaryOn: strm ].
			^ strm contents ]
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> commandCode [
	^ ComStmtExecute 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> cursoredFetch: aBoolean [ 
	cursoredFetch := aBoolean
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> execute [
	| resp |
	"Remember to send long data for the longdata params before calling here"
	resp := super execute.
	self resetNewParamBound.
	^ resp
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> gotEof [
	^ (MySQLPacket from: session peek) isEof 

]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> hasNewParamBound [
	^ params anySatisfy: [:each | each isRebound]
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> initialize [
	super initialize.
	cursoredFetch := false.
	mapResultsToNativeTypes := true
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> mapResultsToNativeTypes: aBoolean [
	mapResultsToNativeTypes := aBoolean
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> nullBitMap [
	| nullBitMap mapByte byteIndex bitMask |
	nullBitMap := ByteArray new: (params size + 7) // 8.
	params doWithIndex: [:each :paramIndex |
		each isNull ifTrue: [
			byteIndex := (paramIndex + 7) // 8.
			bitMask := 1 bitShift: (paramIndex + 7) \\ 8.
			mapByte := nullBitMap at: byteIndex.
			mapByte := mapByte bitOr: bitMask.
			nullBitMap at: byteIndex put: mapByte.
		]
	].

	^ nullBitMap 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> params: inParams [
	params := inParams.
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> readEof [
	^ MySQLEof from: session read

]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> readFields [
	| respFields field |
	respFields := OrderedCollection new.
	
	[self gotEof] whileFalse:[ 
		"Read each field and save it"
		field := self readOneField.
		respFields add: field ].
		
	^ respFields asArray
			
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> readOneField [
	^ MySQLField from: session read.

]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> readOneRow: fields [ 
	| row |
	row := mapResultsToNativeTypes 
		ifTrue: [ MySQLBinaryRowData new ]
		ifFalse: [ MySQLStringRowData new ].
	row columnDescriptors: fields.
	row read: session read.
	^ row
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> readResponse [
	| resp |
	resp := self readResult.
	"We do not need to look for multi-result responses in statement execute; so the following
	line of code is commented out. Check COM_QUERY response handling for multi-result"
	"resp hasMoreResults ifTrue: [resp next: self readResponse]."
	^ resp
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> readResult [
	| resultSetHdr pkt fieldsEof rows fields rowsEof |
	pkt := super readResponse.
	pkt isOkayOrError ifTrue: [^ pkt].
	
	resultSetHdr := MySQLResultSetHeader from: session read.
	fields := self readFields.
	fieldsEof := self readEof.	"eof"

	fieldsEof hasOpenCursor ifFalse: [	
		rows := self readRowData: fields.
		rowsEof := self readEof. "eof"].
	
	^ MySQLResultSet new
		header: resultSetHdr;
		fields: fields;
		fieldsEof: fieldsEof;
		rows: rows;
		rowsEof: rowsEof;
		yourself
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> readRowData: fields [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each row and save it"
		row := self readOneRow: fields.
		respRows add: row].
		
	^ respRows asArray

]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> resetNewParamBound [
	params do: [:each | each resetReboundFlag]
	
]

{ #category : #'as yet unclassified' }
MySQLCommandExecute >> statementId: id [
	stmtId := id
	
]
