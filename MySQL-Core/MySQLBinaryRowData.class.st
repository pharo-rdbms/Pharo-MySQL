Class {
	#name : #MySQLBinaryRowData,
	#superclass : #MySQLRowData,
	#instVars : [
		'header',
		'nullBitMap',
		'columnDescriptors',
		'columnValues'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLBinaryRowData >> atIndex: indx [
	^ columnValues at: indx ifAbsent: [MySQLInvalidRowAccess signal: 'No data at this index']
	
]

{ #category : #'as yet unclassified' }
MySQLBinaryRowData >> columnDescriptors: fieldList [
	columnDescriptors := fieldList 
	
]

{ #category : #'as yet unclassified' }
MySQLBinaryRowData >> isColumnNullAt: index [
	| byteIndex bitsToShift bitMask |
	byteIndex := index + 9 // 8.
	bitsToShift := index + 9 \\ 8.
	bitMask := 1 << bitsToShift.
	
	^ ((nullBitMap at: byteIndex) bitAnd: bitMask) ~= 0
	
	
]

{ #category : #'as yet unclassified' }
MySQLBinaryRowData >> nullBitMap: byteArray [ "primarily for testing"
	nullBitMap := byteArray 
	
]

{ #category : #'as yet unclassified' }
MySQLBinaryRowData >> parse [
	| col |
	header := inStream next.	"always 0"
	nullBitMap := inStream next: (columnDescriptors size + 9) // 8.
	columnValues := Array new: columnDescriptors size.
	columnDescriptors doWithIndex: 
		[ :colDescr :indx | 
		col := (self isColumnNullAt: indx) 
			ifTrue: [ nil ]
			ifFalse: 
				[ self 
					readColumnFrom: inStream
					perDescrption: colDescr ].	"null"	"non-null; read from stream per col description"
		columnValues 
			at: indx
			put: col ]
]

{ #category : #'as yet unclassified' }
MySQLBinaryRowData >> readColumnFrom: aStream perDescrption: columnDescr [
	| reader value mask |

	reader := MySQLBinaryReader default.
	value := columnDescr type 
		caseOf: {
		[MySQLTypes typeTINY]->[mask := 16r80. reader tinyIntFrom: aStream].
		[MySQLTypes typeSHORT]->[mask := 16r8000. reader smallIntFrom: aStream].
		[MySQLTypes typeINT24]->[mask := 16r80000000. reader mediumIntFrom: aStream].	
		[MySQLTypes typeLONG]->[mask := 16r80000000. reader longIntFrom: aStream].	
		[MySQLTypes typeLONGLONG]->[
			mask := 16r8000000000000000. 
			reader bigIntFrom: aStream].

		[MySQLTypes typeFLOAT]->[reader floatFrom: aStream].
		[MySQLTypes typeDOUBLE]->[reader doubleFrom: aStream].
		[MySQLTypes typeDECIMAL]->[reader decimalWithScale: columnDescr decimals from: aStream].
		[MySQLTypes typeNEWDECIMAL]->[reader decimalWithScale: columnDescr decimals from: aStream].
	
		[MySQLTypes typeSTRING]->[reader varStringFrom: aStream].
		[MySQLTypes typeVARCHAR]->[reader varStringFrom: aStream].
		[MySQLTypes typeVARSTRING]->[reader varStringFrom: aStream].
	
		[MySQLTypes typeTIME]->[reader timeFrom: aStream].
		[MySQLTypes typeDATE]->[reader dateFrom: aStream].
		[MySQLTypes typeDATETIME]->[reader dateTimeFrom: aStream].
		[MySQLTypes typeTIMESTAMP]->[reader timeStampFrom: aStream].
		[MySQLTypes typeYEAR]->[reader yearFrom: aStream].
		[MySQLTypes typeNEWDATE]->[reader shouldBeImplemented].
	
		[MySQLTypes typeTINYBLOB]->[reader varBlobFrom: aStream].
		[MySQLTypes typeBLOB]->[reader varBlobFrom: aStream].
		[MySQLTypes typeMEDIUMBLOB]->[reader varBlobFrom: aStream].
		[MySQLTypes typeLONGBLOB]->[reader varBlobFrom: aStream].
		
		[MySQLTypes typeNULL]->[self shouldBeImplemented].
	
		[MySQLTypes typeGEOMETRY]->[self shouldBeImplemented].
		[MySQLTypes typeSET]->[self shouldBeImplemented].
		[MySQLTypes typeENUM]->[self shouldBeImplemented].
		[MySQLTypes typeBIT]->[self shouldBeImplemented].
		} 
		otherwise: [^ self error: 'Unknown mysql type'].
		
	(value isInteger and: [columnDescr isUnsigned not and: [(value bitAnd: mask) ~= 0]]) 
	  ifTrue: [
		value  := value - (mask << 1) "if msb is set and field is signed, then negative"].
	^ value
	
]
