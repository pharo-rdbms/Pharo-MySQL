"
Database bind parameter for MySQL
"
Class {
	#name : 'MySQLBindParameter',
	#superclass : 'Object',
	#instVars : [
		'paramValue',
		'paramType',
		'newParamBound',
		'unsignedFlag',
		'declaredUnsigned',
		'sentAsLongData'
	],
	#category : 'MySQL-Core-Utilities',
	#package : 'MySQL-Core',
	#tag : 'Utilities'
}

{ #category : 'as yet unclassified' }
MySQLBindParameter class >> listOfSize: count forDescriptors: fields [
	| params |
	params := (1 to: count) collect: [:each |  
			(self new 
				declaredUnsigned: (fields at: each) isUnsigned; 
				yourself)].
	^ params
	
]

{ #category : 'as yet unclassified' }
MySQLBindParameter class >> withValue: aValue [
	^ self new
		bindValue: aValue;
		yourself
	
]

{ #category : 'private' }
MySQLBindParameter >> bigIntRange [
	^ self isDeclaredUnsigned 
		ifTrue: [16r0000000000000000 to: 16rFFFFFFFFFFFFFFFF] 
		ifFalse: [-16r8000000000000000 to: 16r7FFFFFFFFFFFFFFF].

]

{ #category : 'accessing' }
MySQLBindParameter >> bindValue: aValue [ 
	| boundType |
	paramValue := aValue.
	(boundType := (aValue mySQLParamTypeFor: self)) ~= paramType 
		ifTrue: [
			paramType := boundType.
			newParamBound := true].
	unsignedFlag := aValue mySQLParamSign
]

{ #category : 'writes' }
MySQLBindParameter >> dateTimeBytes [
	| dt year length micros |
	ByteArray
		streamContents: [ :strm | 
			dt := paramValue asDateAndTime.
			length := 0.
			strm nextPut: length.	"will re-adjust this as different conditions are found"
			year := dt year.
			strm
				nextPut: (year byteAt: 1);
				nextPut: (year byteAt: 2);
				"year"
					nextPut: (dt month byteAt: 1);
				nextPut: (dt dayOfMonth byteAt: 1).
			strm
				nextPut: (dt hour byteAt: 1);
				nextPut: (dt minute byteAt: 1);
				nextPut: (dt second byteAt: 1).
			micros := dt nanoSecond // 1000.
			strm
				nextPut: (micros byteAt: 1);
				nextPut: (micros byteAt: 2);
				nextPut: (micros byteAt: 3);
				nextPut: (micros byteAt: 4).

			"Update the length field now."
			length := 11.
			micros = 0
				ifTrue: [ length := 7.	"no sub-seconds to send"
					((dt hour = 0 and: [ dt minute = 0 ]) and: [ dt second = 0 ])
						ifTrue: [ "no hh:mm:ss to send"
							length := 4.
							(dt year = 0 and: [ dt month = 0 and: [ dt day = 0 ] ])
								ifTrue: [ "no yy-mm-dd to send" length := 0 ] ] ].
			strm
				reset;
				nextPut: length;
				setToEnd.
			^ strm contents first: length + 1	"remember to send the length byte itself" ]
]

{ #category : 'writes' }
MySQLBindParameter >> decimalBytes [
	"For scaled decimal"
	ByteArray streamContents: [:strm |
		MySQLHelper encodeLcs: (paramValue printString allButLast:2) asByteArray on: strm.
		^ strm contents]
]

{ #category : 'accessing' }
MySQLBindParameter >> declaredUnsigned: aBoolean [
	declaredUnsigned := aBoolean
	
]

{ #category : 'accessing' }
MySQLBindParameter >> detectParamSign [
	"true is unsigned, false if signed"
	^ (((paramValue isKindOf: Number) or: [paramValue isKindOf: Duration]) and: [paramValue negative]) not
	
]

{ #category : 'accessing' }
MySQLBindParameter >> detectParamType [
	"Corresponding database type needs to be inferred from the bound value"
	^paramValue mySQLParamTypeFor: self
]

{ #category : 'writes' }
MySQLBindParameter >> doubleBytes [
	| storable |
	ByteArray
		streamContents: [ :strm | 
			storable := paramValue asFloat at: 2.
			strm
				nextPut: (storable byteAt: 1);
				nextPut: (storable byteAt: 2);
				nextPut: (storable byteAt: 3);
				nextPut: (storable byteAt: 4).
			storable := paramValue asFloat at: 1.
			strm
				nextPut: (storable byteAt: 1);
				nextPut: (storable byteAt: 2);
				nextPut: (storable byteAt: 3);
				nextPut: (storable byteAt: 4).
			^ strm contents ]
]

{ #category : 'writes' }
MySQLBindParameter >> floatBytes [
	| storable |
	ByteArray
		streamContents: [ :strm | 
			storable := paramValue asFloat at: 1.	"indexed accedd into a Float"
			strm
				nextPut: (storable byteAt: 1);
				nextPut: (storable byteAt: 2);
				nextPut: (storable byteAt: 3);
				nextPut: (storable byteAt: 4).
			^ strm contents ]
]

{ #category : 'initialize-release' }
MySQLBindParameter >> initialize [
	newParamBound := false.
	paramType := MySQLTypes typeNULL.
	unsignedFlag := declaredUnsigned := false.
	sentAsLongData := false
	
]

{ #category : 'writes' }
MySQLBindParameter >> integerBytes: size [
	| storable |
	ByteArray
		streamContents: [ :strm | 
			storable := self storableIntegerValueOfSize: size.
			1 to: size do: [ :ii | strm nextPut: (storable byteAt: ii) ].
			^ strm contents ]
]

{ #category : 'testing' }
MySQLBindParameter >> isDeclaredUnsigned [
	^ declaredUnsigned  
	
]

{ #category : 'testing' }
MySQLBindParameter >> isInBigIntRange: anInteger [
	^ self isDeclaredUnsigned 
		ifTrue: [anInteger between: 16r0000000000000000 and: 16rFFFFFFFFFFFFFFFF] 
		ifFalse: [anInteger between: -16r8000000000000000 and: 16r7FFFFFFFFFFFFFFF]
]

{ #category : 'testing' }
MySQLBindParameter >> isInLongIntRange: anInteger [
	^ self isDeclaredUnsigned 
		ifTrue: [anInteger between: 16r00000000 and: 16rFFFFFFFF] 
		ifFalse: [anInteger between: -16r80000000 and: 16r7FFFFFFF]
]

{ #category : 'testing' }
MySQLBindParameter >> isInSmallIntRange: anInteger [
	^ self isDeclaredUnsigned 
		ifTrue: [anInteger between: 16r0000 and: 16rFFFF]
		ifFalse: [anInteger between: -16r8000 and: 16r7FFF]

]

{ #category : 'testing' }
MySQLBindParameter >> isInTinyIntRange: anInteger [
	^ self isDeclaredUnsigned 
		ifTrue: [anInteger between: 16r00 and: 16rFF] 
		ifFalse: [anInteger between: -16r80 and: 16r7F]
]

{ #category : 'testing' }
MySQLBindParameter >> isLongData [

	^paramValue notNil and: [(self paramType = MySQLTypes typeVARCHAR or: [self paramType between: MySQLTypes typeLONGBLOB and: MySQLTypes typeSTRING]) and: [paramValue size > 1048576 "2**20"]]
]

{ #category : 'testing' }
MySQLBindParameter >> isNull [
	^ paramType = MySQLTypes typeNULL
	
]

{ #category : 'testing' }
MySQLBindParameter >> isRebound [
	^ newParamBound 
	
]

{ #category : 'testing' }
MySQLBindParameter >> isUnsigned [
	^ unsignedFlag 
	
]

{ #category : 'private' }
MySQLBindParameter >> longIntRange [
	^ self isDeclaredUnsigned 
		ifTrue: [16r00000000 to: 16rFFFFFFFF] 
		ifFalse: [-16r80000000 to: 16r7FFFFFFF].

]

{ #category : 'accessing' }
MySQLBindParameter >> paramType [
	^ paramType 
	
]

{ #category : 'accessing' }
MySQLBindParameter >> resetReboundFlag [
	newParamBound := false
	
]

{ #category : 'testing' }
MySQLBindParameter >> sentAsLongData [
	^ sentAsLongData
	
]

{ #category : 'accessing' }
MySQLBindParameter >> sentAsLongData: aBoolean [
	sentAsLongData := aBoolean
	
]

{ #category : 'private' }
MySQLBindParameter >> smallIntRange [
	^ self isDeclaredUnsigned ifTrue: [16r0000 to: 16rFFFF] ifFalse: [-16r8000 to: 16r7FFF].

]

{ #category : 'writes' }
MySQLBindParameter >> storableIntegerValueOfSize: size [ 
	(paramValue isKindOf: Boolean) ifTrue: [^ paramValue ifTrue: [1] ifFalse: [0]].
	^ paramValue negative 
		ifTrue: [ (1 << (size * 8)) + paramValue ]
		ifFalse: [ paramValue ]
]

{ #category : 'accessing' }
MySQLBindParameter >> storeBinaryOn: aStream [		
	paramType 
	caseOf: {
		[MySQLTypes typeNULL]->[].
		[MySQLTypes typeTINY]->[aStream nextPutAll: (self integerBytes: 1)].
		[MySQLTypes typeSHORT]->[aStream nextPutAll: (self integerBytes: 2)].
		[MySQLTypes typeLONG]->[aStream nextPutAll: (self integerBytes: 4)].		
		[MySQLTypes typeLONGLONG]->[aStream nextPutAll: (self integerBytes: 8)].	
		[MySQLTypes typeFLOAT]->[aStream nextPutAll: (self floatBytes)].
		[MySQLTypes typeDOUBLE]->[aStream nextPutAll: (self doubleBytes)].
		[MySQLTypes typeTIME]->[aStream nextPutAll: self timeBytes].
		[MySQLTypes typeDATE]->[aStream nextPutAll: self dateTimeBytes].
		[MySQLTypes typeTIMESTAMP]->[aStream nextPutAll: self dateTimeBytes].
		[MySQLTypes typeDATETIME]->[aStream nextPutAll: self dateTimeBytes].	
		[MySQLTypes typeDECIMAL]->[aStream nextPutAll: self decimalBytes]	
	} 
	otherwise: [aStream nextPutAll: self stringOrBlobBytes]
	
]

{ #category : 'writes' }
MySQLBindParameter >> stringOrBlobBytes [		
	ByteArray streamContents: [:strm |
		MySQLHelper encodeLcs: self stringOrBlobBytesRaw on: strm.
		^ strm contents]
	
]

{ #category : 'writes' }
MySQLBindParameter >> stringOrBlobBytesRaw [
	| mappedValue |
	mappedValue := ((paramValue isKindOf: Character) or: [ paramValue isKindOf: Text ]) 
		ifTrue: [ paramValue asString ]
		ifFalse: [ paramValue ].
	^ mappedValue asByteArray
]

{ #category : 'writes' }
MySQLBindParameter >> timeBytes [
	| dur days length micros |
	ByteArray
		streamContents: [ :strm | 
			"length byte plus rest"
			dur := paramValue asDuration.
			length := 0.
			strm nextPut: length.	"will re-adjust this as different conditions are found"
			dur negative
				ifTrue: [ strm nextPut: 1 ]
				ifFalse: [ strm nextPut: 0 ].
			days := dur days.
			strm
				nextPut: (days byteAt: 1);
				nextPut: (days byteAt: 2);
				nextPut: (days byteAt: 3);
				nextPut: (days byteAt: 4).
			strm
				nextPut: (dur hours byteAt: 1);
				nextPut: (dur minutes byteAt: 1);
				nextPut: (dur seconds asInteger byteAt: 1).
			micros := dur nanoSeconds // 1000.
			strm
				nextPut: (micros byteAt: 1);
				nextPut: (micros byteAt: 2);
				nextPut: (micros byteAt: 3);
				nextPut: (micros byteAt: 4).

			"Update the length field now."
			length := 11.
			micros = 0
				ifTrue: [ length := 7.	"no sub-seconds to send"
					(dur hours = 0 and: [ dur minutes = 0 and: [ dur seconds = 0 ] ])
						ifTrue: [ "no hh:mm:ss to send"
							length := 4.
							dur days = 0
								ifTrue: [ length := 0 ] ] ].
			length > 0
				ifTrue: [ length := length + 1	"include sign byte" ].
			strm
				reset;
				nextPut: length;
				setToEnd.
			^ strm contents first: length + 1 ]
]

{ #category : 'private' }
MySQLBindParameter >> tinyIntRange [
	^ self isDeclaredUnsigned ifTrue: [16r00 to: 16rFF] ifFalse: [-16r80 to: 16r7F].

]
