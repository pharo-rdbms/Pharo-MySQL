"
MySQL database types
"
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

{ #category : #'accessing - types - all' }
MySQLTypes class >> blobTypes [
	blobTypes ifNil: [
		blobTypes := Array 
			with: TypeTINYBLOB with: TypeMEDIUMBLOB with: TypeBLOB with: TypeLONGBLOB ].
	^ blobTypes
	
]

{ #category : #'accessing - types - all' }
MySQLTypes class >> dateTimeTypes [
	dateTimeTypes ifNil: [
		dateTimeTypes := Array 
			with: TypeDATE with: TypeDATETIME with: TypeNEWDATE with: TypeTIME
			with: TypeTIMESTAMP with: TypeYEAR
		].
	^ dateTimeTypes
	
]

{ #category : #'private - initialization' }
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

{ #category : #'class initialization' }
MySQLTypes class >> initialize [
	self initFieldTypes

]

{ #category : #'accessing - types - all' }
MySQLTypes class >> integerTypes [
	integerTypes ifNil: [
		integerTypes := Array 
			with: TypeTINY with: TypeSHORT with: TypeINT24 with: TypeLONG 
			with: TypeLONGLONG].
	^ integerTypes
	
]

{ #category : #testing }
MySQLTypes class >> isBigInt: type [
	^ type = TypeLONGLONG
	
]

{ #category : #testing }
MySQLTypes class >> isLongInt: type [
	^ type = TypeLONG
	
]

{ #category : #testing }
MySQLTypes class >> isMediumInt: type [
	^ type = TypeINT24
	
]

{ #category : #testing }
MySQLTypes class >> isSmallInt: type [
	^ type = TypeSHORT
	
]

{ #category : #testing }
MySQLTypes class >> isTinyInt: type [
	^ type = TypeTINY
	
]

{ #category : #'accessing - types - all' }
MySQLTypes class >> realTypes [
	realTypes ifNil: [
		realTypes := Array 
			with: TypeFLOAT with: TypeDOUBLE with: TypeDECIMAL with: TypeNEWDECIMAL].
	^ realTypes
	
]

{ #category : #'accessing - types - all' }
MySQLTypes class >> stringTypes [
	stringTypes ifNil: [
		stringTypes := Array with: TypeSTRING with: TypeVARCHAR with: TypeVARSTRING ].
	^ stringTypes
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeBIT [
	^ TypeBIT
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeBLOB [
	^ TypeBLOB
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeDATE [
	^ TypeDATE
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeDATETIME [
	^ TypeDATETIME
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeDECIMAL [
	^ TypeDECIMAL
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeDOUBLE [
	^ TypeDOUBLE
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeENUM [
	^ TypeENUM
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeFLOAT [
	^ TypeFLOAT
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeGEOMETRY [
	^ TypeGEOMETRY
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeINT24 [
	^ TypeINT24
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeLONG [
	^ TypeLONG
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeLONGBLOB [
	^ TypeLONGBLOB
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeLONGLONG [
	^ TypeLONGLONG
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeMEDIUMBLOB [
	^ TypeMEDIUMBLOB
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeNEWDATE [
	^ TypeNEWDATE
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeNEWDECIMAL [
	^ TypeNEWDECIMAL
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeNULL [
	^ TypeNULL
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeSET [
	^ TypeSET
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeSHORT [
	^ TypeSHORT
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeSTRING [
	^ TypeSTRING
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeTIME [
	^ TypeTIME
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeTIMESTAMP [
	^ TypeTIMESTAMP
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeTINY [
	^ TypeTINY
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeTINYBLOB [
	^ TypeTINYBLOB
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeVARCHAR [
	^ TypeVARCHAR
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeVARSTRING [
	^ TypeVARSTRING
	
]

{ #category : #'accessing - types' }
MySQLTypes class >> typeYEAR [
	^ TypeYEAR
	
]
