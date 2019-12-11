Extension { #name : #DateAndTime }

{ #category : #'*MysqlDriver' }
DateAndTime >> asISOString [
	^ String streamContents: [ :aStream |
		self printYMDOn: aStream.
		aStream nextPut: $T.
		self hour printOn: aStream base: 10 length: 2 padded: true.
		aStream nextPut: $:.
		self minute printOn: aStream base: 10 length: 2 padded: true.
		aStream nextPut: $:. 
		self seconds printOn: aStream base: 10 length: 2 padded: true]
]
