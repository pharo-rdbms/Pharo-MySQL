Extension { #name : 'Duration' }

{ #category : '*MySQL-Core' }
Duration >> mySQLParamSign [

	^self positive
]

{ #category : '*MySQL-Core' }
Duration >> mySQLParamTypeFor: aMySQLBindParameter [

	^MySQLTypes typeTIME
]
