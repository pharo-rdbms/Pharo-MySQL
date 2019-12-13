"
MySQL command to execute
"
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

{ #category : #defaults }
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

{ #category : #defaults }
MySQLCommandExecute >> commandCode [
	^ ComStmtExecute 
	
]

{ #category : #accessing }
MySQLCommandExecute >> cursoredFetch: aBoolean [ 
	cursoredFetch := aBoolean
	
]

{ #category : #operating }
MySQLCommandExecute >> execute [
	| resp |
	"Remember to send long data for the longdata params before calling here"
	resp := super execute.
	self resetNewParamBound.
	^ resp
	
]

{ #category : #testing }
MySQLCommandExecute >> gotEof [
	^ (MySQLPacket from: session peek) isEof 

]

{ #category : #testing }
MySQLCommandExecute >> hasNewParamBound [
	^ params anySatisfy: [:each | each isRebound]
	
]

{ #category : #initialization }
MySQLCommandExecute >> initialize [
	super initialize.
	cursoredFetch := false.
	mapResultsToNativeTypes := true
	
]

{ #category : #accessing }
MySQLCommandExecute >> mapResultsToNativeTypes: aBoolean [
	mapResultsToNativeTypes := aBoolean
	
]

{ #category : #'private - accessing' }
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

{ #category : #accessing }
MySQLCommandExecute >> params: inParams [
	params := inParams
	
]

{ #category : #reading }
MySQLCommandExecute >> readEof [
	^ MySQLEof from: session read

]

{ #category : #reading }
MySQLCommandExecute >> readFields [
	| respFields field |
	respFields := OrderedCollection new.
	
	[self gotEof] whileFalse:[ 
		"Read each field and save it"
		field := self readOneField.
		respFields add: field ].
		
	^ respFields asArray
			
]

{ #category : #reading }
MySQLCommandExecute >> readOneField [
	^ MySQLField from: session read.

]

{ #category : #reading }
MySQLCommandExecute >> readOneRow: fields [ 
	| row |
	row := mapResultsToNativeTypes 
		ifTrue: [ MySQLBinaryRowData new ]
		ifFalse: [ MySQLStringRowData new ].
	row columnDescriptors: fields.
	row read: session read.
	^ row
]

{ #category : #reading }
MySQLCommandExecute >> readResponse [
	| resp |
	resp := self readResult.
	"We do not need to look for multi-result responses in statement execute; so the following
	line of code is commented out. Check COM_QUERY response handling for multi-result"
	"resp hasMoreResults ifTrue: [resp next: self readResponse]."
	^ resp
	
]

{ #category : #reading }
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

{ #category : #reading }
MySQLCommandExecute >> readRowData: fields [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each row and save it"
		row := self readOneRow: fields.
		respRows add: row].
		
	^ respRows asArray

]

{ #category : #operating }
MySQLCommandExecute >> resetNewParamBound [
	params do: [:each | each resetReboundFlag]
	
]

{ #category : #accessing }
MySQLCommandExecute >> statementId: id [
	stmtId := id
	
]
