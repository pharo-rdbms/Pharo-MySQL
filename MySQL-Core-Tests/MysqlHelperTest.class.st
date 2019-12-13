Class {
	#name : #MySQLHelperTest,
	#superclass : #TestCase,
	#instVars : [
		'pwd'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #'as yet unclassified' }
MySQLHelperTest >> isLogging [
	^true "Allow faillure log to transcript"
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> setUp [
	pwd := MySQLHelper new
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> testBytesFromHexString [
	| bytes |
	bytes := MySQLHelper bytesFromHexString: '00112233445566778899AABBCCDDEEFF'.
	self assert: (bytes first) = 0.
	self assert: (bytes at: 8) = 119.
	self assert: (bytes at: 16) = 255.
	
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> testHash [
	self 
		assert: #(1345345333 305419889 ) = (MySQLHelper hash: '')
		description: 'Hash on empty string'.
	self 
		assert: #(1563302201 1019604839 ) = (MySQLHelper hash: 'password')
		description: 'Hash on string ''password'''.
	self 
		assert: #(1274050763 633181955 ) = (MySQLHelper hash: 'Smalltalk')
		description: 'Hash on ''Smalltalk'''.
	self 
		should: [ MySQLHelper hash: nil ]
		raise: Exception
		description: 'Hash on nil should throw exception'
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> testHexStringFromBytes [
	| bytes str |
	bytes := ByteArray new: 16.
	bytes 
		at: 1 put: 16r00;	at: 2 put: 16r11; at: 3 put: 16r22; at: 4 put: 16r33;
		at: 5 put: 16r44;	at: 6 put: 16r55; at: 7 put: 16r66; at: 8 put: 16r77;
		at: 9 put: 16r88;	at: 10 put: 16r99; at: 11 put: 16rAA; at: 12 put: 16rBB;
		at: 13 put: 16rCC; at: 14 put: 16rDD; at: 15 put: 16rEE; at: 16 put: 16rFF.
	
	str := MySQLHelper hexStringFromBytes: bytes.
	self assert: str = '00112233445566778899AABBCCDDEEFF'
	
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> testMyRandom [
	MySQLHelper randomInitWith: 3252345 and: 7149734.
	self assert: (MySQLHelper myRandom closeTo: 0.0157456556481734).
	self assert: (MySQLHelper myRandom closeTo: 0.0696413620092360).
	self assert: (MySQLHelper myRandom closeTo: 0.3009698738353047).
	self assert: (MySQLHelper myRandom closeTo: 0.2959253138824602).
	self assert: (MySQLHelper myRandom closeTo: 0.5767169786400320).
	self assert: (MySQLHelper myRandom closeTo: 0.9958089822864243).
	self assert: (MySQLHelper myRandom closeTo: 0.2488940062456708).
	self assert: (MySQLHelper myRandom closeTo: 0.2570431151027261).
	self assert: (MySQLHelper myRandom closeTo: 0.5385335875102631).
	self assert: (MySQLHelper myRandom closeTo: 0.9215386229767824)
	
	
	
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> testScramble323LongSeedEmptyPassword [
	self assert: '' = 
		(MySQLHelper hexStringFromBytes: ( 
			MySQLHelper scramble323: 'e8cf00cec9ec825af22' with: '')).
			
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> testScramble323LongSeedLongPassword [
	self assert: '4d545b475f524d45' asUppercase = 
		(MySQLHelper hexStringFromBytes: ( 
			MySQLHelper scramble323: 'e8cf00cec9ec825af22' with: 'saf789yasfbsd')).
			
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> testScramble323LongSeedShortPassword [
	self assert: '5a4d46474353585f' asUppercase = 
		(MySQLHelper hexStringFromBytes: ( 
			MySQLHelper scramble323: '8bytesofstuff' with: 'root' )).
			
]

{ #category : #'as yet unclassified' }
MySQLHelperTest >> testScramble323SeedLongPassword [
	self assert: '5554585a434c5459' asUppercase = 
		(MySQLHelper hexStringFromBytes: ( 
			MySQLHelper scramble323: 'somedata' with: 'stdbtestpass' )).
			
]
