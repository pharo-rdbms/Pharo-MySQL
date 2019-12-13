Class {
	#name : #MySQLBindParameterStringBlobTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #running }
MySQLBindParameterStringBlobTest >> setUp [
	theParam := MySQLBindParameter new.
	
]

{ #category : #accessing }
MySQLBindParameterStringBlobTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
	
]

{ #category : #tests }
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

{ #category : #tests }
MySQLBindParameterStringBlobTest >> testParamCharacter [
	theParam bindValue: $A.
	self assert: (theParam detectParamType = MySQLTypes typeSTRING).
	self assert: theParam isUnsigned.

]

{ #category : #tests }
MySQLBindParameterStringBlobTest >> testParamStoreBinaryCharacter [
	theParam bindValue: $A.
	"lengthcoded + charcter as string"
	self assert: (self storeBinary hasEqualElements: (ByteArray with: 1 with: 16r41)).

]

{ #category : #tests }
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

{ #category : #tests }
MySQLBindParameterStringBlobTest >> testParamStoreBinarySymbol [
	theParam bindValue: #hello.
	"lengthcoded + string bytes"
	self assert: (self storeBinary hasEqualElements: 
		(ByteArray with: 5), 'hello' asByteArray).

]

{ #category : #tests }
MySQLBindParameterStringBlobTest >> testParamStoreBinaryText [
	theParam bindValue: (Text fromString: 'This is a text').
	"lengthcoded + string bytes"
	self assert: (self storeBinary hasEqualElements: 
		(ByteArray with: 14), 'This is a text' asByteArray).

]

{ #category : #tests }
MySQLBindParameterStringBlobTest >> testParamString [
	theParam bindValue: 'Smalltalk is awesome'.
	self assert: (theParam detectParamType = MySQLTypes typeVARSTRING).
	self assert: theParam isUnsigned.
	
]

{ #category : #tests }
MySQLBindParameterStringBlobTest >> testParamSymbol [
	theParam bindValue: #'Symbols are special'.
	self assert: (theParam detectParamType = MySQLTypes typeVARSTRING).
	self assert: theParam isUnsigned.
	
]

{ #category : #tests }
MySQLBindParameterStringBlobTest >> testParamText [
	theParam bindValue: (Text fromString: 'Smalltalk is awesome').
	self assert: (theParam detectParamType = MySQLTypes typeVARSTRING).
	self assert: theParam isUnsigned.
	
]
