Class {
	#name : #MySQL323Scramble,
	#superclass : #MySQLPacket,
	#instVars : [
		'scrambleBuff',
		'password'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQL323Scramble >> password: pwd [
	password := pwd
	
]

{ #category : #'as yet unclassified' }
MySQL323Scramble >> scrambleBuff: scramble [
	scrambleBuff := scramble 
	
]

{ #category : #'as yet unclassified' }
MySQL323Scramble >> write [
	| scrmbl buffStream |
	buffStream := WriteStream on: (ByteArray new: 256).
	scrmbl := password isEmptyOrNil 
		ifTrue: [ '' asByteArray ]
		ifFalse: 	[ 
			MySQLHelper 
				scramble323: scrambleBuff
				with: password ].
	"Server expects just the scramble, null terminated and nothing else"
	buffStream nextPutAll: scrmbl.
	buffStream nextPut: 0.
	^ buffStream contents 
	
]
