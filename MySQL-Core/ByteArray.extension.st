Extension { #name : 'ByteArray' }

{ #category : '*MySQL-Core' }
ByteArray >> mySQLParamTypeFor: aMySQLBindParameter [

	self size < 16r100 ifTrue: [^MySQLTypes typeTINYBLOB].
	self size < 16r10000 ifTrue: [^MySQLTypes typeBLOB].
	self size < 16r1000000 ifTrue: [^MySQLTypes typeMEDIUMBLOB].

	^MySQLTypes typeLONGBLOB
]
