Extension { #name : 'Number' }

{ #category : '*MySQL-Core' }
Number >> mySQLParamSign [

	^self positive
]

{ #category : '*MySQL-Core' }
Number >> mySQLParamTypeFor: aMySQLBindParameter [

	^MySQLTypes typeDOUBLE
]
