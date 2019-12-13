Class {
	#name : #MysqlBinRowData,
	#superclass : #MysqlRowData,
	#instVars : [
		'header',
		'nullBitMap',
		'columnDescriptors',
		'columnValues'
	],
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MysqlBinRowData >> atIndex: indx [
	^ columnValues at: indx ifAbsent: [MysqlInvalidRowAccess signal: 'No data at this index']
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowData >> columnDescriptors: fieldList [
	columnDescriptors := fieldList 
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowData >> isColumnNullAt: index [
	| byteIndex bitsToShift bitMask |
	byteIndex := index + 9 // 8.
	bitsToShift := index + 9 \\ 8.
	bitMask := 1 << bitsToShift.
	
	^ ((nullBitMap at: byteIndex) bitAnd: bitMask) ~= 0
	
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowData >> nullBitMap: byteArray [ "primarily for testing"
	nullBitMap := byteArray 
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowData >> parse [
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
MysqlBinRowData >> readColumnFrom: aStream perDescrption: columnDescr [
	| reader value mask |

	reader := MysqlBinReader default.
	value := columnDescr type 
		caseOf: {
		[MysqlTypes typeTINY]->[mask := 16r80. reader tinyIntFrom: aStream].
		[MysqlTypes typeSHORT]->[mask := 16r8000. reader smallIntFrom: aStream].
		[MysqlTypes typeINT24]->[mask := 16r80000000. reader mediumIntFrom: aStream].	
		[MysqlTypes typeLONG]->[mask := 16r80000000. reader longIntFrom: aStream].	
		[MysqlTypes typeLONGLONG]->[
			mask := 16r8000000000000000. 
			reader bigIntFrom: aStream].

		[MysqlTypes typeFLOAT]->[reader floatFrom: aStream].
		[MysqlTypes typeDOUBLE]->[reader doubleFrom: aStream].
		[MysqlTypes typeDECIMAL]->[reader decimalWithScale: columnDescr decimals from: aStream].
		[MysqlTypes typeNEWDECIMAL]->[reader decimalWithScale: columnDescr decimals from: aStream].
	
		[MysqlTypes typeSTRING]->[reader varStringFrom: aStream].
		[MysqlTypes typeVARCHAR]->[reader varStringFrom: aStream].
		[MysqlTypes typeVARSTRING]->[reader varStringFrom: aStream].
	
		[MysqlTypes typeTIME]->[reader timeFrom: aStream].
		[MysqlTypes typeDATE]->[reader dateFrom: aStream].
		[MysqlTypes typeDATETIME]->[reader dateTimeFrom: aStream].
		[MysqlTypes typeTIMESTAMP]->[reader timeStampFrom: aStream].
		[MysqlTypes typeYEAR]->[reader yearFrom: aStream].
		[MysqlTypes typeNEWDATE]->[reader shouldBeImplemented].
	
		[MysqlTypes typeTINYBLOB]->[reader varBlobFrom: aStream].
		[MysqlTypes typeBLOB]->[reader varBlobFrom: aStream].
		[MysqlTypes typeMEDIUMBLOB]->[reader varBlobFrom: aStream].
		[MysqlTypes typeLONGBLOB]->[reader varBlobFrom: aStream].
		
		[MysqlTypes typeNULL]->[self shouldBeImplemented].
	
		[MysqlTypes typeGEOMETRY]->[self shouldBeImplemented].
		[MysqlTypes typeSET]->[self shouldBeImplemented].
		[MysqlTypes typeENUM]->[self shouldBeImplemented].
		[MysqlTypes typeBIT]->[self shouldBeImplemented].
		} 
		otherwise: [^ self error: 'Unknown mysql type'].
		
	(value isInteger and: [columnDescr isUnsigned not and: [(value bitAnd: mask) ~= 0]]) 
	  ifTrue: [
		value  := value - (mask << 1) "if msb is set and field is signed, then negative"].
	^ value
	
]
