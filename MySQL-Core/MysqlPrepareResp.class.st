Class {
	#name : #MysqlPrepareResp,
	#superclass : #MysqlComplexResult,
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
MysqlPrepareResp >> columnDescriptors [
	^ columnDescriptors
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> columnDescriptors: fields [
	columnDescriptors := fields 
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> columnEof: anEof [
	columnEof := anEof
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> isOkay [
	^ prepareOkay isOkay 
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> isPrepareResponse [
	^ true
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> paramDescriptors [
	^ paramDescriptors
	 
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> paramDescriptors: fields [
	paramDescriptors := fields 
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> paramEof: anEof [
	paramEof := anEof 
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> prepareOkay [
	^ prepareOkay
	
]

{ #category : #'as yet unclassified' }
MysqlPrepareResp >> prepareOkay: prepOkay [
	prepareOkay := prepOkay
	
]
