Class {
	#name : #MysqlDriverTest,
	#superclass : #TestCase,
	#instVars : [
		'connector'
	],
	#classInstVars : [
		'protocol'
	],
	#category : #'MySQL-Test-Integ'
}

{ #category : #'as yet unclassified' }
MysqlDriverTest >> badConnectionSpec [
	| connSpec |
	
	connSpec := self goodConnectionSpec .
	connSpec password: 'wrongpassword' .
	
	^ connSpec
]

{ #category : #'as yet unclassified' }
MysqlDriverTest >> goodConnectionSpec [
	^ MysqlDriverSpec new
		host: 'localhost';
		port: 3306;
		user: 'root';
		password: '';
		yourself
]

{ #category : #'as yet unclassified' }
MysqlDriverTest >> invalidHostNameConnectionSpec [
	| connSpec |
	
	connSpec := self goodConnectionSpec .
	connSpec host: 'souldfail.nodomain.zzz' .
	
	^ connSpec
]

{ #category : #'as yet unclassified' }
MysqlDriverTest >> setUp [
	connector := MysqlDriver new
]

{ #category : #'as yet unclassified' }
MysqlDriverTest >> tearDown [
	connector connected ifTrue: [connector disconnect]
]

{ #category : #'as yet unclassified' }
MysqlDriverTest >> testConnectAssorted [
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
MysqlDriverTest >> testConnectBad [
	| connSpec |
	connSpec := self badConnectionSpec .
	self assert: (connector connect: connSpec) isError .
	
]

{ #category : #'as yet unclassified' }
MysqlDriverTest >> testConnectGood [

	| connSpec resp |
	
	connSpec := self goodConnectionSpec.
	resp := connector connect: connSpec.
	self assert: resp isOkay.
	
]

{ #category : #'as yet unclassified' }
MysqlDriverTest >> testConnectWithDb [
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
MysqlDriverTest >> testDisconnect [

	| connSpec |
	
	connSpec := self goodConnectionSpec .
	self assert: (connector connect: connSpec) isOkay.
	self shouldnt: [connector disconnect] raise: MysqlNoConnectionError .
	self should: [connector disconnect] raise: MysqlNoConnectionError .
]

{ #category : #'as yet unclassified' }
MysqlDriverTest >> testHostLookupError [
	| connSpec |
	connSpec := self invalidHostNameConnectionSpec.
	self should: [connector connect: connSpec] raise: MysqlNameLookupFailure.

]
