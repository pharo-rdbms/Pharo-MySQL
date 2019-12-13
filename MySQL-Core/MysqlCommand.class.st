Class {
	#name : #MySQLCommand,
	#superclass : #MySQLPacket,
	#instVars : [
		'command',
		'arg'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLCommand >> command: cmd arg: text [
	command := cmd.
	arg := text.
	
]

{ #category : #'as yet unclassified' }
MySQLCommand >> write [
	| buffStream |
	buffStream := WriteStream on: ByteArray new.
	buffStream nextPut: command.
	arg isEmptyOrNil ifFalse: [ buffStream nextPutAll: arg asByteArray ].
	^ buffStream contents
]
