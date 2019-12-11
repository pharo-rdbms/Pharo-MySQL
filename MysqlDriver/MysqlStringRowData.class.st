Class {
	#name : #MysqlStringRowData,
	#superclass : #MysqlBinRowData,
	#instVars : [
		'columnStrings'
	],
	#category : #'MysqlDriver-Packet'
}

{ #category : #'as yet unclassified' }
MysqlStringRowData >> atIndex: indx [
	^ columnStrings at: indx ifAbsent: [MysqlInvalidRowAccess signal: 'No data at this index']
	
]

{ #category : #'as yet unclassified' }
MysqlStringRowData >> parse [
	super parse.
	columnStrings := columnValues collect: [:each | 
		each ifNil: ['NULL'] ifNotNil: [
			(each isKindOf: Date) ifTrue: [each yyyymmdd] ifFalse: [
				(each isKindOf: Time) ifTrue: [each print24] ifFalse: [
					(each isKindOf: DateAndTime) ifTrue: [each asISOString] ifFalse: [
						each asString]]]]]
	
]
