"
MySQL quit command
"
Class {
	#name : #MySQLCommandQuit,
	#superclass : #MySQLCommandBase,
	#category : #'MySQL-Core-Command'
}

{ #category : #defaults }
MySQLCommandQuit >> commandArg [
	^ nil
]

{ #category : #defaults }
MySQLCommandQuit >> commandCode [
	^ ComQuit 
]

{ #category : #reading }
MySQLCommandQuit >> readResponse [
	^ nil
		
]
