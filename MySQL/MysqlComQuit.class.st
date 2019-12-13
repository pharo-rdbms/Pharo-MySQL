Class {
	#name : #MysqlComQuit,
	#superclass : #MysqlComBase,
	#category : #'MySQL-Command'
}

{ #category : #'as yet unclassified' }
MysqlComQuit >> commandArg [
	^ nil
]

{ #category : #'as yet unclassified' }
MysqlComQuit >> commandCode [
	^ ComQuit 
]

{ #category : #'as yet unclassified' }
MysqlComQuit >> readResponse [
	^ nil
		
]
