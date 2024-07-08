Extension { #name : 'ScaledDecimal' }

{ #category : '*MySQL-Core' }
ScaledDecimal >> mySQLParamTypeFor: aMySQLBindParameter [

	^MySQLTypes typeDECIMAL
]
