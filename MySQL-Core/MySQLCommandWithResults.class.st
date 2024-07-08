Class {
	#name : 'MySQLCommandWithResults',
	#superclass : 'MySQLCommandBase',
	#category : 'MySQL-Core-Command',
	#package : 'MySQL-Core',
	#tag : 'Command'
}

{ #category : 'testing' }
MySQLCommandWithResults >> gotEof [
	^ (MySQLPacket from: session peek) isEof 
]

{ #category : 'testing' }
MySQLCommandWithResults >> readEof [
	^ MySQLEof from: session read
]
