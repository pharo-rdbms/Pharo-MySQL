Class {
	#name : #MysqlBindParamNullTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Test-Unit'
}

{ #category : #'as yet unclassified' }
MysqlBindParamNullTest >> setUp [
	theParam := MysqlBindParam new.
	
]

{ #category : #'as yet unclassified' }
MysqlBindParamNullTest >> testNullParamBinaryWrite [
	"binding a nil param
		- should produce an empty string in binary protocol"
	ByteArray streamContents: [:strm |
		theParam storeBinaryOn: strm.
		self 
			should: [strm contents isEmpty]
			description: 'binding nil should produce an empty string in binary protocol']
		
]

{ #category : #'as yet unclassified' }
MysqlBindParamNullTest >> testNullParamBind [
	"binding a nil value
		- should set the param type to NULL"
	theParam bindValue: nil.
	self 
		should: [theParam detectParamType = MysqlTypes typeNULL] 
		description: 'binding nil should set param type to NULL'.
		
]

{ #category : #'as yet unclassified' }
MysqlBindParamNullTest >> testNullParamTest [
	"binding a nil value
		- should return true when tested for type NULL
	"
	theParam bindValue: nil.
	self 
		should: [theParam isNull] 
		description: 'binding nil should set type to NULL'
		
]
