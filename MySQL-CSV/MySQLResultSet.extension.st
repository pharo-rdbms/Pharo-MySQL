Extension { #name : #MySQLResultSet }

{ #category : #'*MySQL-CSV' }
MySQLResultSet >> asCSV [
	^String streamContents: [ :writeStream |
	(NeoCSVWriter on: writeStream)
		writeHeader: (self fields collect: [:ea | ea name]);
		nextPutAll: rows ]
]
