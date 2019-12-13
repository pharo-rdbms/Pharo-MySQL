"
Prepare response packet for MySQL
"
Class {
	#name : #MySQLPrepareResponse,
	#superclass : #MySQLComplexResult,
	#instVars : [
		'prepareOkay',
		'paramDescriptors',
		'paramEof',
		'columnDescriptors',
		'columnEof'
	],
	#category : #'MySQL-Core-Packet-Results'
}

{ #category : #accessing }
MySQLPrepareResponse >> columnDescriptors [
	^ columnDescriptors
	
]

{ #category : #accessing }
MySQLPrepareResponse >> columnDescriptors: fields [
	columnDescriptors := fields 
	
]

{ #category : #accessing }
MySQLPrepareResponse >> columnEof: anEof [
	columnEof := anEof
	
]

{ #category : #testing }
MySQLPrepareResponse >> isOkay [
	^ prepareOkay isOkay 
	
]

{ #category : #testing }
MySQLPrepareResponse >> isPrepareResponse [
	^ true
	
]

{ #category : #accessing }
MySQLPrepareResponse >> paramDescriptors [
	^ paramDescriptors
	 
	
]

{ #category : #accessing }
MySQLPrepareResponse >> paramDescriptors: fields [
	paramDescriptors := fields 
	
]

{ #category : #accessing }
MySQLPrepareResponse >> paramEof: anEof [
	paramEof := anEof 
	
]

{ #category : #accessing }
MySQLPrepareResponse >> prepareOkay [
	^ prepareOkay
	
]

{ #category : #accessing }
MySQLPrepareResponse >> prepareOkay: prepOkay [
	prepareOkay := prepOkay
	
]
