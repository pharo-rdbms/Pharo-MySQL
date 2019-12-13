"
Common superclass for MySQL row data
"
Class {
	#name : #MySQLRowData,
	#superclass : #MySQLPacket,
	#category : #'MySQL-Core-Packet-RowData'
}

{ #category : #accessing }
MySQLRowData >> at: index [
	
	^ self atIndex: index
]

{ #category : #accessing }
MySQLRowData >> atIndex: indx [
	self subclassResponsibility
	
]

{ #category : #parsing }
MySQLRowData >> parse [
	self subclassResponsibility 
	
]
