Class {
	#name : #MySQLTestCase,
	#superclass : #TestCase,
	#category : #'MySQL-Core-Tests-Integration-Base'
}

{ #category : #'as yet unclassified' }
MySQLTestCase class >> fixtureClass [
	"Override this in order to offer test specific fixture class"
	^ MySQLTestFixture
	
]

{ #category : #'as yet unclassified' }
MySQLTestCase class >> resourceClass [
	^ MySQLTestResource
]

{ #category : #'as yet unclassified' }
MySQLTestCase class >> resources [
	^ Set new 
		add: self resourceClass; 
		yourself
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> cleanUpFixtureData [
	self class resourceClass current clearTestTables 
	
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> configureNotStrict: connection [
	"Change the sql_mode for the current session test (in case of strict mode enabled)"
	
	connection query: 'SET SESSION sql_mode = ''NO_ENGINE_SUBSTITUTION'';'.
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> connection [
	^ self testConnection
	
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> driverSpec [
	^ self class resourceClass driverSpecWithDb
	
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> loadOneFixture: fixtureName [
	| fixtureSel fixtureStmtList conn resp |
	fixtureSel := 'fixture', fixtureName capitalized.
	fixtureStmtList := self class fixtureClass perform: fixtureSel asSymbol.
	fixtureStmtList do: [:stmt |
		conn := self resourceConnection.
		resp := conn query: stmt.
		resp isError 
			ifTrue: [self error: 'Error loading fixture from ', fixtureSel]]
	
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> resourceConnection [
	^ self class resourceClass current resourceConnection 
	
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> specForTest [
	^ self class resourceClass current specForTest
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> tearDown [
	self cleanUpFixtureData
	
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> testConnection [
	^ self class resourceClass current testConnection
	
]

{ #category : #'as yet unclassified' }
MySQLTestCase >> withFixtures: fixtureNameList do: testBlock [
	fixtureNameList do: [:each | self loadOneFixture: each].
	testBlock value: self resourceConnection 
	
]
