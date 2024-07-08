"
Command packet for MySQL
"
Class {
	#name : 'MySQLCommand',
	#superclass : 'MySQLPacket',
	#instVars : [
		'command',
		'arg'
	],
	#category : 'MySQL-Core-Packet',
	#package : 'MySQL-Core',
	#tag : 'Packet'
}

{ #category : 'accessing' }
MySQLCommand >> command: cmd arg: text [
	command := cmd.
	arg := text.
	
]

{ #category : 'writing' }
MySQLCommand >> write [
	| buffStream |

	arg isNil ifTrue: [^ByteArray with: command].
	
	buffStream := WriteStream on: (ByteArray new: arg size + 1).
	buffStream nextPut: command.
	buffStream nextPutAll: arg asByteArray.

	^ buffStream contents
]
