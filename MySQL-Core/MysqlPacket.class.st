Class {
	#name : #MysqlPacket,
	#superclass : #Object,
	#instVars : [
		'inStream',
		'discriminator'
	],
	#classVars : [
		'CapCompress',
		'CapConnectWithDb',
		'CapFoundRows',
		'CapIgnoreSigpipe',
		'CapIgnoreSpace',
		'CapInteractive',
		'CapLocalFiles',
		'CapLongFlag',
		'CapLongPassword',
		'CapMultiResults',
		'CapMultiStatements',
		'CapNoSchema',
		'CapOdbc',
		'CapProtocol41',
		'CapReserved',
		'CapSecureConnection',
		'CapSsl',
		'CapTransactions'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MysqlPacket class >> from: data [
	^ self new 
		read: data
	
]

{ #category : #'as yet unclassified' }
MysqlPacket class >> initCapabilititesFlags [
	CapLongPassword := 1.
	CapFoundRows := 1 bitShift: 1.
	CapLongFlag := 1 bitShift: 2.
	CapConnectWithDb := 1 bitShift: 3.
	CapNoSchema := 1 bitShift: 4.
	CapCompress := 1 bitShift: 5.
	CapOdbc := 1 bitShift: 6.
	CapLocalFiles := 1 bitShift: 7.
	CapIgnoreSpace := 1 bitShift: 8.
	CapProtocol41 := 1 bitShift: 9.
	CapInteractive := 1 bitShift: 10.
	CapSsl := 1 bitShift: 11.
	CapIgnoreSigpipe := 1 bitShift: 12.
	CapTransactions := 1 bitShift: 13.
	CapReserved := 1 bitShift: 14.
	CapSecureConnection := 1 bitShift: 15.
	CapMultiStatements := 1 bitShift: 16.
	CapMultiResults := 1 bitShift: 17.

]

{ #category : #'as yet unclassified' }
MysqlPacket class >> initialize [
	"
	self initialize
	"
	self initCapabilititesFlags.


]

{ #category : #'as yet unclassified' }
MysqlPacket class >> maxNetPacketLength [
	^ MysqlNetPacket maxLength
]

{ #category : #'as yet unclassified' }
MysqlPacket >> decodeLcbFrom: byteStream [ 
	^ MysqlHelper decodeLcbFrom: byteStream 
	
]

{ #category : #'as yet unclassified' }
MysqlPacket >> decodeLcsFrom: aStream [ 
	^ MysqlHelper decodeLcsFrom: aStream 
	
]

{ #category : #'as yet unclassified' }
MysqlPacket >> encodeLcb: value on: aStream [ 
	^ MysqlHelper encodeLcb: value on: aStream 
	
]

{ #category : #'as yet unclassified' }
MysqlPacket >> encodeLcs: bytes on: aStream [
	MysqlHelper encodeLcs: bytes on: aStream
	
]

{ #category : #'as yet unclassified' }
MysqlPacket >> isEof [
	^ (discriminator = 16rFE) and: [inStream size < 9]

]

{ #category : #'as yet unclassified' }
MysqlPacket >> isError [
	^ discriminator = 16rFF

]

{ #category : #'as yet unclassified' }
MysqlPacket >> isOkay [
	^ discriminator = 16r00

]

{ #category : #'as yet unclassified' }
MysqlPacket >> isOkayOrError [
	^ self isOkay or: [self isError]
]

{ #category : #'as yet unclassified' }
MysqlPacket >> isPrepareResponse [
	^ false
	
]

{ #category : #'as yet unclassified' }
MysqlPacket >> isResultSet [
	^ false
]

{ #category : #'as yet unclassified' }
MysqlPacket >> parse [
	"Default implementation; required for reading a generic (yet unknown) type of packet"
	"No parsing here; subclasses implement packet specific parsing"
	
]

{ #category : #'as yet unclassified' }
MysqlPacket >> read: buffer [
	discriminator := buffer first.
	inStream := ReadStream on: buffer.
	self parse
	
]

{ #category : #'as yet unclassified' }
MysqlPacket >> write [
	self subclassResponsibility 
]
