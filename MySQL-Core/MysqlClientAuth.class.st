"
Client authentication packet for MySQL
"
Class {
	#name : #MySQLClientAuth,
	#superclass : #MySQLPacket,
	#instVars : [
		'user',
		'password',
		'database',
		'scrambleBuff',
		'clientCaps',
		'charset',
		'serverCaps',
		'scrambleBuffMore'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #accessing }
MySQLClientAuth >> charset: csNum [
	charset := csNum
]

{ #category : #accessing }
MySQLClientAuth >> database: db [
	database := db
]

{ #category : #initialization }
MySQLClientAuth >> initialize [
	clientCaps := CapLongFlag + CapTransactions + CapLongPassword + CapConnectWithDb.
	clientCaps := clientCaps + CapProtocol41 + CapSecureConnection.
]

{ #category : #accessing }
MySQLClientAuth >> password: pwd [
	password := pwd.
]

{ #category : #scrambling }
MySQLClientAuth >> scrambleBuff: buffer [
	scrambleBuff := buffer.
]

{ #category : #scrambling }
MySQLClientAuth >> scrambleBuffMore: more [
	scrambleBuffMore := more
]

{ #category : #accessing }
MySQLClientAuth >> serverCaps: caps [ 
	serverCaps := caps
]

{ #category : #accessing }
MySQLClientAuth >> user: userName [
	user := userName
]

{ #category : #writing }
MySQLClientAuth >> write [
	| flags scrmbl buffStream maxNetPacketLength |
	buffStream := WriteStream on: (ByteArray new: 1024).
	flags := serverCaps bitAnd: clientCaps.
	flags := flags bitOr: CapMultiStatements + CapMultiResults.
	buffStream
		nextPut: (flags byteAt: 1);
		nextPut: (flags byteAt: 2);
		nextPut: (flags byteAt: 3);
		nextPut: (flags byteAt: 4).
	maxNetPacketLength := self class maxNetPacketLength.
	buffStream
		nextPut: (maxNetPacketLength byteAt: 1);
		nextPut: (maxNetPacketLength byteAt: 2);
		nextPut: (maxNetPacketLength byteAt: 3);
		nextPut: (maxNetPacketLength byteAt: 4).
	buffStream nextPut: (charset byteAt: 1).
	buffStream nextPutAll: (ByteArray new: 23 withAll: 0).	"filler"
	buffStream nextPutAll: user asByteArray.
	buffStream nextPut: 0.	"null terminated"
	scrmbl := password isEmptyOrNil
		ifTrue: [ '' asByteArray ]
		ifFalse: [ MySQLHelper
				secureScramble: scrambleBuff , scrambleBuffMore
				with: password ].
	self encodeLcs: scrmbl on: buffStream.
	(flags bitAnd: CapConnectWithDb) = CapConnectWithDb
		ifTrue: [ database isEmptyOrNil not
				ifTrue: [ buffStream nextPutAll: database asByteArray ].
			buffStream nextPut: 0	"null terminated" ].
	^ buffStream contents
]
