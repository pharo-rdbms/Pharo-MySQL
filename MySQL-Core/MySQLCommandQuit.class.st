Class {
	#name : #MySQLCommandQuit,
	#superclass : #MySQLCommandBase,
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MySQLCommandQuit >> commandArg [
	^ nil
]

{ #category : #'as yet unclassified' }
MySQLCommandQuit >> commandCode [
	^ ComQuit 
]

{ #category : #'as yet unclassified' }
MySQLCommandQuit >> readResponse [
	^ nil
		
]
