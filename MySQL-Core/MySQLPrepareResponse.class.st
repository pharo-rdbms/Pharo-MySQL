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
	#category : #'MySQL-Core-Packet'
}

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> columnDescriptors [
	^ columnDescriptors
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> columnDescriptors: fields [
	columnDescriptors := fields 
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> columnEof: anEof [
	columnEof := anEof
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> isOkay [
	^ prepareOkay isOkay 
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> isPrepareResponse [
	^ true
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> paramDescriptors [
	^ paramDescriptors
	 
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> paramDescriptors: fields [
	paramDescriptors := fields 
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> paramEof: anEof [
	paramEof := anEof 
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> prepareOkay [
	^ prepareOkay
	
]

{ #category : #'as yet unclassified' }
MySQLPrepareResponse >> prepareOkay: prepOkay [
	prepareOkay := prepOkay
	
]
