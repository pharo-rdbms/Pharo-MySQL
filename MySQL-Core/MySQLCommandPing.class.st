"
MySQL ping command
"
Class {
	#name : #MySQLCommandPing,
	#superclass : #MySQLCommandBase,
	#category : #'MySQL-Core-Command'
}

{ #category : #defaults }
MySQLCommandPing >> commandArg [
	^ nil
]

{ #category : #defaults }
MySQLCommandPing >> commandCode [
	^ ComPing 
]

{ #category : #reading }
MySQLCommandPing >> readResponse [
	| pkt |

	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [^ pkt] 
		ifFalse: [self error: 'Unrecognized response for command']
		
]
