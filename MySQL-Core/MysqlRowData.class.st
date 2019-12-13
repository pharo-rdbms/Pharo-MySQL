Class {
	#name : #MySQLRowData,
	#superclass : #MySQLPacket,
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLRowData >> at: index [
	
	^ self atIndex: index
]

{ #category : #'as yet unclassified' }
MySQLRowData >> atIndex: indx [
	self subclassResponsibility
	
]

{ #category : #'as yet unclassified' }
MySQLRowData >> parse [
	self subclassResponsibility 
	
]
