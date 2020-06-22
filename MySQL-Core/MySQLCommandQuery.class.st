"
MySQL query command
"
Class {
	#name : #MySQLCommandQuery,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'query'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #defaults }
MySQLCommandQuery >> commandArg [
	^ query 
]

{ #category : #defaults }
MySQLCommandQuery >> commandCode [
	^ ComQuery 
]

{ #category : #testing }
MySQLCommandQuery >> gotEof [
	^ (MySQLPacket from: session peek) isEof 
	
]

{ #category : #accessing }
MySQLCommandQuery >> queryString: queryString [ 
	query := queryString
]

{ #category : #reading }
MySQLCommandQuery >> readEof [
	^ MySQLEof from: session read

]

{ #category : #reading }
MySQLCommandQuery >> readFields [
	| respFields field |
	respFields := OrderedCollection new.
	
	[self gotEof] whileFalse:[ 
		"Read each field and save it"
		field := self readOneField.
		respFields add: field ].
		
	^ respFields asArray
	
]

{ #category : #reading }
MySQLCommandQuery >> readOneField [
	^ MySQLField from: session read
	
]

{ #category : #reading }
MySQLCommandQuery >> readOneRow: fieldCount [
	| row |
	row := MySQLQueryRowData new.
	row columnCount: fieldCount.
	row read: session read.
	^ row
	
]

{ #category : #reading }
MySQLCommandQuery >> readOneRow: fieldCount fields: fields [
	| row |
	row := MySQLQueryRowData new fields: fields; yourself.
	row columnCount: fieldCount.
	row read: session read.
	^ row
	
]

{ #category : #reading }
MySQLCommandQuery >> readResponse [
	| resp |
	resp := self readResult.
	resp hasMoreResults ifTrue: [resp nextResult: self readResponse].
	^ resp
]

{ #category : #reading }
MySQLCommandQuery >> readResult [
	| fields fieldsEof rows rowsEof resultSetHdr pkt |
	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [ ^ pkt ]
		ifFalse: [ resultSetHdr := self readRsHeader ].
	fields := self readFields.
	fieldsEof := self readEof.
	rows := self readRowData: resultSetHdr fieldCount fields: fields.
	rowsEof := self readEof.
	^ MySQLResultSet new
		header: resultSetHdr;
		fields: fields;
		fieldsEof: fieldsEof;
		rows: rows;
		rowsEof: rowsEof;
		yourself
]

{ #category : #reading }
MySQLCommandQuery >> readRowData: fieldCount [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each field and save it"
		row := self readOneRow: fieldCount.
		respRows add: row].
		
	^ respRows asArray
	
]

{ #category : #reading }
MySQLCommandQuery >> readRowData: fieldCount fields: fields [
	| respRows row |
	respRows := OrderedCollection new.
	[self gotEof] whileFalse: [ 
		"Read each field and save it"
		row := self readOneRow: fieldCount fields: fields.
		respRows add: row].
		
	^ respRows asArray
	
]

{ #category : #reading }
MySQLCommandQuery >> readRsHeader [
	^ MySQLResultSetHeader from: session read
	
]
