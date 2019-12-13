Class {
	#name : #MysqlQueryRowData,
	#superclass : #MysqlRowData,
	#instVars : [
		'columns'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MysqlQueryRowData >> at: indx [
	^ self atIndex: indx
]

{ #category : #'as yet unclassified' }
MysqlQueryRowData >> atIndex: indx [
	^ columns at: indx ifAbsent: [MysqlInvalidRowAccess signal: 'No data at this index']
]

{ #category : #'as yet unclassified' }
MysqlQueryRowData >> columnCount: aCount [
	columns := Array new: aCount 
	
]

{ #category : #'as yet unclassified' }
MysqlQueryRowData >> parse [
	|indx value |

	indx := 1.
	[inStream atEnd] whileFalse: [
		value := (self decodeLcsFrom: inStream) asString.
		columns at: indx put: value.
		indx := indx + 1].
	
]
