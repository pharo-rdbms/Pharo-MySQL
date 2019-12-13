Class {
	#name : #MysqlNetPacket,
	#superclass : #Object,
	#instVars : [
		'length',
		'number',
		'data'
	],
	#classVars : [
		'MaxPacketLength'
	],
	#category : #'MySQL-Core-Net'
}

{ #category : #'as yet unclassified' }
MysqlNetPacket class >> initialize [
	"self initialize"
	MaxPacketLength := 16rFFFFFF.

]

{ #category : #'as yet unclassified' }
MysqlNetPacket class >> maxLength [
	^ MaxPacketLength
]

{ #category : #accessing }
MysqlNetPacket >> data [
	^ data
]

{ #category : #accessing }
MysqlNetPacket >> data: buffer [ "should be ByteArray"
	data := buffer
]

{ #category : #testing }
MysqlNetPacket >> isOfMaxLength [
	^ length = MaxPacketLength
]

{ #category : #accessing }
MysqlNetPacket >> length [
	^ length 
]

{ #category : #accessing }
MysqlNetPacket >> length: size [
	length := size
]

{ #category : #accessing }
MysqlNetPacket >> maxLength [
	^ MaxPacketLength
]

{ #category : #accessing }
MysqlNetPacket >> number [
	^ number
]

{ #category : #accessing }
MysqlNetPacket >> number: num [
	number := num
]

{ #category : #reading }
MysqlNetPacket >> readFrom: aStream [
	length := aStream next + (aStream next << 8) + (aStream next << 16).
	number := aStream next.
	data := aStream next: length.
]

{ #category : #writing }
MysqlNetPacket >> writeTo: aStream [
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
