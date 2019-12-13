Class {
	#name : #MySQLBindParameterIntegerTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests-Utilities'
}

{ #category : #running }
MySQLBindParameterIntegerTest >> setUp [
	super setUp.
	theParam := MySQLBindParameter new.
	
]

{ #category : #accessing }
MySQLBindParameterIntegerTest >> specText [
	"
	Binding an integer in range -128 to 255
		- should set the param type to TINY		
	Binding an integer in range -128 to -1
		- should produce a 2's complement byte array of size 1 in binary protocol'
	Binding an integer in range 0 to 255
		- should produce a byte array of size 1 in binary protocol'
	"

]

{ #category : #accessing }
MySQLBindParameterIntegerTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
	
]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testParamInBigIntRange [
	theParam bindValue: -16r8000000000000000.
	self assert: (theParam paramType = MySQLTypes typeLONGLONG).
	self deny: theParam isUnsigned.
	
	theParam bindValue: -16r80000001.
	self assert: (theParam paramType = MySQLTypes typeLONGLONG).
	self deny: theParam isUnsigned.

	theParam bindValue: 16r100000000.
	self assert: (theParam paramType = MySQLTypes typeLONGLONG).
	self assert: theParam isUnsigned.

	self should: [theParam bindValue: 16rFFFFFFFFFFFFFFFF]  raise: MySQLBindError.
	theParam declaredUnsigned: true.
	theParam bindValue: 16rFFFFFFFFFFFFFFFF.
	self assert: (theParam paramType = MySQLTypes typeLONGLONG).
	self assert: theParam isUnsigned.

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testParamInLongIntRange [
	theParam bindValue: -16r80000000.
	self assert: (theParam paramType = MySQLTypes typeLONG).
	self deny: theParam isUnsigned.
	
	theParam bindValue: -16r8001.
	self assert: (theParam paramType = MySQLTypes typeLONG).
	self deny: theParam isUnsigned.

	theParam bindValue: 16r10000.
	self assert: (theParam paramType = MySQLTypes typeLONG).
	self assert: theParam isUnsigned.

	theParam bindValue: 16rFFFFFFFF.
	self assert: (theParam paramType = MySQLTypes typeLONGLONG).
	self assert: theParam isUnsigned.

	theParam declaredUnsigned: true.
	theParam bindValue: 16rFFFFFFFF.
	self assert: (theParam paramType = MySQLTypes typeLONG).
	self assert: theParam isUnsigned.

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testParamInShortIntRange [
	theParam bindValue: -16r8000.
	self assert: (theParam paramType = MySQLTypes typeSHORT).
	self deny: theParam isUnsigned.
	
	theParam bindValue: -16r81.
	self assert: (theParam paramType = MySQLTypes typeSHORT).
	self deny: theParam isUnsigned.

	theParam bindValue: 16r100.
	self assert: (theParam paramType = MySQLTypes typeSHORT).
	self assert: theParam isUnsigned.

	theParam bindValue: 16rFFFF.
	self assert: (theParam paramType = MySQLTypes typeLONG).
	self assert: theParam isUnsigned.

	theParam declaredUnsigned: true.
	theParam bindValue: 16rFFFF.
	self assert: (theParam paramType = MySQLTypes typeSHORT).
	self assert: theParam isUnsigned.

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testParamInTinyIntRange [
	theParam bindValue: -128.
	self assert: (theParam paramType = MySQLTypes typeTINY).
	theParam bindValue: 0.
	self assert: (theParam paramType = MySQLTypes typeTINY).
	theParam bindValue: 255.
	self assert: (theParam paramType = MySQLTypes typeSHORT).

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testParamOutOfBigIntRange [
	self should: [theParam bindValue: -16r8000000000000001] raise: MySQLBindError.
	theParam bindValue: -16r80000000.
	self deny: (theParam paramType = MySQLTypes typeLONGLONG).
	theParam declaredUnsigned: true.
	theParam bindValue: 16rFFFFFFFF.
	self deny: (theParam paramType = MySQLTypes typeLONGLONG).
	self should: [theParam bindValue: 16r10000000000000000] raise: MySQLBindError.

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testParamOutOfLongIntRange [
	theParam bindValue: -16r80000001.
	self deny: (theParam paramType = MySQLTypes typeLONG).
	theParam bindValue: -16r8000.
	self deny: (theParam paramType = MySQLTypes typeLONG).
	theParam declaredUnsigned: true.
	theParam bindValue: 16rFFFF.
	self deny: (theParam paramType = MySQLTypes typeLONG).
	theParam bindValue: 16r100000000.
	self deny: (theParam paramType = MySQLTypes typeLONG).

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testParamOutOfShortIntRange [
	theParam bindValue: -16r8001.
	self deny: (theParam paramType = MySQLTypes typeSHORT).
	theParam bindValue: -16r80.
	self deny: (theParam paramType = MySQLTypes typeSHORT).
	theParam declaredUnsigned: true.
	theParam bindValue: 16rFF.
	self deny: (theParam paramType = MySQLTypes typeSHORT).
	theParam bindValue: 16r10000.
	self deny: (theParam paramType = MySQLTypes typeSHORT).

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testParamOutOfTinyIntRange [
	theParam bindValue: -129.
	self deny: (theParam paramType = MySQLTypes typeTINY).
	theParam bindValue: 256.
	self deny: (theParam paramType = MySQLTypes typeTINY).

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testStoreBinaryBigInt [
	theParam bindValue: -16r8000000000000000.
	self assert: (self storeBinary hasEqualElements: 
		(MySQLHelper bytesFromHexString: '0000000000000080')).

	theParam bindValue: -16r80000001.
	self assert: (self storeBinary hasEqualElements: 
		(MySQLHelper bytesFromHexString: 'FFFFFF7FFFFFFFFF')).

	theParam bindValue: 16r100000000.
	self assert: (self storeBinary hasEqualElements: 
		(MySQLHelper bytesFromHexString: '0000000001000000')).

	self should: [theParam bindValue: 16rFFFFFFFFFFFFFFFF] raise: MySQLBindError.
	theParam declaredUnsigned: true.	
	theParam bindValue: 16rFFFFFFFFFFFFFFFF.
	self assert: (self storeBinary hasEqualElements: 
		(MySQLHelper bytesFromHexString: 'FFFFFFFFFFFFFFFF')).

]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testStoreBinaryLongInt [
	theParam bindValue: -16r80000000.
	self assert: (self storeBinary hasEqualElements: 
		(MySQLHelper bytesFromHexString: '00000080')).

	theParam bindValue: -16r8001.
	self assert: (self storeBinary hasEqualElements: 
		(MySQLHelper bytesFromHexString: 'FF7FFFFF')).

	theParam bindValue: 16r10000.
	self assert: (self storeBinary hasEqualElements: 
		(MySQLHelper bytesFromHexString: '00000100')).

	theParam declaredUnsigned: true.
	theParam bindValue: 16rFFFFFFFF.
	self assert: (self storeBinary hasEqualElements: 
		(MySQLHelper bytesFromHexString: 'FFFFFFFF')).
	
]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testStoreBinaryShortInt [
	theParam bindValue: -16r8000.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r00 with: 16r80)).
	theParam bindValue: -16r81.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r7F with: 16rFF)).

	theParam bindValue: 16r100.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r00 with: 16r01)).
	theParam declaredUnsigned: true.
	theParam bindValue: 16rFFFF.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16rFF with: 16rFF)).
	
]

{ #category : #tests }
MySQLBindParameterIntegerTest >> testStoreBinaryTinyInt [
	theParam bindValue: -128.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r80)).
	theParam bindValue: -1.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16rFF)).

	theParam bindValue: 0.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16r00)).
	theParam declaredUnsigned: true.
	theParam bindValue: 255.
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 16rFF)).
	
]
