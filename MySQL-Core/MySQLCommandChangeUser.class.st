Class {
	#name : #MySQLCommandChangeUser,
	#superclass : #MySQLCommandBase,
	#instVars : [
		'user',
		'password',
		'database',
		'charset',
		'scrambleBuff',
		'scrambledPassword'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> charset: cset [ 
	charset := cset
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> commandArg [
	| buffStream |
	buffStream := WriteStream on: ByteArray new.
	buffStream
		nextPutAll: user asByteArray;
		nextPut: 0.
	MySQLPacket new
		encodeLcs: scrambledPassword asByteArray
		on: buffStream.
	buffStream
		nextPutAll:
			(database ifNil: [ '' asByteArray ] ifNotNil: [ database asByteArray ]);
		nextPut: 0.
	buffStream
		nextPut: (charset byteAt: 1);
		nextPut: (charset byteAt: 2).
	^ buffStream contents
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> commandCode [
	^ ComChangeUser 
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> database: dbName [
	database := dbName
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> password: pwd [
	password := pwd
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> readResponse [
	| pkt |

	pkt := super readResponse.
	pkt isOkayOrError 
		ifTrue: [^ pkt].
		
	pkt isEof ifTrue: [
		"Absorb the response"
		session read.
		"For old (short) hash style passwords"
		self send323Scramble.
		pkt := super readResponse.
		pkt isOkayOrError 
			ifTrue: [^ pkt]].
		
	MySQLDriverError signal: 'Unrecognized response for command'
	
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> scrambleBuff: seed [
	scrambleBuff := seed
	
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> scrambledPassword: pwd [
	scrambledPassword := pwd
	
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> send323Scramble [
	| scrmblPkt |
	scrmblPkt := MySQL323Scramble new.
	scrmblPkt password: password; scrambleBuff: scrambleBuff.
	self writePacket: scrmblPkt
	
]

{ #category : #'as yet unclassified' }
MySQLCommandChangeUser >> user: userName [
	user := userName
]
