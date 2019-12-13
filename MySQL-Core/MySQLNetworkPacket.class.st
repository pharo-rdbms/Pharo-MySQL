"
A MySQL Network packet
"
Class {
	#name : #MySQLNetworkPacket,
	#superclass : #Object,
	#instVars : [
		'length',
		'number',
		'data'
	],
	#classVars : [
		'MaxPacketLength'
	],
	#category : #'MySQL-Core-Network'
}

{ #category : #'class initialization' }
MySQLNetworkPacket class >> initialize [
 
	MaxPacketLength := 16rFFFFFF

]

{ #category : #accessing }
MySQLNetworkPacket class >> maxLength [
	^ MaxPacketLength
]

{ #category : #accessing }
MySQLNetworkPacket >> data [
	^ data
]

{ #category : #accessing }
MySQLNetworkPacket >> data: buffer [ "should be ByteArray"
	data := buffer
]

{ #category : #testing }
MySQLNetworkPacket >> isOfMaxLength [
	^ length = MaxPacketLength
]

{ #category : #accessing }
MySQLNetworkPacket >> length [
	^ length 
]

{ #category : #accessing }
MySQLNetworkPacket >> length: size [
	length := size
]

{ #category : #accessing }
MySQLNetworkPacket >> maxLength [
	^ MaxPacketLength
]

{ #category : #accessing }
MySQLNetworkPacket >> number [
	^ number
]

{ #category : #accessing }
MySQLNetworkPacket >> number: num [
	number := num
]

{ #category : #reading }
MySQLNetworkPacket >> readFrom: aStream [
	length := aStream next + (aStream next << 8) + (aStream next << 16).
	number := aStream next.
	data := aStream next: length.
]

{ #category : #writing }
MySQLNetworkPacket >> writeTo: aStream [
	length = data size
		ifFalse: [ self error: 'Mismatch between packet length and data size' ].
	aStream
		nextPut: (length byteAt: 1);
		nextPut: (length byteAt: 2);
		nextPut: (length byteAt: 3).
	aStream nextPut: (number byteAt: 1).
	(aStream respondsTo: #nextPutAllFlush:)
		ifTrue: [ "this one avoids some data copy" aStream nextPutAllFlush: data ]
		ifFalse: [ aStream
				nextPutAll: data;
				flush ]	"socket streams respond to this"
]
