"
MySQL command to change user
"
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

{ #category : #accessing }
MySQLCommandChangeUser >> charset: cset [ 
	charset := cset
]

{ #category : #defaults }
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

{ #category : #defaults }
MySQLCommandChangeUser >> commandCode [
	^ ComChangeUser 
]

{ #category : #accessing }
MySQLCommandChangeUser >> database: dbName [
	database := dbName
]

{ #category : #accessing }
MySQLCommandChangeUser >> password: pwd [
	password := pwd
]

{ #category : #operating }
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

{ #category : #scrambling }
MySQLCommandChangeUser >> scrambleBuff: seed [
	scrambleBuff := seed
	
]

{ #category : #scrambling }
MySQLCommandChangeUser >> scrambledPassword: pwd [
	scrambledPassword := pwd
	
]

{ #category : #scrambling }
MySQLCommandChangeUser >> send323Scramble [
	| scrmblPkt |
	scrmblPkt := MySQL323Scramble new.
	scrmblPkt password: password; scrambleBuff: scrambleBuff.
	self writePacket: scrmblPkt
	
]

{ #category : #accessing }
MySQLCommandChangeUser >> user: userName [
	user := userName
]
