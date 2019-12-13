Class {
	#name : #MySQLBindParameterBooleanTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #running }
MySQLBindParameterBooleanTest >> setUp [
	theParam := MySQLBindParameter new.
	
]

{ #category : #accessing }
MySQLBindParameterBooleanTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
	
]

{ #category : #tests }
MySQLBindParameterBooleanTest >> testParamBoolean [
	theParam bindValue: true.
	self assert: (theParam detectParamType = MySQLTypes typeTINY).
	self assert: theParam isUnsigned.

	theParam bindValue: false.
	self assert: (theParam detectParamType = MySQLTypes typeTINY).
	self assert: theParam isUnsigned.

]

{ #category : #tests }
MySQLBindParameterBooleanTest >> testParamStoreBinaryBoolean [
	theParam bindValue: true.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r01)).

	theParam bindValue: false.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r00)).

]
