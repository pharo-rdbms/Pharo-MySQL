Class {
	#name : #MySQLDriverTest,
	#superclass : #TestCase,
	#instVars : [
		'connector'
	],
	#classInstVars : [
		'protocol'
	],
	#category : #'MySQL-Core-Tests-Integration'
}

{ #category : #'as yet unclassified' }
MySQLDriverTest >> badConnectionSpec [
	| connSpec |
	
	connSpec := self goodConnectionSpec .
	connSpec password: 'wrongpassword' .
	
	^ connSpec
]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> goodConnectionSpec [
	^ MySQLDriverSpec new
		host: 'localhost';
		port: 3306;
		user: 'root';
		password: '';
		yourself
]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> invalidHostNameConnectionSpec [
	| connSpec |
	
	connSpec := self goodConnectionSpec .
	connSpec host: 'souldfail.nodomain.zzz' .
	
	^ connSpec
]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> setUp [
	connector := MySQLDriver new
]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> tearDown [
	connector connected ifTrue: [connector disconnect]
]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> testConnectAssorted [
	| connSpec |
	
	connSpec := self goodConnectionSpec .
	self assert: (connector connect: connSpec) isOkay.
	connector disconnect.
	
	connSpec := self badConnectionSpec .
	self assert: (connector connect: connSpec) isError.
	connector connected ifTrue: [connector disconnect].

	connSpec := self goodConnectionSpec .
	self assert: (connector connect: connSpec) isOkay .
	connector disconnect.

]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> testConnectBad [
	| connSpec |
	connSpec := self badConnectionSpec .
	self assert: (connector connect: connSpec) isError .
	
]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> testConnectGood [

	| connSpec resp |
	
	connSpec := self goodConnectionSpec.
	resp := connector connect: connSpec.
	self assert: resp isOkay.
	
]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> testConnectWithDb [
	| connSpec resp |
	connSpec := self goodConnectionSpec.
	connSpec db: 'sodbxtest2'.
	resp := connector connect: connSpec.
	self assert: resp isOkay.
	connector disconnect.

	connSpec db: 'sodbxtest2' reversed.
	self assert: (connector connect: connSpec) isError.
	connector connected ifTrue: [ connector disconnect].

]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> testDisconnect [

	| connSpec |
	
	connSpec := self goodConnectionSpec .
	self assert: (connector connect: connSpec) isOkay.
	self shouldnt: [connector disconnect] raise: MySQLNoConnectionError .
	self should: [connector disconnect] raise: MySQLNoConnectionError .
]

{ #category : #'as yet unclassified' }
MySQLDriverTest >> testHostLookupError [
	| connSpec |
	connSpec := self invalidHostNameConnectionSpec.
	self should: [connector connect: connSpec] raise: MySQLNameLookupFailure.

]
