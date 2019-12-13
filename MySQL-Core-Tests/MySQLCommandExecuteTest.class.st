Class {
	#name : #MySQLCommandExecuteTest,
	#superclass : #TestCase,
	#category : #'MySQL-Core-Tests-Command'
}

{ #category : #tests }
MySQLCommandExecuteTest >> testNullBitMap [
	| params cmd |

	params := (1 to: 30) collect: [:each | MySQLBindParameter new bindValue: nil].
	
	cmd := MySQLCommandExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16rFF with: 16rFF with: 16rFF with: 16r3F) = cmd nullBitMap.

]

{ #category : #tests }
MySQLCommandExecuteTest >> testNullBitMapAllButFirstAndLastNull [
	| params cmd |

	params := Array new: 32.
	params at: 1 put: (MySQLBindParameter new bindValue: 'foo').
	2 to: 31 do: [:indx | 
		params at: indx put: (MySQLBindParameter new bindValue: nil)].
	params at: 32 put: (MySQLBindParameter new bindValue: 'bar').
	
	cmd := MySQLCommandExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16rFE with: 16rFF with: 16rFF with: 16r7F) = cmd nullBitMap.

]

{ #category : #tests }
MySQLCommandExecuteTest >> testNullBitMapAllNull [
	| params cmd |

	params := (1 to: 32) collect: [:each | MySQLBindParameter new bindValue: nil].

	cmd := MySQLCommandExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16rFF with: 16rFF with: 16rFF with: 16rFF) = cmd nullBitMap.

]

{ #category : #tests }
MySQLCommandExecuteTest >> testNullBitMapMajorityNull [
	| params cmd |

	params := (1 to: 32) collect: [:each | MySQLBindParameter new bindValue: nil].
	params at: 8 put: (MySQLBindParameter new bindValue: #foo).
	params at: 16 put: (MySQLBindParameter new bindValue: #foo).
	params at: 24 put: (MySQLBindParameter new bindValue: #foo).
	params at: 32 put: (MySQLBindParameter new bindValue: #foo).
	
	cmd := MySQLCommandExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16r7Fwith: 16r7F with: 16r7F with: 16r7F) = cmd nullBitMap.

]

{ #category : #tests }
MySQLCommandExecuteTest >> testNullBitMapSomeNull [
	| params cmd |

	params := (1 to: 32) collect: [:each | MySQLBindParameter new bindValue: #foo].
	params at: 8 put: (MySQLBindParameter new bindValue: nil).
	params at: 16 put: (MySQLBindParameter new bindValue: nil).
	params at: 24 put: (MySQLBindParameter new bindValue: nil).
	params at: 32 put: (MySQLBindParameter new bindValue: nil).
	
	cmd := MySQLCommandExecute new.
	cmd params: params.
	self assert: (4 = cmd nullBitMap size).
	self 
		assert: (ByteArray with: 16r80 with: 16r80 with: 16r80 with: 16r80) = cmd nullBitMap.

]
