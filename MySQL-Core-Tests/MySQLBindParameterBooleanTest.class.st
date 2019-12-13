Class {
	#name : #MySQLBindParameterBooleanTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #'as yet unclassified' }
MySQLBindParameterBooleanTest >> setUp [
	theParam := MySQLBindParameter new.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterBooleanTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterBooleanTest >> testParamBoolean [
	theParam bindValue: true.
	self assert: (theParam detectParamType = MySQLTypes typeTINY).
	self assert: theParam isUnsigned.

	theParam bindValue: false.
	self assert: (theParam detectParamType = MySQLTypes typeTINY).
	self assert: theParam isUnsigned.

]

{ #category : #'as yet unclassified' }
MySQLBindParameterBooleanTest >> testParamStoreBinaryBoolean [
	theParam bindValue: true.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r01)).

	theParam bindValue: false.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r00)).

]
