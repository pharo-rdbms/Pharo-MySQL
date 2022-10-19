Class {
	#name : #MySQLBindParameterDecimalTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests-Utilities'
}

{ #category : #running }
MySQLBindParameterDecimalTest >> setUp [
	super setUp.
	theParam := MySQLBindParameter new.
	
]

{ #category : #accessing }
MySQLBindParameterDecimalTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
	
]

{ #category : #tests }
MySQLBindParameterDecimalTest >> testParamDecimal [
	theParam bindValue: 12.00s2.
	self assert: theParam detectParamType equals: MySQLTypes typeDECIMAL
]

{ #category : #tests }
MySQLBindParameterDecimalTest >> testStoreBinaryLargeScale [
	theParam bindValue: 1.0s10.
	self
		assert: self storeBinary
		equals: #[12] , '1.0000000000' asByteArray.
	theParam bindValue: 1.23456789012s.
	self
		assert: self storeBinary
		equals: #[13] , '1.23456789012' asByteArray
]

{ #category : #tests }
MySQLBindParameterDecimalTest >> testStoreBinarySmallScale [
	theParam bindValue: 12.345s.
	self assert: self storeBinary equals: #[6] , '12.345' asByteArray.
	theParam bindValue: 1.23s.
	self assert: self storeBinary equals: #[4] , '1.23' asByteArray
]
