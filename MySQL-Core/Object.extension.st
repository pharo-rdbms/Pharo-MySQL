Extension { #name : 'Object' }

{ #category : '*MySQL-Core' }
Object >> mySQLParamSign [

	^true
]

{ #category : '*MySQL-Core' }
Object >> mySQLParamTypeFor: aMySQLBindParameter [

	^MySQLTypes typeTINY
]
