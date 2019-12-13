Class {
	#name : #MysqlComQuery,
	#superclass : #MysqlComBase,
	#instVars : [
		'query'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MysqlComQuery >> commandArg [
	^ query 
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> commandCode [
	^ ComQuery 
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> gotEof [
	^ (MysqlPacket from: session peek) isEof 
	
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> queryString: queryString [ 
	query := queryString
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> readEof [
	^ MysqlEof from: session read

]

{ #category : #'as yet unclassified' }
MysqlComQuery >> readFields [
	| respFields field |
	respFields := OrderedCollection new.
	
	[self gotEof] whileFalse:[ 
		"Read each field and save it"
		field := self readOneField.
		respFields add: field ].
		
	^ respFields asArray
	
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> readOneField [
	^ MysqlField from: session read
	
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> readOneRow: fieldCount [
	| row |
	row := MysqlQueryRowData new.
	row columnCount: fieldCount.
	row read: session read.
	^ row
	
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> readResponse [
	| resp |
	resp := self readResult.
	resp hasMoreResults ifTrue: [resp nextResult: self readResponse].
	^ resp
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> readResult [
	| fields fieldsEof rows rowsEof resultSetHdr pkt |
	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [ ^ pkt ]
		ifFalse: [ resultSetHdr := self readRsHeader ].
	fields := self readFields.
	fieldsEof := self readEof.
	rows := self readRowData: resultSetHdr fieldCount.
	rowsEof := self readEof.
	^ MysqlResultSet new
		header: resultSetHdr;
		fields: fields;
		fieldsEof: fieldsEof;
		rows: rows;
		rowsEof: rowsEof;
		yourself
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> readRowData: fieldCount [ 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each field and save it"
		row := self readOneRow: fieldCount.
		respRows add: row].
		
	^ respRows asArray
	
]

{ #category : #'as yet unclassified' }
MysqlComQuery >> readRsHeader [
	^ MysqlResultSetHeader from: session read
	
]
