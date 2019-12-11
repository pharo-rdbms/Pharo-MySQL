Class {
	#name : #MysqlBindParam,
	#superclass : #Object,
	#instVars : [
		'paramValue',
		'paramType',
		'newParamBound',
		'unsignedFlag',
		'declaredUnsigned',
		'sentAsLongData'
	],
	#category : #'MysqlDriver-Helper'
}

{ #category : #'as yet unclassified' }
MysqlBindParam class >> listOfSize: count forDescriptors: fields [
	| params |
	params := (1 to: count) collect: [:each |  
			(self new 
				declaredUnsigned: (fields at: each) isUnsigned; 
				yourself)].
	^ params
	
]

{ #category : #'as yet unclassified' }
MysqlBindParam class >> withValue: aValue [
	^ self new
		bindValue: aValue;
		yourself
	
]

{ #category : #private }
MysqlBindParam >> bigIntRange [
	^ self isDeclaredUnsigned 
		ifTrue: [16r0000000000000000 to: 16rFFFFFFFFFFFFFFFF] 
		ifFalse: [-16r8000000000000000 to: 16r7FFFFFFFFFFFFFFF].

]

{ #category : #accessing }
MysqlBindParam >> bindValue: aValue [ 
	| boundType |
	paramValue := aValue.
	(boundType := self detectParamType) ~= paramType 
		ifTrue: [
			paramType := boundType.
			newParamBound := true].
	unsignedFlag := self detectParamSign.
	
]

{ #category : #writes }
MysqlBindParam >> dateTimeBytes [
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

{ #category : #writes }
MysqlBindParam >> decimalBytes [
	"For scaled decimal"
	ByteArray streamContents: [:strm |
		strm nextPutAll: (paramValue abs printString allButLast:2) asByteArray.
		^ strm contents]
	
]

{ #category : #accessing }
MysqlBindParam >> declaredUnsigned: aBoolean [
	declaredUnsigned := aBoolean
	
]

{ #category : #accessing }
MysqlBindParam >> detectParamSign [
	"true is unsigned, false if signed"
	^ (((paramValue isKindOf: Number) or: [paramValue isKindOf: Duration]) and: [paramValue negative]) not
	
]

{ #category : #accessing }
MysqlBindParam >> detectParamType [
	"Corresponding database type needs to be inferred from the bound value"
	paramValue ifNil: [ ^ MysqlTypes typeNULL ].

	(paramValue isKindOf: Boolean) ifTrue: [ ^ MysqlTypes typeTINY ].

	(paramValue isKindOf: Integer) ifTrue: [
		(self tinyIntRange includes: paramValue) ifTrue: [^ MysqlTypes typeTINY].
		(self smallIntRange includes: paramValue) ifTrue: [^ MysqlTypes typeSHORT].
		(self longIntRange includes: paramValue) ifTrue: [^ MysqlTypes typeLONG].
		(self bigIntRange includes: paramValue) ifTrue: [^ MysqlTypes typeLONGLONG].
		^ MysqlBindError signal: 'Supplied integer does not have a matching database type'].

	(paramValue isKindOf: ScaledDecimal) ifTrue: [ ^ MysqlTypes typeDECIMAL ].
	((paramValue isKindOf: Float) or:  [paramValue isKindOf: Fraction]) 
		ifTrue: [	
			(paramValue asFloat at: 2) = 0 
				ifTrue: [^ MysqlTypes typeFLOAT]
				ifFalse: [^ MysqlTypes typeDOUBLE] ].

	(paramValue isKindOf: Character) ifTrue: [ ^ MysqlTypes typeSTRING ].
	((paramValue isKindOf: String) or: [paramValue isKindOf: Text]) 
		ifTrue: [ ^ MysqlTypes typeVARSTRING ].

	(paramValue isMemberOf: DateAndTime) ifTrue: [ ^ MysqlTypes typeDATETIME ].
	(paramValue isKindOf: DateAndTime) ifTrue: [ ^ MysqlTypes typeTIMESTAMP ].
	((paramValue isKindOf: Time) or: [paramValue isKindOf: Duration]) 
		ifTrue: [ ^ MysqlTypes typeTIME ].
	(paramValue isKindOf: Date) ifTrue: [ ^ MysqlTypes typeDATE ].

	(paramValue isKindOf: ByteArray) ifTrue: [ 
		paramValue size < 16r100 ifTrue: [ ^ MysqlTypes typeTINYBLOB ].
		paramValue size < 16r10000 ifTrue: [ ^ MysqlTypes typeBLOB ].
		paramValue size < 16r1000000 ifTrue: [ ^ MysqlTypes typeMEDIUMBLOB ].
		^ MysqlTypes typeLONGBLOB ].
	
	^ MysqlBindError signal: 'Unsupported data type for param binding'
	
]

{ #category : #writes }
MysqlBindParam >> doubleBytes [
	| storable |
	ByteArray
		streamContents: [ :strm | 
			storable := paramValue asFloat at: 1.
			strm
				nextPut: (storable byteAt: 1);
				nextPut: (storable byteAt: 2);
				nextPut: (storable byteAt: 3);
				nextPut: (storable byteAt: 4).
			storable := paramValue asFloat at: 2.
			strm
				nextPut: (storable byteAt: 1);
				nextPut: (storable byteAt: 2);
				nextPut: (storable byteAt: 3);
				nextPut: (storable byteAt: 4).
			^ strm contents ]
]

{ #category : #writes }
MysqlBindParam >> floatBytes [
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

{ #category : #'initialize-release' }
MysqlBindParam >> initialize [
	newParamBound := false.
	paramType := MysqlTypes typeNULL.
	unsignedFlag := declaredUnsigned := false.
	sentAsLongData := false
	
]

{ #category : #writes }
MysqlBindParam >> integerBytes: size [
	| storable |
	ByteArray
		streamContents: [ :strm | 
			storable := self storableIntegerValueOfSize: size.
			1 to: size do: [ :ii | strm nextPut: (storable byteAt: ii) ].
			^ strm contents ]
]

{ #category : #testing }
MysqlBindParam >> isDeclaredUnsigned [
	^ declaredUnsigned  
	
]

{ #category : #testing }
MysqlBindParam >> isLongData [
	| typeRange |
	"We also send varchar types as long data"
	self paramType = MysqlTypes typeVARCHAR ifTrue: [^ true].
	typeRange := (MysqlTypes typeTINYBLOB to: MysqlTypes typeSTRING).
	^ typeRange includes: self paramType 
	
]

{ #category : #testing }
MysqlBindParam >> isNull [
	^ paramType = MysqlTypes typeNULL
	
]

{ #category : #testing }
MysqlBindParam >> isRebound [
	^ newParamBound 
	
]

{ #category : #testing }
MysqlBindParam >> isUnsigned [
	^ unsignedFlag 
	
]

{ #category : #private }
MysqlBindParam >> longIntRange [
	^ self isDeclaredUnsigned 
		ifTrue: [16r00000000 to: 16rFFFFFFFF] 
		ifFalse: [-16r80000000 to: 16r7FFFFFFF].

]

{ #category : #accessing }
MysqlBindParam >> paramType [
	^ paramType 
	
]

{ #category : #accessing }
MysqlBindParam >> resetReboundFlag [
	newParamBound := false
	
]

{ #category : #testing }
MysqlBindParam >> sentAsLongData [
	^ sentAsLongData
	
]

{ #category : #accessing }
MysqlBindParam >> sentAsLongData: aBoolean [
	sentAsLongData := aBoolean
	
]

{ #category : #private }
MysqlBindParam >> smallIntRange [
	^ self isDeclaredUnsigned ifTrue: [16r0000 to: 16rFFFF] ifFalse: [-16r8000 to: 16r7FFF].

]

{ #category : #writes }
MysqlBindParam >> storableIntegerValueOfSize: size [ 
	(paramValue isKindOf: Boolean) ifTrue: [^ paramValue ifTrue: [1] ifFalse: [0]].
	^ paramValue negative 
		ifTrue: [ (1 << (size * 8)) + paramValue ]
		ifFalse: [ paramValue ]
]

{ #category : #accessing }
MysqlBindParam >> storeBinaryOn: aStream [		
	paramType 
	caseOf: {
		[MysqlTypes typeNULL]->[].
		[MysqlTypes typeTINY]->[aStream nextPutAll: (self integerBytes: 1)].
		[MysqlTypes typeSHORT]->[aStream nextPutAll: (self integerBytes: 2)].
		[MysqlTypes typeLONG]->[aStream nextPutAll: (self integerBytes: 4)].		
		[MysqlTypes typeLONGLONG]->[aStream nextPutAll: (self integerBytes: 8)].	
		[MysqlTypes typeFLOAT]->[aStream nextPutAll: (self floatBytes)].
		[MysqlTypes typeDOUBLE]->[aStream nextPutAll: (self doubleBytes)].
		[MysqlTypes typeTIME]->[aStream nextPutAll: self timeBytes].
		[MysqlTypes typeDATE]->[aStream nextPutAll: self dateTimeBytes].
		[MysqlTypes typeTIMESTAMP]->[aStream nextPutAll: self dateTimeBytes].
		[MysqlTypes typeDATETIME]->[aStream nextPutAll: self dateTimeBytes].	
		[MysqlTypes typeDECIMAL]->[aStream nextPutAll: self decimalBytes]	
	} 
	otherwise: [aStream nextPutAll: self stringOrBlobBytes]
	
]

{ #category : #writes }
MysqlBindParam >> stringOrBlobBytes [		
	ByteArray streamContents: [:strm |
		MysqlHelper encodeLcs: self stringOrBlobBytesRaw on: strm.
		^ strm contents]
	
]

{ #category : #writes }
MysqlBindParam >> stringOrBlobBytesRaw [
	| mappedValue |
	mappedValue := ((paramValue isKindOf: Character) or: [ paramValue isKindOf: Text ]) 
		ifTrue: [ paramValue asString ]
		ifFalse: [ paramValue ].
	^ mappedValue asByteArray
]

{ #category : #writes }
MysqlBindParam >> timeBytes [
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

{ #category : #private }
MysqlBindParam >> tinyIntRange [
	^ self isDeclaredUnsigned ifTrue: [16r00 to: 16rFF] ifFalse: [-16r80 to: 16r7F].

]
