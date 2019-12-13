Class {
	#name : #MySQLComplexResult,
	#superclass : #MySQLResult,
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLComplexResult class >> buildFrom: aSession [
	^ self subclassResponsibility 
	
]
