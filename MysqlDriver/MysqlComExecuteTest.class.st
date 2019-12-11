Class {
	#name : #MysqlComExecuteTest,
	#superclass : #TestCase,
	#category : #'MysqlDriver-Test-Unit'
}

{ #category : #'as yet unclassified' }
MysqlComExecuteTest >> testNullBitMap [
	| params cmd |

	params := (1 to: 30) collect: [:each | MysqlBindParam new bindValue: nil].
	
	cmd := MysqlComExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16rFF with: 16rFF with: 16rFF with: 16r3F) = cmd nullBitMap.

]

{ #category : #'as yet unclassified' }
MysqlComExecuteTest >> testNullBitMapAllButFirstAndLastNull [
	| params cmd |

	params := Array new: 32.
	params at: 1 put: (MysqlBindParam new bindValue: 'foo').
	2 to: 31 do: [:indx | 
		params at: indx put: (MysqlBindParam new bindValue: nil)].
	params at: 32 put: (MysqlBindParam new bindValue: 'bar').
	
	cmd := MysqlComExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16rFE with: 16rFF with: 16rFF with: 16r7F) = cmd nullBitMap.

]

{ #category : #'as yet unclassified' }
MysqlComExecuteTest >> testNullBitMapAllNull [
	| params cmd |

	params := (1 to: 32) collect: [:each | MysqlBindParam new bindValue: nil].

	cmd := MysqlComExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16rFF with: 16rFF with: 16rFF with: 16rFF) = cmd nullBitMap.

]

{ #category : #'as yet unclassified' }
MysqlComExecuteTest >> testNullBitMapMajorityNull [
	| params cmd |

	params := (1 to: 32) collect: [:each | MysqlBindParam new bindValue: nil].
	params at: 8 put: (MysqlBindParam new bindValue: #foo).
	params at: 16 put: (MysqlBindParam new bindValue: #foo).
	params at: 24 put: (MysqlBindParam new bindValue: #foo).
	params at: 32 put: (MysqlBindParam new bindValue: #foo).
	
	cmd := MysqlComExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16r7Fwith: 16r7F with: 16r7F with: 16r7F) = cmd nullBitMap.

]

{ #category : #'as yet unclassified' }
MysqlComExecuteTest >> testNullBitMapSomeNull [
	| params cmd |

	params := (1 to: 32) collect: [:each | MysqlBindParam new bindValue: #foo].
	params at: 8 put: (MysqlBindParam new bindValue: nil).
	params at: 16 put: (MysqlBindParam new bindValue: nil).
	params at: 24 put: (MysqlBindParam new bindValue: nil).
	params at: 32 put: (MysqlBindParam new bindValue: nil).
	
	cmd := MysqlComExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16r80 with: 16r80 with: 16r80 with: 16r80) = cmd nullBitMap.

]
