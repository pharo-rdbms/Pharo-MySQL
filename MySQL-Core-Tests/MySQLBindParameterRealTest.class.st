Class {
	#name : #MySQLBindParameterRealTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #running }
MySQLBindParameterRealTest >> setUp [
	theParam := MySQLBindParameter new
	
]

{ #category : #accessing }
MySQLBindParameterRealTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
]

{ #category : #tests }
MySQLBindParameterRealTest >> testParamDecimal [
	theParam bindValue: 12345.678901s6.
	self assert: theParam paramType = MySQLTypes typeDECIMAL.
	self assert: theParam isUnsigned.
	
	theParam bindValue: -12345.678901s6.
	self assert: theParam paramType = MySQLTypes typeDECIMAL.
	self deny: theParam isUnsigned.

]

{ #category : #tests }
MySQLBindParameterRealTest >> testParamDouble [
	theParam bindValue: 123456789123456789.123456789.
	self assert: theParam paramType = MySQLTypes typeDOUBLE.
	self assert: theParam isUnsigned.
	
	theParam bindValue: -123456789123456789.123456789.
	self assert: theParam paramType = MySQLTypes typeDOUBLE.
	self deny: theParam isUnsigned.

]

{ #category : #tests }
MySQLBindParameterRealTest >> testParamFloat [
	theParam bindValue: 65.0.
	self assert: theParam paramType = MySQLTypes typeFLOAT.
	self assert: theParam isUnsigned.

	theParam bindValue: -65.0.
	self assert: theParam paramType = MySQLTypes typeFLOAT.
	self deny: theParam isUnsigned.
	
]

{ #category : #tests }
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

{ #category : #tests }
MySQLBindParameterRealTest >> testStoreBinarySignedDecimal [
	theParam bindValue: -12345.678901s6.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents asString = '12345.678901')]	
]

{ #category : #tests }
MySQLBindParameterRealTest >> testStoreBinarySignedDouble [
	theParam bindValue: -123456789123456789.123456789.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: 
				(MySQLHelper bytesFromHexString: 'B4697BC3F105CDBA'))]
			
]

{ #category : #tests }
MySQLBindParameterRealTest >> testStoreBinarySignedFraction [
	theParam bindValue: -17/4.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: '000011C0'))]
		
]

{ #category : #tests }
MySQLBindParameterRealTest >> testStoreBinarySingedFloat [
	theParam bindValue: -65.0.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: '004050C0'))]
		
]

{ #category : #tests }
MySQLBindParameterRealTest >> testStoreBinaryUnsignedDecimal [
	theParam bindValue: 12345.678901s6.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents asString = '12345.678901')]	
]

{ #category : #tests }
MySQLBindParameterRealTest >> testStoreBinaryUnsignedDouble [
	theParam bindValue: 123456789123456789.123456789.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: 'B4697B43F105CDBA'))]
		
]

{ #category : #tests }
MySQLBindParameterRealTest >> testStoreBinaryUnsignedFloat [
	theParam bindValue: 65.0.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: '00405040'))]
		
]

{ #category : #tests }
MySQLBindParameterRealTest >> testStoreBinaryUnsignedFraction [
	theParam bindValue: 17/4.
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		self assert: (strm contents 
			hasEqualElements: (MySQLHelper bytesFromHexString: '00001140'))]
		
]
