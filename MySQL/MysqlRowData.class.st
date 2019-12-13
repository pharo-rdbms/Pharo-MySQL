Class {
	#name : #MysqlRowData,
	#superclass : #MysqlPacket,
	#category : #'MySQL-Packet'
}

{ #category : #'as yet unclassified' }
MysqlRowData >> at: index [
	
	^ self atIndex: index
]

{ #category : #'as yet unclassified' }
MysqlRowData >> atIndex: indx [
	self subclassResponsibility
	
]

{ #category : #'as yet unclassified' }
MysqlRowData >> parse [
	self subclassResponsibility 
	
]
