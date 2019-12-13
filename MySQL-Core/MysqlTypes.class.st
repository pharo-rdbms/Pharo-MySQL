Class {
	#name : #MySQLTypes,
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
	#category : #'MySQL-Core-Utilities'
}

{ #category : #'as yet unclassified' }
MySQLTypes class >> blobTypes [
	blobTypes ifNil: [
		blobTypes := Array 
			with: TypeTINYBLOB with: TypeMEDIUMBLOB with: TypeBLOB with: TypeLONGBLOB ].
	^ blobTypes
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> dateTimeTypes [
	dateTimeTypes ifNil: [
		dateTimeTypes := Array 
			with: TypeDATE with: TypeDATETIME with: TypeNEWDATE with: TypeTIME
			with: TypeTIMESTAMP with: TypeYEAR
		].
	^ dateTimeTypes
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> initFieldTypes [
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
MySQLTypes class >> initialize [
	"self initialize"

	self initFieldTypes.

]

{ #category : #'as yet unclassified' }
MySQLTypes class >> integerTypes [
	integerTypes ifNil: [
		integerTypes := Array 
			with: TypeTINY with: TypeSHORT with: TypeINT24 with: TypeLONG 
			with: TypeLONGLONG].
	^ integerTypes
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> isBigInt: type [
	^ type = TypeLONGLONG
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> isLongInt: type [
	^ type = TypeLONG
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> isMediumInt: type [
	^ type = TypeINT24
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> isSmallInt: type [
	^ type = TypeSHORT
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> isTinyInt: type [
	^ type = TypeTINY
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> realTypes [
	realTypes ifNil: [
		realTypes := Array 
			with: TypeFLOAT with: TypeDOUBLE with: TypeDECIMAL with: TypeNEWDECIMAL].
	^ realTypes
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> stringTypes [
	stringTypes ifNil: [
		stringTypes := Array with: TypeSTRING with: TypeVARCHAR with: TypeVARSTRING ].
	^ stringTypes
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeBIT [
	^ TypeBIT
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeBLOB [
	^ TypeBLOB
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeDATE [
	^ TypeDATE
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeDATETIME [
	^ TypeDATETIME
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeDECIMAL [
	^ TypeDECIMAL
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeDOUBLE [
	^ TypeDOUBLE
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeENUM [
	^ TypeENUM
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeFLOAT [
	^ TypeFLOAT
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeGEOMETRY [
	^ TypeGEOMETRY
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeINT24 [
	^ TypeINT24
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeLONG [
	^ TypeLONG
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeLONGBLOB [
	^ TypeLONGBLOB
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeLONGLONG [
	^ TypeLONGLONG
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeMEDIUMBLOB [
	^ TypeMEDIUMBLOB
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeNEWDATE [
	^ TypeNEWDATE
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeNEWDECIMAL [
	^ TypeNEWDECIMAL
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeNULL [
	^ TypeNULL
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeSET [
	^ TypeSET
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeSHORT [
	^ TypeSHORT
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeSTRING [
	^ TypeSTRING
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeTIME [
	^ TypeTIME
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeTIMESTAMP [
	^ TypeTIMESTAMP
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeTINY [
	^ TypeTINY
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeTINYBLOB [
	^ TypeTINYBLOB
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeVARCHAR [
	^ TypeVARCHAR
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeVARSTRING [
	^ TypeVARSTRING
	
]

{ #category : #'as yet unclassified' }
MySQLTypes class >> typeYEAR [
	^ TypeYEAR
	
]
