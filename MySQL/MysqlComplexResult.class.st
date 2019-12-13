Class {
	#name : #MysqlComplexResult,
	#superclass : #MysqlResult,
	#category : #'MySQL-Packet'
}

{ #category : #'as yet unclassified' }
MysqlComplexResult class >> buildFrom: aSession [
	^ self subclassResponsibility 
	
]
