Extension { #name : 'Integer' }

{ #category : '*MySQL-Core' }
Integer >> digitAt: index [

	^self at: index
]

{ #category : '*MySQL-Core' }
Integer >> mySQLParamTypeFor: aMySQLBindParameter [

	(aMySQLBindParameter isInTinyIntRange: self) ifTrue: [^ MySQLTypes typeTINY].
	(aMySQLBindParameter isInSmallIntRange: self) ifTrue: [^ MySQLTypes typeSHORT].
	(aMySQLBindParameter isInLongIntRange: self) ifTrue: [^ MySQLTypes typeLONG].
	(aMySQLBindParameter isInBigIntRange: self) ifTrue: [^ MySQLTypes typeLONGLONG].

	MySQLBindError signal: 'Supplied integer does not have a matching database type'
]
