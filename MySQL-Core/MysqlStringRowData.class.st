"
String row data packet for MySQL
"
Class {
	#name : #MySQLStringRowData,
	#superclass : #MySQLBinaryRowData,
	#instVars : [
		'columnStrings'
	],
	#category : #'MySQL-Core-Packet-RowData'
}

{ #category : #accessing }
MySQLStringRowData >> atIndex: indx [
	^ columnStrings at: indx ifAbsent: [MySQLInvalidRowAccess signal: 'No data at this index']
	
]

{ #category : #parsing }
MySQLStringRowData >> parse [
	super parse.
	columnStrings := columnValues collect: [:each | 
		each ifNil: ['NULL'] ifNotNil: [
			(each isKindOf: Date) ifTrue: [each yyyymmdd] ifFalse: [
				(each isKindOf: Time) ifTrue: [each print24] ifFalse: [
					(each isKindOf: DateAndTime) ifTrue: [each asISOString] ifFalse: [
						each asString]]]]]
	
]

{ #category : #writing }
MySQLStringRowData >> write [
	self subclassResponsibility 
]
