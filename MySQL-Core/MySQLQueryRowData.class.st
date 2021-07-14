"
Query row data packet for MySQL
"
Class {
	#name : #MySQLQueryRowData,
	#superclass : #MySQLRowData,
	#instVars : [
		'columns',
		'fields'
	],
	#category : #'MySQL-Core-Packet-RowData'
}

{ #category : #accessing }
MySQLQueryRowData >> asDictionary [
	| pairs |
	pairs := OrderedCollection new: fields size.
	fields doWithIndex: [ :f :i | pairs add: (f name -> (self atIndex: i)) ].
	^pairs asDictionary
]

{ #category : #accessing }
MySQLQueryRowData >> at: indx [
	^ indx isInteger 
		ifTrue: [self atIndex: indx]
		ifFalse: [ self atFieldNamed: indx ]
]

{ #category : #accessing }
MySQLQueryRowData >> atFieldNamed: aName [
	^ self atIndex: (self indexOfFieldNamed: aName)

]

{ #category : #accessing }
MySQLQueryRowData >> atIndex: indx [
	^ columns at: indx ifAbsent: [MySQLInvalidRowAccess signal: 'No data at this index']
]

{ #category : #accessing }
MySQLQueryRowData >> columnCount: aCount [
	columns := Array new: aCount 
	
]

{ #category : #enumerating }
MySQLQueryRowData >> do: aBlock [ 
	^columns do: aBlock
]

{ #category : #accessing }
MySQLQueryRowData >> fields [
	^ fields
]

{ #category : #accessing }
MySQLQueryRowData >> fields: anObject [
	fields := anObject
]

{ #category : #accessing }
MySQLQueryRowData >> indexOfFieldNamed: aName [
	self fields doWithIndex: [ :f :idx | f name = aName ifTrue: [ ^idx ] ].
	^0
]

{ #category : #accessing }
MySQLQueryRowData >> last [
	^ columns atIndex: (columns size) 
]

{ #category : #parsing }
MySQLQueryRowData >> parse [
	| indx value field |

	indx := 1.
	[inStream atEnd] whileFalse: [
		field := fields at: indx.
		value := (self readColumnFrom: inStream perDescrption: field).
		columns at: indx put: value.
		indx := indx + 1].
	
]

{ #category : #parsing }
MySQLQueryRowData >> readColumnFrom: aStream perDescrption: columnDescr [
	| string |
	string := (self decodeLcsFrom: aStream) ifNotNil: [:s | s asString] ifNil: [^nil].
	^columnDescr type 
		caseOf: {
		[MySQLTypes typeTINY]->[string asInteger].
		[MySQLTypes typeSHORT]->[string asInteger].
		[MySQLTypes typeINT24]->[string asInteger].	
		[MySQLTypes typeLONG]->[string asInteger].	
		[MySQLTypes typeLONGLONG]->[string asInteger].

		[MySQLTypes typeFLOAT]->[string asNumber].
		[MySQLTypes typeDOUBLE]->[string asNumber].
		[MySQLTypes typeDECIMAL]->[ScaledDecimal readFrom: string].
		[MySQLTypes typeNEWDECIMAL]->[ScaledDecimal readFrom: string].
	
		[MySQLTypes typeSTRING]->[string].
		[MySQLTypes typeVARCHAR]->[string].
		[MySQLTypes typeVARSTRING]->[string].
	
		[MySQLTypes typeTIME]->[Time fromString: string].
		[MySQLTypes typeDATE]->[Date fromString: string].
		[MySQLTypes typeDATETIME]->[DateAndTime fromString: string].
		[MySQLTypes typeTIMESTAMP]->[DateAndTime fromString: string].
		[MySQLTypes typeYEAR]->[string asInteger].
		[MySQLTypes typeNEWDATE]->[DateAndTime fromString: string].
	
		[MySQLTypes typeTINYBLOB]->[string].
		[MySQLTypes typeBLOB]->[string].
		[MySQLTypes typeMEDIUMBLOB]->[string].
		[MySQLTypes typeLONGBLOB]->[string].
	
		[MySQLTypes typeJSON]->[NeoJSONReader fromString: string].
		
		[MySQLTypes typeNULL]->[self shouldBeImplemented].
	
		[MySQLTypes typeGEOMETRY]->[self shouldBeImplemented].
		[MySQLTypes typeSET]->[self shouldBeImplemented].
		[MySQLTypes typeENUM]->[self shouldBeImplemented].
		[MySQLTypes typeBIT]->[string asInteger].
		} 
		otherwise: [^ self error: 'Unknown mysql type'].
		
	
	
]
