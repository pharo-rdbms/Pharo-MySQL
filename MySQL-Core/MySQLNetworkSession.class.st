"
A MySQL Network session
"
Class {
	#name : #MySQLNetworkSession,
	#superclass : #Object,
	#instVars : [
		'theStream',
		'nextPacketNumber',
		'peekData'
	],
	#category : #'MySQL-Core-Network'
}

{ #category : #testing }
MySQLNetworkSession >> connected [
	^ theStream ifNil: [false] ifNotNil: [theStream isConnected] 
]

{ #category : #accessing }
MySQLNetworkSession >> disconnect [
	theStream isConnected ifTrue: [theStream close] .

]

{ #category : #'sequence numbering' }
MySQLNetworkSession >> getSequence [
	^ nextPacketNumber 
]

{ #category : #'initialize-release' }
MySQLNetworkSession >> initialize [
	self resetSequence.

]

{ #category : #reading }
MySQLNetworkSession >> peek [
	"Look ahead; don't remove the packet until next read"
	peekData ifNil: [peekData := self readPacketData].
	^ peekData
]

{ #category : #reading }
MySQLNetworkSession >> read [
	| data |
	"Return packet from look ahead buffer if any. Clear look ahead buffer"
	peekData ifNotNil: [data := peekData. peekData := nil. ^ data].
	^ self readPacketData
	
]

{ #category : #reading }
MySQLNetworkSession >> readNetPacket [
	| pkt |
	pkt := MySQLNetworkPacket new.
	pkt readFrom: theStream.
	self validatePacket: pkt.
	^ pkt
]

{ #category : #reading }
MySQLNetworkSession >> readPacketData [
	"Read all packets until there is no more packets of data."
	| dataPackets pkt totalSize buffer ii |
	dataPackets := OrderedCollection new.
	
	[ pkt := self readNetPacket.
	dataPackets add: pkt ] doWhileTrue: [ pkt isOfMaxLength	"indicates more packets to follow" ].

	"Gather data from all packets and return. Avoid another copy where possible"
	dataPackets size = 1 ifTrue: [ ^ dataPackets first data ].	"only one pcaket"
	(dataPackets size = 2 and: [ dataPackets last length = 0 ]) 
		ifTrue: [ ^ dataPackets first data ].	"second packet is empty"
	"Multiple packets; put the data together before returning"
	totalSize := dataPackets inject: 0 into: [:total :each | total + each length].
	buffer := ByteArray new: totalSize.
	ii := 1.
	^ dataPackets 
		inject: buffer
		into: [ :result :packet | 
			result replaceFrom: ii to: (ii + packet length - 1) with: packet data startingAt: 1.
			ii := ii + packet length.
			result]
]

{ #category : #'sequence numbering' }
MySQLNetworkSession >> resetSequence [
	nextPacketNumber := 0
]

{ #category : #accessing }
MySQLNetworkSession >> stream: aStream [
	theStream := aStream
	
]

{ #category : #accessing }
MySQLNetworkSession >> toHost: host andPort: port [ 
	| aStream |
	self resetSequence.
	[aStream := SocketStream 
		openConnectionToHostNamed: host
		port: port.
	"Turn off Nagle algorithm, else response time to short packets would suffer. Thanks to
	Goran Krampe for studying the issue in Ubuntu linux and figure out the details. Ref:
	http://developers.slashdot.org/comments.pl?sid=174457&threshold=1&commentsort=0&mode=thread&cid=14515105 for comments from John Nagle himself."
	aStream socket setOption: 'TCP_NODELAY' value: true.
	aStream binary. 
	self stream: aStream] 
		on: NameLookupFailure 
		do: [:ex | MySQLNameLookupFailure signal: ex messageText] 
]

{ #category : #'sequence numbering' }
MySQLNetworkSession >> updateSequence [
	nextPacketNumber := (nextPacketNumber + 1) bitAnd: 255
]

{ #category : #reading }
MySQLNetworkSession >> validatePacket: pkt [
	"Validate a network packet unit. Currently we validate the sequence number."
	"Update sequence if validation passes"
	(self validateSequence: pkt number)
		ifTrue: [self updateSequence]
		ifFalse: [^ self error: 'Packet sequence validation error']
	
]

{ #category : #'sequence numbering' }
MySQLNetworkSession >> validateSequence: pktNumber [ 
	^ pktNumber = nextPacketNumber
]

{ #category : #writing }
MySQLNetworkSession >> write: data [ 
	self writePacketData: data

]

{ #category : #writing }
MySQLNetworkSession >> writeNetPacket: pkt [
	"Write a network packet unit to the underlying stream".
	pkt writeTo: theStream
	
]

{ #category : #writing }
MySQLNetworkSession >> writePacketData: data [ 
	| pkt nextPktStart dataLen |
	
	nextPktStart := 1.
	dataLen := data size.
	[	pkt := MySQLNetworkPacket new.
		pkt length: (dataLen min: pkt maxLength);
			number: self getSequence;
			data: (data copyFrom: nextPktStart  to: (nextPktStart + pkt length - 1)).
			
		self updateSequence.
		dataLen := dataLen - pkt length.
		nextPktStart := nextPktStart + pkt length.
		
		self writeNetPacket: pkt
	] doWhileTrue: [ pkt isOfMaxLength ]
]
