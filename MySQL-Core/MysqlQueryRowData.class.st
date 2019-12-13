"
Query row data packet for MySQL
"
Class {
	#name : #MySQLQueryRowData,
	#superclass : #MySQLRowData,
	#instVars : [
		'columns'
	],
	#category : #'MySQL-Core-Packet-RowData'
}

{ #category : #accessing }
MySQLQueryRowData >> at: indx [
	^ self atIndex: indx
]

{ #category : #accessing }
MySQLQueryRowData >> atIndex: indx [
	^ columns at: indx ifAbsent: [MySQLInvalidRowAccess signal: 'No data at this index']
]

{ #category : #accessing }
MySQLQueryRowData >> columnCount: aCount [
	columns := Array new: aCount 
	
]

{ #category : #parsing }
MySQLQueryRowData >> parse [
	|indx value |

	indx := 1.
	[inStream atEnd] whileFalse: [
		value := (self decodeLcsFrom: inStream) asString.
		columns at: indx put: value.
		indx := indx + 1].
	
]
