"
I am a simple facade on result set packets, although I behave as a MysqlPacketData. I don't perform a read or write; my clients compose me from specific rasult set packets. I am designed this way to facilitate use of similar metaphors at the connector protocol level. I also behave a multi-result type of packet.
"
Class {
	#name : #MySQLResultSet,
	#superclass : #MySQLComplexResult,
	#instVars : [
		'header',
		'fields',
		'fieldsEof',
		'rows',
		'rowsEof',
		'rowsStream',
		'statement'
	],
	#category : #'MySQL-Core-Packet-Results'
}

{ #category : #accessing }
MySQLResultSet >> fields [
	^ fields 
]

{ #category : #accessing }
MySQLResultSet >> fields: flds [
	fields := flds
]

{ #category : #accessing }
MySQLResultSet >> fieldsEof [
	^ fieldsEof 
]

{ #category : #accessing }
MySQLResultSet >> fieldsEof: eofPkt [ 
	fieldsEof := eofPkt
]

{ #category : #testing }
MySQLResultSet >> hasLastRowSent [
	"This is signaled during cursor based fetch for the rows. Therefore we
	check for the singal in the eof field following the rows in the response."
	^ rowsEof ifNil: [false] ifNotNil: [rowsEof hasLastRowSent]
	
]

{ #category : #testing }
MySQLResultSet >> hasMoreResults [
	"Looks like the flag, when set, will be set by the server in both the
	field eof and rowdata eof packets. We are only using field eof here, since
	rowdata eof may not sometimes sent as part of the result set (e.g., cursor)."
	^ fieldsEof hasMoreResults
	
]

{ #category : #testing }
MySQLResultSet >> hasOpenCursor [
	^ fieldsEof hasOpenCursor 
	
]

{ #category : #accessing }
MySQLResultSet >> header [
	^ header
]

{ #category : #accessing }
MySQLResultSet >> header: hdr [
	header := hdr
]

{ #category : #testing }
MySQLResultSet >> isResultSet [
	^ true
]

{ #category : #cursor }
MySQLResultSet >> nextRow [
		
	((self rows isNil or: [ self rowsStream atEnd]) and: [self hasOpenCursor and: [self hasLastRowSent not]])
			ifTrue: [ statement fetchRows: statement fetchSize ].
			
	^ self rowsStream next
]

{ #category : #parsing }
MySQLResultSet >> parse [
	self shouldNotImplement
	
]

{ #category : #accessing }
MySQLResultSet >> rows [
	^ rows
]

{ #category : #accessing }
MySQLResultSet >> rows: allRows [
	rows := allRows.
	rowsStream := nil
]

{ #category : #accessing }
MySQLResultSet >> rowsEof [
	^ rowsEof 
]

{ #category : #accessing }
MySQLResultSet >> rowsEof: eofPkt [
	rowsEof := eofPkt
]

{ #category : #accessing }
MySQLResultSet >> rowsStream [

	^rowsStream ifNil: [ rowsStream := ReadStream on: self rows ]
]

{ #category : #accessing }
MySQLResultSet >> serverStatus [
	^ fieldsEof serverStatus
	
]

{ #category : #accessing }
MySQLResultSet >> statement: aStatement [ 
	
	statement := aStatement
]
