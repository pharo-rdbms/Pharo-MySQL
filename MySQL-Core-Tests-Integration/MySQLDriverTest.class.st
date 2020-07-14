Class {
	#name : #MySQLDriverTest,
	#superclass : #MySQLTestCase,
	#instVars : [
		'connector'
	],
	#classInstVars : [
		'protocol'
	],
	#category : #'MySQL-Core-Tests-Integration-Driver'
}

{ #category : #accessing }
MySQLDriverTest >> badConnectionSpec [
	| connSpec |
	
	connSpec := self goodConnectionSpec .
	connSpec password: 'wrongpassword' .
	
	^ connSpec
]

{ #category : #accessing }
MySQLDriverTest >> goodConnectionSpec [
	^ MySQLTestResource driverSpecNoDb
]

{ #category : #accessing }
MySQLDriverTest >> invalidHostNameConnectionSpec [
	| connSpec |
	
	connSpec := self goodConnectionSpec .
	connSpec host: 'souldfail.nodomain.zzz' .
	
	^ connSpec
]

{ #category : #running }
MySQLDriverTest >> setUp [
	super setUp.
	connector := MySQLDriver new
]

{ #category : #running }
MySQLDriverTest >> tearDown [
	connector connected ifTrue: [connector disconnect].
	super tearDown
]

{ #category : #tests }
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

{ #category : #tests }
MySQLDriverTest >> testConnectBad [
	| connSpec |
	connSpec := self badConnectionSpec .
	self assert: (connector connect: connSpec) isError .
	
]

{ #category : #tests }
MySQLDriverTest >> testConnectGood [

	| connSpec resp |
	
	connSpec := self goodConnectionSpec.
	resp := connector connect: connSpec.
	self assert: resp isOkay.
	
]

{ #category : #tests }
MySQLDriverTest >> testConnectWithDb [
	| connSpec resp |
	connSpec := self goodConnectionSpec.
	connSpec db: MySQLTestResource dbName.
	resp := connector connect: connSpec.
	self assert: resp isOkay.
	connector disconnect.

	connSpec db: MySQLTestResource dbName reversed.
	self assert: (connector connect: connSpec) isError.
	connector connected ifTrue: [ connector disconnect].

]

{ #category : #tests }
MySQLDriverTest >> testDisconnect [

	| connSpec |
	
	connSpec := self goodConnectionSpec .
	self assert: (connector connect: connSpec) isOkay.
	self shouldnt: [connector disconnect] raise: MySQLNoConnectionError .
	self should: [connector disconnect] raise: MySQLNoConnectionError .
]

{ #category : #tests }
MySQLDriverTest >> testHostLookupError [
	| connSpec |
	connSpec := self invalidHostNameConnectionSpec.
	self should: [connector connect: connSpec] raise: MySQLNameLookupFailure.

]
