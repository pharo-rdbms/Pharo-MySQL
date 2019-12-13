Class {
	#name : #MysqlBinRowDataNullBitMapTest,
	#superclass : #TestCase,
	#instVars : [
		'row'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #'as yet unclassified' }
MysqlBinRowDataNullBitMapTest >> setUp [
	row := MysqlBinRowData new.
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowDataNullBitMapTest >> testByteBoundaries [
	row nullBitMap: #(16r84 16r81 16r81 16r81).
	self assert: (row isColumnNullAt: 1) description: 'Column 1 should be null'.
	self assert: (row isColumnNullAt: 6) description: 'Column 6 should be null'.
	self assert: (row isColumnNullAt: 7) description: 'Column 7 should be null'.
	self assert: (row isColumnNullAt: 14) description: 'Column 14 should be null'.
	self assert: (row isColumnNullAt: 15) description: 'Column 15 should be null'.
	self assert: (row isColumnNullAt: 22) description: 'Column 22 should be null'.
	self assert: (row isColumnNullAt: 23) description: 'Column 23 should be null'.
	self assert: (row isColumnNullAt: 30) description: 'Column 30 should be null'.
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowDataNullBitMapTest >> testByteNonBoundaries [
	row nullBitMap: #(16r78 16r7E 16r7E 16r7E).
	self deny: (row isColumnNullAt: 1) description: 'Column 1 should not be null'.
	self assert: (row isColumnNullAt: 2) description: 'Column 2 should be null'.
	self assert: (row isColumnNullAt: 3) description: 'Column 3 should be null'.
	self assert: (row isColumnNullAt: 4) description: 'Column 4 should be null'.
	self assert: (row isColumnNullAt: 5) description: 'Column 5 should be null'.
	self deny: (row isColumnNullAt: 6) description: 'Column 6 should not be null'.
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowDataNullBitMapTest >> testByteNonBoundariesAtEnd [
	row nullBitMap: #(16r78 16r7E 16r7E 16r7E).
	self deny: (row isColumnNullAt: 23) description: 'Column 23 should not be null'.
	self assert: (row isColumnNullAt: 24) description: 'Column 24 should be null'.
	self assert: (row isColumnNullAt: 25) description: 'Column 25 should be null'.
	self assert: (row isColumnNullAt: 26) description: 'Column 26 should be null'.
	self assert: (row isColumnNullAt: 27) description: 'Column 27 should be null'.
	self assert: (row isColumnNullAt: 28) description: 'Column 28 should be null'.
	self assert: (row isColumnNullAt: 29) description: 'Column 29 should be null'.
	self deny: (row isColumnNullAt: 30) description: 'Column 30 should not be null'.
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowDataNullBitMapTest >> testByteNonBoundariesInTheMiddle [
	row nullBitMap: #(16r78 16r7E 16r7E 16r7E).
	self deny: (row isColumnNullAt: 7) description: 'Column 7 should not be null'.
	self assert: (row isColumnNullAt: 8) description: 'Column 8 should be null'.
	self assert: (row isColumnNullAt: 9) description: 'Column 9 should be null'.
	self assert: (row isColumnNullAt: 10) description: 'Column 10 should be null'.
	self assert: (row isColumnNullAt: 11) description: 'Column 11 should be null'.
	self assert: (row isColumnNullAt: 12) description: 'Column 12 should be null'.
	self assert: (row isColumnNullAt: 13) description: 'Column 13 should be null'.
	self deny: (row isColumnNullAt: 14) description: 'Column 14 should not be null'.
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowDataNullBitMapTest >> testFirstAndLastIndex [
	row nullBitMap: #(16r04 16r00 16r00 16r00).
	self assert: (row isColumnNullAt: 1) description: 'Column 1 should be null'.
	self deny: (row isColumnNullAt: 30) description: 'Column 30 should not be null'.
	
]

{ #category : #'as yet unclassified' }
MysqlBinRowDataNullBitMapTest >> testFirstAndLastIndexReverted [
	row nullBitMap: #(16r00 16r00 16r00 16r80).
	self deny: (row isColumnNullAt: 1) description: 'Column 1 should be null'.
	self assert: (row isColumnNullAt: 30) description: 'Column 30 should not be null'.
	
]
