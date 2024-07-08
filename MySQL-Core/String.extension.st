Extension { #name : 'String' }

{ #category : '*MySQL-Core' }
String >> mySQLParamTypeFor: aMySQLBindParameter [

	^MySQLTypes typeVARSTRING
]
