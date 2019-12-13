Class {
	#name : #MySQLBindParameterRealTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> setUp [
	theParam := MySQLBindParameter new
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testParamDecimal [
	theParam bindValue: 12345.678901s6.
	self assert: theParam paramType = MySQLTypes typeDECIMAL.
	self assert: theParam isUnsigned.
	
	theParam bindValue: -12345.678901s6.
	self assert: theParam paramType = MySQLTypes typeDECIMAL.
	self deny: theParam isUnsigned.

]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testParamDouble [
	theParam bindValue: 123456789123456789.123456789.
	self assert: theParam paramType = MySQLTypes typeDOUBLE.
	self assert: theParam isUnsigned.
	
	theParam bindValue: -123456789123456789.123456789.
	self assert: theParam paramType = MySQLTypes typeDOUBLE.
	self deny: theParam isUnsigned.

]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testParamFloat [
	theParam bindValue: 65.0.
	self assert: theParam paramType = MySQLTypes typeFLOAT.
	self assert: theParam isUnsigned.

	theParam bindValue: -65.0.
	self assert: theParam paramType = MySQLTypes typeFLOAT.
	self deny: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testParamFraction [
	theParam bindValue: 100/3.
	self assert: theParam paramType = MySQLTypes typeDOUBLE.
	self assert: theParam isUnsigned.

	theParam bindValue: -100/3.
	self assert: theParam paramType = MySQLTypes typeDOUBLE.
	self deny: theParam isUnsigned.
	
	theParam bindValue: 17/4.
	self assert: theParam paramType = MySQLTypes typeFLOAT.
	self assert: theParam isUnsigned.
	
	theParam bindValue: -17/4.
	self assert: theParam paramType = MySQLTypes typeFLOAT.
	self deny: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testStoreBinarySignedDecimal [
	theParam bindValue: -12345.678901s6.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents asString = '12345.678901')]	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testStoreBinarySignedDouble [
	theParam bindValue: -123456789123456789.123456789.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: 
				(MySQLHelper bytesFromHexString: 'B4697BC3F105CDBA'))]
			
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testStoreBinarySignedFraction [
	theParam bindValue: -17/4.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: '000011C0'))]
		
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testStoreBinarySingedFloat [
	theParam bindValue: -65.0.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: '004050C0'))]
		
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testStoreBinaryUnsignedDecimal [
	theParam bindValue: 12345.678901s6.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents asString = '12345.678901')]	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testStoreBinaryUnsignedDouble [
	theParam bindValue: 123456789123456789.123456789.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: 'B4697B43F105CDBA'))]
		
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testStoreBinaryUnsignedFloat [
	theParam bindValue: 65.0.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: '00405040'))]
		
]

{ #category : #'as yet unclassified' }
MySQLBindParameterRealTest >> testStoreBinaryUnsignedFraction [
	theParam bindValue: 17/4.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: '00001140'))]
		
]
