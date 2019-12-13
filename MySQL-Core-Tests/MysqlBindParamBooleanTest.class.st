Class {
	#name : #MysqlBindParamBooleanTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #'as yet unclassified' }
MysqlBindParamBooleanTest >> setUp [
	theParam := MysqlBindParam new.
	
]

{ #category : #'as yet unclassified' }
MysqlBindParamBooleanTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
	
]

{ #category : #'as yet unclassified' }
MysqlBindParamBooleanTest >> testParamBoolean [
	theParam bindValue: true.
	self assert: (theParam detectParamType = MysqlTypes typeTINY).
	self assert: theParam isUnsigned.

	theParam bindValue: false.
	self assert: (theParam detectParamType = MysqlTypes typeTINY).
	self assert: theParam isUnsigned.

]

{ #category : #'as yet unclassified' }
MysqlBindParamBooleanTest >> testParamStoreBinaryBoolean [
	theParam bindValue: true.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r01)).

	theParam bindValue: false.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r00)).

]
