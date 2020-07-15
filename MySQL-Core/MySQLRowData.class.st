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

{ #category : #accessing }
MySQLRowData >> eighth [  
	^self atIndex: 8
]

{ #category : #accessing }
MySQLRowData >> fifth [ 
	^self atIndex: 5
]

{ #category : #accessing }
MySQLRowData >> first [ 
	^self atIndex: 1
]

{ #category : #accessing }
MySQLRowData >> fourth [ 
	^self atIndex: 4
]

{ #category : #accessing }
MySQLRowData >> last [  
	self subclassResponsibility 
]

{ #category : #accessing }
MySQLRowData >> ninth [  
	^self atIndex: 9
]

{ #category : #parsing }
MySQLRowData >> parse [
	self subclassResponsibility 
	
]

{ #category : #accessing }
MySQLRowData >> second [ 
	^self atIndex: 2
]

{ #category : #accessing }
MySQLRowData >> seventh [ 
	^self atIndex: 7
]

{ #category : #accessing }
MySQLRowData >> sixth [ 
	^self atIndex: 6
]

{ #category : #accessing }
MySQLRowData >> tenth [  
	^self atIndex: 10
]

{ #category : #accessing }
MySQLRowData >> third [ 
	^self atIndex: 3
]
