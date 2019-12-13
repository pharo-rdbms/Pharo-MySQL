Class {
	#name : #MysqlCommand,
	#superclass : #MysqlPacket,
	#instVars : [
		'command',
		'arg'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MysqlCommand >> command: cmd arg: text [
	command := cmd.
	arg := text.
	
]

{ #category : #'as yet unclassified' }
MysqlCommand >> write [
	| buffStream |
	buffStream := WriteStream on: ByteArray new.
	buffStream nextPut: command.
	arg isEmptyOrNil ifFalse: [ buffStream nextPutAll: arg asByteArray ].
	^ buffStream contents
]
