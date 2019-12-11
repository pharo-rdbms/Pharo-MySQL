Class {
	#name : #MysqlTypes,
	#superclass : #Object,
	#classVars : [
		'TypeBIT',
		'TypeBLOB',
		'TypeDATE',
		'TypeDATETIME',
		'TypeDECIMAL',
		'TypeDOUBLE',
		'TypeENUM',
		'TypeFLOAT',
		'TypeGEOMETRY',
		'TypeINT24',
		'TypeLONG',
		'TypeLONGBLOB',
		'TypeLONGLONG',
		'TypeMEDIUMBLOB',
		'TypeNEWDATE',
		'TypeNEWDECIMAL',
		'TypeNULL',
		'TypeSET',
		'TypeSHORT',
		'TypeSTRING',
		'TypeTIME',
		'TypeTIMESTAMP',
		'TypeTINY',
		'TypeTINYBLOB',
		'TypeVARCHAR',
		'TypeVARSTRING',
		'TypeYEAR'
	],
	#classInstVars : [
		'blobTypes',
		'dateTimeTypes',
		'integerTypes',
		'stringTypes',
		'realTypes'
	],
	#category : #'MysqlDriver-Helper'
}

{ #category : #'as yet unclassified' }
MysqlTypes class >> blobTypes [
	blobTypes ifNil: [
		blobTypes := Array 
			with: TypeTINYBLOB with: TypeMEDIUMBLOB with: TypeBLOB with: TypeLONGBLOB ].
	^ blobTypes
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> dateTimeTypes [
	dateTimeTypes ifNil: [
		dateTimeTypes := Array 
			with: TypeDATE with: TypeDATETIME with: TypeNEWDATE with: TypeTIME
			with: TypeTIMESTAMP with: TypeYEAR
		].
	^ dateTimeTypes
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> initFieldTypes [
 	TypeBIT := 16.
 	TypeBLOB := 252.
 	TypeDATE := 10.
 	TypeDATETIME := 12.
 	TypeDECIMAL := 0.
 	TypeDOUBLE := 5.
 	TypeENUM := 247.
 	TypeFLOAT := 4.
 	TypeGEOMETRY := 255.
 	TypeINT24 := 9.
 	TypeLONG := 3.
 	TypeLONGLONG := 8.
 	TypeLONGBLOB := 251.
 	TypeMEDIUMBLOB := 250.
 	TypeNEWDATE := 14.
 	TypeNEWDECIMAL := 246.
 	TypeNULL := 6.
 	TypeSET := 248.
 	TypeSHORT := 2.
 	TypeSTRING := 254.
 	TypeTIME := 11.
 	TypeTIMESTAMP := 7.
 	TypeTINY := 1.
 	TypeTINYBLOB := 249.
 	TypeVARCHAR := 15.
 	TypeVARSTRING := 253.
 	TypeYEAR := 13.

]

{ #category : #'as yet unclassified' }
MysqlTypes class >> initialize [
	"self initialize"

	self initFieldTypes.

]

{ #category : #'as yet unclassified' }
MysqlTypes class >> integerTypes [
	integerTypes ifNil: [
		integerTypes := Array 
			with: TypeTINY with: TypeSHORT with: TypeINT24 with: TypeLONG 
			with: TypeLONGLONG].
	^ integerTypes
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> isBigInt: type [
	^ type = TypeLONGLONG
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> isLongInt: type [
	^ type = TypeLONG
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> isMediumInt: type [
	^ type = TypeINT24
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> isSmallInt: type [
	^ type = TypeSHORT
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> isTinyInt: type [
	^ type = TypeTINY
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> realTypes [
	realTypes ifNil: [
		realTypes := Array 
			with: TypeFLOAT with: TypeDOUBLE with: TypeDECIMAL with: TypeNEWDECIMAL].
	^ realTypes
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> stringTypes [
	stringTypes ifNil: [
		stringTypes := Array with: TypeSTRING with: TypeVARCHAR with: TypeVARSTRING ].
	^ stringTypes
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeBIT [
	^ TypeBIT
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeBLOB [
	^ TypeBLOB
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeDATE [
	^ TypeDATE
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeDATETIME [
	^ TypeDATETIME
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeDECIMAL [
	^ TypeDECIMAL
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeDOUBLE [
	^ TypeDOUBLE
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeENUM [
	^ TypeENUM
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeFLOAT [
	^ TypeFLOAT
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeGEOMETRY [
	^ TypeGEOMETRY
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeINT24 [
	^ TypeINT24
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeLONG [
	^ TypeLONG
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeLONGBLOB [
	^ TypeLONGBLOB
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeLONGLONG [
	^ TypeLONGLONG
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeMEDIUMBLOB [
	^ TypeMEDIUMBLOB
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeNEWDATE [
	^ TypeNEWDATE
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeNEWDECIMAL [
	^ TypeNEWDECIMAL
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeNULL [
	^ TypeNULL
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeSET [
	^ TypeSET
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeSHORT [
	^ TypeSHORT
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeSTRING [
	^ TypeSTRING
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeTIME [
	^ TypeTIME
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeTIMESTAMP [
	^ TypeTIMESTAMP
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeTINY [
	^ TypeTINY
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeTINYBLOB [
	^ TypeTINYBLOB
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeVARCHAR [
	^ TypeVARCHAR
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeVARSTRING [
	^ TypeVARSTRING
	
]

{ #category : #'as yet unclassified' }
MysqlTypes class >> typeYEAR [
	^ TypeYEAR
	
]
