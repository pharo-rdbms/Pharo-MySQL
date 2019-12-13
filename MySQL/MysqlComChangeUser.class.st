Class {
	#name : #MysqlComChangeUser,
	#superclass : #MysqlComBase,
	#instVars : [
		'user',
		'password',
		'database',
		'charset',
		'scrambleBuff',
		'scrambledPassword'
	],
	#category : #'MySQL-Command'
}

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> charset: cset [ 
	charset := cset
]

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> commandArg [
	| buffStream |
	buffStream := WriteStream on: ByteArray new.
	buffStream
		nextPutAll: user asByteArray;
		nextPut: 0.
	MysqlPacket new
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
MysqlComChangeUser >> commandCode [
	^ ComChangeUser 
]

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> database: dbName [
	database := dbName
]

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> password: pwd [
	password := pwd
]

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> readResponse [
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
		
	MysqlDriverError signal: 'Unrecognized response for command'
	
]

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> scrambleBuff: seed [
	scrambleBuff := seed
	
]

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> scrambledPassword: pwd [
	scrambledPassword := pwd
	
]

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> send323Scramble [
	| scrmblPkt |
	scrmblPkt := Mysql323Scramble new.
	scrmblPkt password: password; scrambleBuff: scrambleBuff.
	self writePacket: scrmblPkt
	
]

{ #category : #'as yet unclassified' }
MysqlComChangeUser >> user: userName [
	user := userName
]
