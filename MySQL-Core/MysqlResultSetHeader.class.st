"
MySQL Header for a result set 
"
Class {
	#name : #MySQLResultSetHeader,
	#superclass : #MySQLPacket,
	#instVars : [
		'fieldCount',
		'extra'
	],
	#category : #'MySQL-Core-Packet-Results'
}

{ #category : #accessing }
MySQLResultSetHeader >> fieldCount [
	^ fieldCount 
]

{ #category : #parsing }
MySQLResultSetHeader >> parse [
	fieldCount := self decodeLcbFrom: inStream.
	"exrta field may appear for some results (like show column)"
	inStream atEnd ifFalse: [extra := self decodeLcbFrom: inStream]
	
]
