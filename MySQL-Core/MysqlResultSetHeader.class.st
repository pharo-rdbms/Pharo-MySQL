Class {
	#name : #MysqlResultSetHeader,
	#superclass : #MysqlPacket,
	#instVars : [
		'fieldCount',
		'extra'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MysqlResultSetHeader >> fieldCount [
	^ fieldCount 
]

{ #category : #'as yet unclassified' }
MysqlResultSetHeader >> parse [
	fieldCount := self decodeLcbFrom: inStream.
	"exrta field may appear for some results (like show column)"
	inStream atEnd ifFalse: [extra := self decodeLcbFrom: inStream]
	
]
