"
Field packet for MySQL
"
Class {
	#name : #MySQLField,
	#superclass : #MySQLPacket,
	#instVars : [
		'catalog',
		'db',
		'table',
		'orgTable',
		'name',
		'orgName',
		'charSet',
		'type',
		'flags',
		'default',
		'decimals',
		'length'
	],
	#classVars : [
		'AutoIncrFlag',
		'BinaryFlag',
		'BlobFlag',
		'EnumFlag',
		'MultiKeyFlag',
		'NotNullFlag',
		'PrimaryKeyFlag',
		'SetFlag',
		'TimestampFlag',
		'UniqueKeyFlag',
		'UnsignedFlag',
		'ZeroFillFlag'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'private - initialization' }
MySQLField class >> initBitMasksForFlags [
	NotNullFlag := 16r0001.
	PrimaryKeyFlag := 16r0002.
	UniqueKeyFlag := 16r0004.
	MultiKeyFlag := 16r0008.
	BlobFlag := 16r0010.
	UnsignedFlag := 16r0020.
	ZeroFillFlag := 16r0040.
	BinaryFlag := 16r0080.
	EnumFlag := 16r0100.
	AutoIncrFlag := 16r0200.
	TimestampFlag := 16r0400.
	SetFlag := 16r0800.
	
	

]

{ #category : #initialization }
MySQLField class >> initialize [
	"self initialize"
	self initBitMasksForFlags.
	self initializeTypeConverters.
]

{ #category : #initialization }
MySQLField class >> initializeTypeConverters [
	TypeConverters ifNil: [ 
		TypeConverters := Dictionary new. 
		
		
		]
]

{ #category : #accessing }
MySQLField >> db [
	^ db
	
]

{ #category : #accessing }
MySQLField >> decimals [
	^ decimals 
]

{ #category : #testing }
MySQLField >> isAutoIncrement [
	^ (flags bitAnd: AutoIncrFlag) = AutoIncrFlag   
	
]

{ #category : #testing }
MySQLField >> isNullable [
	^ (flags bitAnd: NotNullFlag) ~= NotNullFlag  
	
]

{ #category : #testing }
MySQLField >> isPrimaryKey [
	^ (flags bitAnd: PrimaryKeyFlag) = PrimaryKeyFlag  
	
]

{ #category : #testing }
MySQLField >> isUnsigned [
	^ (flags bitAnd: UnsignedFlag) = UnsignedFlag 
	
]

{ #category : #accessing }
MySQLField >> length [
	^ length 
	
]

{ #category : #accessing }
MySQLField >> name [
	^ name
	
]

{ #category : #accessing }
MySQLField >> parse [
	catalog := (self decodeLcsFrom: inStream) asString.
	db := (self decodeLcsFrom: inStream) asString.
	table := (self decodeLcsFrom: inStream) asString.
	orgTable := (self decodeLcsFrom: inStream) asString.
	name := (self decodeLcsFrom: inStream) asString.
	orgName := (self decodeLcsFrom: inStream) asString.
	inStream next. "filler"
	charSet := inStream next + (inStream next bitShift: 8).
	length := inStream next + (inStream next bitShift: 8) + 
		(inStream next bitShift: 16) + (inStream next bitShift: 24).
	type := inStream next.
	flags := inStream next + (inStream next bitShift: 8).
	decimals := inStream next.
	inStream next; next. "2 filler"
	"The field default only appears for table definitions, not for normal resultsets"
	inStream atEnd ifFalse: [default := self decodeLcbFrom: inStream].
	
]

{ #category : #accessing }
MySQLField >> table [
	^ table
	
]

{ #category : #accessing }
MySQLField >> type [
	^ type
	
]

{ #category : #'as yet unclassified' }
MySQLField >> typedValueFrom: aString [
	^(TypeConverters 
		at: self type 
		ifAbsent: [ self error: ('No Type Converter Registered For Type: ', (self type asString)) ])
			value: aString
]
