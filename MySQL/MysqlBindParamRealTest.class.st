Class {
	#name : #MysqlBindParamRealTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Test-Unit'
}

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> setUp [
	theParam := MysqlBindParam new
	
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testParamDecimal [
	theParam bindValue: 12345.678901s6.
	self assert: theParam paramType = MysqlTypes typeDECIMAL.
	self assert: theParam isUnsigned.
	
	theParam bindValue: -12345.678901s6.
	self assert: theParam paramType = MysqlTypes typeDECIMAL.
	self deny: theParam isUnsigned.

]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testParamDouble [
	theParam bindValue: 123456789123456789.123456789.
	self assert: theParam paramType = MysqlTypes typeDOUBLE.
	self assert: theParam isUnsigned.
	
	theParam bindValue: -123456789123456789.123456789.
	self assert: theParam paramType = MysqlTypes typeDOUBLE.
	self deny: theParam isUnsigned.

]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testParamFloat [
	theParam bindValue: 65.0.
	self assert: theParam paramType = MysqlTypes typeFLOAT.
	self assert: theParam isUnsigned.

	theParam bindValue: -65.0.
	self assert: theParam paramType = MysqlTypes typeFLOAT.
	self deny: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testParamFraction [
	theParam bindValue: 100/3.
	self assert: theParam paramType = MysqlTypes typeDOUBLE.
	self assert: theParam isUnsigned.

	theParam bindValue: -100/3.
	self assert: theParam paramType = MysqlTypes typeDOUBLE.
	self deny: theParam isUnsigned.
	
	theParam bindValue: 17/4.
	self assert: theParam paramType = MysqlTypes typeFLOAT.
	self assert: theParam isUnsigned.
	
	theParam bindValue: -17/4.
	self assert: theParam paramType = MysqlTypes typeFLOAT.
	self deny: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testStoreBinarySignedDecimal [
	theParam bindValue: -12345.678901s6.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents asString = '12345.678901')]	
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testStoreBinarySignedDouble [
	theParam bindValue: -123456789123456789.123456789.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: 
				(MysqlHelper bytesFromHexString: 'B4697BC3F105CDBA'))]
			
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testStoreBinarySignedFraction [
	theParam bindValue: -17/4.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MysqlHelper bytesFromHexString: '000011C0'))]
		
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testStoreBinarySingedFloat [
	theParam bindValue: -65.0.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MysqlHelper bytesFromHexString: '004050C0'))]
		
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testStoreBinaryUnsignedDecimal [
	theParam bindValue: 12345.678901s6.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents asString = '12345.678901')]	
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testStoreBinaryUnsignedDouble [
	theParam bindValue: 123456789123456789.123456789.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MysqlHelper bytesFromHexString: 'B4697B43F105CDBA'))]
		
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testStoreBinaryUnsignedFloat [
	theParam bindValue: 65.0.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MysqlHelper bytesFromHexString: '00405040'))]
		
]

{ #category : #'as yet unclassified' }
MysqlBindParamRealTest >> testStoreBinaryUnsignedFraction [
	theParam bindValue: 17/4.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MysqlHelper bytesFromHexString: '00001140'))]
		
]
