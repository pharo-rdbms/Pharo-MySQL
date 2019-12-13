Class {
	#name : #MySQLCommandQuery,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'query'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> commandArg [
	^ query 
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> commandCode [
	^ ComQuery 
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> gotEof [
	^ (MySQLPacket from: session peek) isEof 
	
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> queryString: queryString [ 
	query := queryString
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> readEof [
	^ MySQLEof from: session read

]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> readFields [
	| respFields field |
	respFields := OrderedCollection new.
	
	[self gotEof] whileFalse:[ 
		"Read each field and save it"
		field := self readOneField.
		respFields add: field ].
		
	^ respFields asArray
	
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> readOneField [
	^ MySQLField from: session read
	
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> readOneRow: fieldCount [
	| row |
	row := MySQLQueryRowData new.
	row columnCount: fieldCount.
	row read: session read.
	^ row
	
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> readResponse [
	| resp |
	resp := self readResult.
	resp hasMoreResults ifTrue: [resp nextResult: self readResponse].
	^ resp
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> readResult [
	| fields fieldsEof rows rowsEof resultSetHdr pkt |
	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [ ^ pkt ]
		ifFalse: [ resultSetHdr := self readRsHeader ].
	fields := self readFields.
	fieldsEof := self readEof.
	rows := self readRowData: resultSetHdr fieldCount.
	rowsEof := self readEof.
	^ MySQLResultSet new
		header: resultSetHdr;
		fields: fields;
		fieldsEof: fieldsEof;
		rows: rows;
		rowsEof: rowsEof;
		yourself
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> readRowData: fieldCount [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each field and save it"
		row := self readOneRow: fieldCount.
		respRows add: row].
		
	^ respRows asArray
	
]

{ #category : #'as yet unclassified' }
MySQLCommandQuery >> readRsHeader [
	^ MySQLResultSetHeader from: session read
	
]
