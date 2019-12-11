Class {
	#name : #MysqlComplexResult,
	#superclass : #MysqlResult,
	#category : #'MysqlDriver-Packet'
}

{ #category : #'as yet unclassified' }
MysqlComplexResult class >> buildFrom: aSession [
	^ self subclassResponsibility 
	
]
