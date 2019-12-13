"
I am a simple facade on result set packets, although I behave as a MysqlPacketData. I don't perform a read or write; my clients compose me from specific rasult set packets. I am designed this way to facilitate use of similar metaphors at the connector protocol level. I also behave a multi-result type of packet.
"
Class {
	#name : #MysqlResultSet,
	#superclass : #MysqlComplexResult,
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
MysqlResultSet >> fields [
	^ fields 
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> fields: flds [
	fields := flds
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> fieldsEof [
	^ fieldsEof 
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> fieldsEof: eofPkt [ 
	fieldsEof := eofPkt
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> hasLastRowSent [
	"This is signaled during cursor based fetch for the rows. Therefore we
	check for the singal in the eof field following the rows in the response."
	^ rowsEof ifNil: [false] ifNotNil: [rowsEof hasLastRowSent]
	
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> hasMoreResults [
	"Looks like the flag, when set, will be set by the server in both the
	field eof and rowdata eof packets. We are only using field eof here, since
	rowdata eof may not sometimes sent as part of the result set (e.g., cursor)."
	^ fieldsEof hasMoreResults
	
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> hasOpenCursor [
	^ fieldsEof hasOpenCursor 
	
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> header [
	^ header
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> header: hdr [
	header := hdr
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> isResultSet [
	^ true
]

{ #category : #cursor }
MysqlResultSet >> nextRow [
		
	(self rows isEmptyOrNil and: [self hasOpenCursor and: [self hasLastRowSent not]])
			ifTrue: [ statement fetchRows: statement fetchSize ].
			
	^ rows ifEmpty: [ nil ] ifNotEmpty: [ rows removeFirst ]
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> parse [
	self shouldNotImplement
	
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> rows [
	^ rows
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> rows: allRows [
	rows := allRows
	
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> rowsEof [
	^ rowsEof 
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> rowsEof: eofPkt [
	rowsEof := eofPkt
]

{ #category : #'as yet unclassified' }
MysqlResultSet >> serverStatus [
	^ fieldsEof serverStatus
	
]

{ #category : #accessing }
MysqlResultSet >> statement: aStatement [ 
	
	statement := aStatement
]
