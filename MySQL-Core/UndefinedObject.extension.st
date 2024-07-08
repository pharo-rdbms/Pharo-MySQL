Extension { #name : 'UndefinedObject' }

{ #category : '*MySQL-Core' }
UndefinedObject >> mySQLParamTypeFor: aMySQLBindParameter [

	^MySQLTypes typeNULL
]
