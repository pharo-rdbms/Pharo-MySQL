Class {
	#name : #Mysql323Scramble,
	#superclass : #MysqlPacket,
	#instVars : [
		'scrambleBuff',
		'password'
	],
	#category : #'MySQL-Packet'
}

{ #category : #'as yet unclassified' }
Mysql323Scramble >> password: pwd [
	password := pwd
	
]

{ #category : #'as yet unclassified' }
Mysql323Scramble >> scrambleBuff: scramble [
	scrambleBuff := scramble 
	
]

{ #category : #'as yet unclassified' }
Mysql323Scramble >> write [
	| scrmbl buffStream |
	buffStream := WriteStream on: (ByteArray new: 256).
	scrmbl := password isEmptyOrNil 
		ifTrue: [ '' asByteArray ]
		ifFalse: 	[ 
			MysqlHelper 
				scramble323: scrambleBuff
				with: password ].
	"Server expects just the scramble, null terminated and nothing else"
	buffStream nextPutAll: scrmbl.
	buffStream nextPut: 0.
	^ buffStream contents 
	
]
