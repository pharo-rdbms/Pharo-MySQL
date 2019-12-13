Class {
	#name : #MysqlComPing,
	#superclass : #MysqlComBase,
	#category : #'MySQL-Command'
}

{ #category : #'as yet unclassified' }
MysqlComPing >> commandArg [
	^ nil
]

{ #category : #'as yet unclassified' }
MysqlComPing >> commandCode [
	^ ComPing 
]

{ #category : #'as yet unclassified' }
MysqlComPing >> readResponse [
	| pkt |

	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [^ pkt] 
		ifFalse: [self error: 'Unrecognized response for command']
		
]
