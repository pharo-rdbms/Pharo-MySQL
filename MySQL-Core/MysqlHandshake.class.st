"
Handshake packet for MySQL
"
Class {
	#name : #MySQLHandshake,
	#superclass : #MySQLPacket,
	#instVars : [
		'protocolVer',
		'serverVer',
		'threadId',
		'scrambleBuff',
		'serverCap',
		'serverLang',
		'scrambleBuffMore',
		'serverStatus'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #parsing }
MySQLHandshake >> parse [ 
	protocolVer := inStream next.
	serverVer := (inStream upTo: 0) asString.
	threadId := inStream next + (inStream next bitShift: 8) + 
		(inStream next bitShift: 16) + (inStream next bitShift: 24).
	scrambleBuff := inStream next: 8.
	inStream skip: 1.	"always 0"
	serverCap := inStream next + (inStream next bitShift: 8).
	serverLang := inStream next.
	serverStatus := inStream next + (inStream next bitShift: 8).
	inStream skip: 13.	"filler"
	self supportsProtocol41 ifFalse: [ ^ self ].
	scrambleBuffMore := inStream next: 12.
	inStream skip: 1	"always 0"

]

{ #category : #accessing }
MySQLHandshake >> scrambleBuff [
	
	^ scrambleBuff
	
	"self supports41 
		ifTrue: [^ scrambleBuff, scrambleBuffMore]
		ifFalse: [^ scrambleBuff]."
]

{ #category : #scrambling }
MySQLHandshake >> scrambleBuffMore [
	^scrambleBuffMore 
]

{ #category : #accessing }
MySQLHandshake >> serverCaps [
	^ serverCap
]

{ #category : #accessing }
MySQLHandshake >> serverLang [
	^ serverLang
]

{ #category : #accessing }
MySQLHandshake >> serverStatus [
	^ serverStatus
]

{ #category : #accessing }
MySQLHandshake >> serverVer [
	^ serverVer
]

{ #category : #testing }
MySQLHandshake >> supportsProtocol41 [
	^ (serverCap bitAnd: CapProtocol41) = CapProtocol41
]
