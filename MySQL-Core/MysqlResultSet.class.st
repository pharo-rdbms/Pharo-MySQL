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
		'statement'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLResultSet >> fields [
	^ fields 
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> fields: flds [
	fields := flds
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> fieldsEof [
	^ fieldsEof 
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> fieldsEof: eofPkt [ 
	fieldsEof := eofPkt
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> hasLastRowSent [
	"This is signaled during cursor based fetch for the rows. Therefore we
	check for the singal in the eof field following the rows in the response."
	^ rowsEof ifNil: [false] ifNotNil: [rowsEof hasLastRowSent]
	
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> hasMoreResults [
	"Looks like the flag, when set, will be set by the server in both the
	field eof and rowdata eof packets. We are only using field eof here, since
	rowdata eof may not sometimes sent as part of the result set (e.g., cursor)."
	^ fieldsEof hasMoreResults
	
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> hasOpenCursor [
	^ fieldsEof hasOpenCursor 
	
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> header [
	^ header
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> header: hdr [
	header := hdr
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> isResultSet [
	^ true
]

{ #category : #cursor }
MySQLResultSet >> nextRow [
		
	(self rows isEmptyOrNil and: [self hasOpenCursor and: [self hasLastRowSent not]])
			ifTrue: [ statement fetchRows: statement fetchSize ].
			
	^ rows ifEmpty: [ nil ] ifNotEmpty: [ rows removeFirst ]
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> parse [
	self shouldNotImplement
	
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> rows [
	^ rows
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> rows: allRows [
	rows := allRows
	
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> rowsEof [
	^ rowsEof 
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> rowsEof: eofPkt [
	rowsEof := eofPkt
]

{ #category : #'as yet unclassified' }
MySQLResultSet >> serverStatus [
	^ fieldsEof serverStatus
	
]

{ #category : #accessing }
MySQLResultSet >> statement: aStatement [ 
	
	statement := aStatement
]
