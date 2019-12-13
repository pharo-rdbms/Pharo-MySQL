Class {
	#name : #MySQLCommandPing,
	#superclass : #MySQLCommandBase,
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MySQLCommandPing >> commandArg [
	^ nil
]

{ #category : #'as yet unclassified' }
MySQLCommandPing >> commandCode [
	^ ComPing 
]

{ #category : #'as yet unclassified' }
MySQLCommandPing >> readResponse [
	| pkt |

	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [^ pkt] 
		ifFalse: [self error: 'Unrecognized response for command']
		
]
