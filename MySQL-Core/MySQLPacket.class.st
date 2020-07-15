"
Abtract superclass for network packet exchanged with MySQL
"
Class {
	#name : #MySQLPacket,
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

{ #category : #'instance creation' }
MySQLPacket class >> from: data [
	^ self new 
		read: data
	
]

{ #category : #initialization }
MySQLPacket class >> initCapabilititesFlags [
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

{ #category : #initialization }
MySQLPacket class >> initialize [
	"
	self initialize
	"
	self initCapabilititesFlags.


]

{ #category : #accessing }
MySQLPacket class >> maxNetPacketLength [
	^ MySQLNetworkPacket maxLength
]

{ #category : #parsing }
MySQLPacket >> decodeLcbFrom: byteStream [ 
	^ MySQLHelper decodeLcbFrom: byteStream 
	
]

{ #category : #parsing }
MySQLPacket >> decodeLcsFrom: aStream [ 
	^ MySQLHelper decodeLcsFrom: aStream 
	
]

{ #category : #parsing }
MySQLPacket >> encodeLcb: value on: aStream [ 
	^ MySQLHelper encodeLcb: value on: aStream 
	
]

{ #category : #parsing }
MySQLPacket >> encodeLcs: bytes on: aStream [
	MySQLHelper encodeLcs: bytes on: aStream
	
]

{ #category : #testing }
MySQLPacket >> isEof [
	^ (discriminator = 16rFE) and: [inStream size < 9]

]

{ #category : #testing }
MySQLPacket >> isError [
	^ discriminator = 16rFF

]

{ #category : #testing }
MySQLPacket >> isOkay [
	^ discriminator = 16r00

]

{ #category : #testing }
MySQLPacket >> isOkayOrError [
	^ self isOkay or: [self isError]
]

{ #category : #testing }
MySQLPacket >> isPrepareResponse [
	^ false
	
]

{ #category : #testing }
MySQLPacket >> isResultSet [
	^ false
]

{ #category : #parsing }
MySQLPacket >> parse [
	"Default implementation; required for reading a generic (yet unknown) type of packet"
	"No parsing here; subclasses implement packet specific parsing"
	
]

{ #category : #reading }
MySQLPacket >> read: buffer [
	discriminator := buffer first.
	inStream := ReadStream on: buffer.
	self parse
	
]
