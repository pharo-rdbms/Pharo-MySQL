Class {
	#name : #MySQLResultSetHeader,
	#superclass : #MySQLPacket,
	#instVars : [
		'fieldCount',
		'extra'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLResultSetHeader >> fieldCount [
	^ fieldCount 
]

{ #category : #'as yet unclassified' }
MySQLResultSetHeader >> parse [
	fieldCount := self decodeLcbFrom: inStream.
	"exrta field may appear for some results (like show column)"
	inStream atEnd ifFalse: [extra := self decodeLcbFrom: inStream]
	
]
