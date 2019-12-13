Class {
	#name : #MySQLNetworkSessionTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'ioStream',
		'maxLen'
	],
	#category : #'MySQL-Core-Tests-Integration-Network'
}

{ #category : #initialization }
MySQLNetworkSessionTest >> initialize [
	maxLen := MySQLNetworkPacket maxLength.

]

{ #category : #accessing }
MySQLNetworkSessionTest >> maxLen [
	^maxLen 
]

{ #category : #running }
MySQLNetworkSessionTest >> setUp [
	session := MySQLNetworkSession new.
	ioStream := ReadWriteStream on: (ByteArray new). "test stream"
	ioStream binary; reset. 
	session stream: ioStream "inject test stream instead of using socket stream"
	
]

{ #category : #tests }
MySQLNetworkSessionTest >> testBigSizeReadWrite [
	| pktData |
	
	pktData := ByteArray new: self maxLen * 2 + (self maxLen >> 8) withAll: 16rAA.
	self verifyWriteFollowedByReadForData: pktData	
]

{ #category : #tests }
MySQLNetworkSessionTest >> testLessThanMaxSizeReadWrite [
	| pktData |
	
	pktData := ByteArray new: self maxLen >> 8 withAll: 16rAA.
	self verifyWriteFollowedByReadForData: pktData	
]

{ #category : #tests }
MySQLNetworkSessionTest >> testMaxSizeReadWrite [
	| pktData |
	
	pktData := ByteArray new: self maxLen withAll: 16rAA.
	self verifyWriteFollowedByReadForData: pktData	
]

{ #category : #tests }
MySQLNetworkSessionTest >> testSequenceNumbering [
	self assert: (session getSequence = 0) description: '0 right after creation'.
	self assert: (session validateSequence: 0).

	session updateSequence.
	self assert: (session getSequence = 1).
	self assert: (session validateSequence: 1).
	255 timesRepeat: [session updateSequence].
	self assert: (session getSequence = 0) description: 'Modulo 256'.
	self assert: (session validateSequence: 0).

	10 timesRepeat: [session updateSequence].
	self assert: (session getSequence = 10).
	self assert: (session validateSequence: 10).
	
	session resetSequence.
	self assert: (session getSequence = 0).
	self assert: (session validateSequence: 0) 
	
]

{ #category : #private }
MySQLNetworkSessionTest >> verifyWriteFollowedByReadForData: writeData [
	| readData |

	session write: writeData.

	ioStream reset.
	session resetSequence.

	readData := session readPacketData.
	self assert: (readData size = writeData size).
	self assert: (readData hasEqualElements: writeData)
	
]
