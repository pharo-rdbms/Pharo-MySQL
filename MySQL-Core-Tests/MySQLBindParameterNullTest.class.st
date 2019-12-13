Class {
	#name : #MySQLBindParameterNullTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #running }
MySQLBindParameterNullTest >> setUp [
	theParam := MySQLBindParameter new.
	
]

{ #category : #tests }
MySQLBindParameterNullTest >> testNullParamBinaryWrite [
	"binding a nil param
		- should produce an empty string in binary protocol"
	ByteArray streamContents: [:strm |
		theParam storeBinaryOn: strm.
		self 
			should: [strm contents isEmpty]
			description: 'binding nil should produce an empty string in binary protocol']
		
]

{ #category : #tests }
MySQLBindParameterNullTest >> testNullParamBind [
	"binding a nil value
		- should set the param type to NULL"
	theParam bindValue: nil.
	self 
		should: [theParam detectParamType = MySQLTypes typeNULL] 
		description: 'binding nil should set param type to NULL'.
		
]

{ #category : #tests }
MySQLBindParameterNullTest >> testNullParamTest [
	"binding a nil value
		- should return true when tested for type NULL
	"
	theParam bindValue: nil.
	self 
		should: [theParam isNull] 
		description: 'binding nil should set type to NULL'
		
]
