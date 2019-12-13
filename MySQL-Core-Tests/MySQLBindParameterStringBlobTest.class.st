Class {
	#name : #MySQLBindParameterStringBlobTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> setUp [
	theParam := MySQLBindParameter new.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamBlob [
	theParam bindValue: (ByteArray new: 16rFF withAll: 16rAA).
	self assert: (theParam detectParamType = MySQLTypes typeTINYBLOB).
	self assert: theParam isUnsigned.

	theParam bindValue: (ByteArray new: 16rFFFF withAll: 16r55).
	self assert: (theParam detectParamType = MySQLTypes typeBLOB).
	self assert: theParam isUnsigned.

	theParam bindValue: (ByteArray new: 16r20000 withAll: 16rAA).
	self assert: (theParam detectParamType = MySQLTypes typeMEDIUMBLOB).
	self assert: theParam isUnsigned.

	theParam bindValue: (ByteArray new: 16r1000000 withAll: 16r55).
	self assert: (theParam detectParamType = MySQLTypes typeLONGBLOB).
	self assert: theParam isUnsigned.
		

]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamCharacter [
	theParam bindValue: $A.
	self assert: (theParam detectParamType = MySQLTypes typeSTRING).
	self assert: theParam isUnsigned.

]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamStoreBinaryCharacter [
	theParam bindValue: $A.
	"lengthcoded + charcter as string"
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 1 with: 16r41)).

]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamStoreBinaryString [
	| value binStrm |
	theParam bindValue: 'hello'.
	"lengthcoded + string bytes"
	self assert: (self storeBinary hasEqualElements: 
		(ByteArray with: 5), 'hello' asByteArray).

	value := ''.
	10 timesRepeat: [value := value, 'abcdefghijklmnopqrstuvwxyz'].
	theParam bindValue: value.
	binStrm := ReadStream on: self storeBinary.
	self assert: (MySQLHelper decodeLcbFrom: binStrm) = 260.
	self assert: (binStrm upToEnd asString hasEqualElements: value)	
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamStoreBinarySymbol [
	theParam bindValue: #hello.
	"lengthcoded + string bytes"
	self assert: (self storeBinary hasEqualElements: 
		(ByteArray with: 5), 'hello' asByteArray).

]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamStoreBinaryText [
	theParam bindValue: (Text fromString: 'This is a text').
	"lengthcoded + string bytes"
	self assert: (self storeBinary hasEqualElements: 
		(ByteArray with: 14), 'This is a text' asByteArray).

]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamString [
	theParam bindValue: 'Smalltalk is awesome'.
	self assert: (theParam detectParamType = MySQLTypes typeVARSTRING).
	self assert: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamSymbol [
	theParam bindValue: #'Symbols are special'.
	self assert: (theParam detectParamType = MySQLTypes typeVARSTRING).
	self assert: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterStringBlobTest >> testParamText [
	theParam bindValue: (Text fromString: 'Smalltalk is awesome').
	self assert: (theParam detectParamType = MySQLTypes typeVARSTRING).
	self assert: theParam isUnsigned.
	
]
