Class {
	#name : #MySQLQueryRowData,
	#superclass : #MySQLRowData,
	#instVars : [
		'columns'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLQueryRowData >> at: indx [
	^ self atIndex: indx
]

{ #category : #'as yet unclassified' }
MySQLQueryRowData >> atIndex: indx [
	^ columns at: indx ifAbsent: [MySQLInvalidRowAccess signal: 'No data at this index']
]

{ #category : #'as yet unclassified' }
MySQLQueryRowData >> columnCount: aCount [
	columns := Array new: aCount 
	
]

{ #category : #'as yet unclassified' }
MySQLQueryRowData >> parse [
	|indx value |

	indx := 1.
	[inStream atEnd] whileFalse: [
		value := (self decodeLcsFrom: inStream) asString.
		columns at: indx put: value.
		indx := indx + 1].
	
]
