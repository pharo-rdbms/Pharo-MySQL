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

{ #category : #cleanup }
MySQLTestCase >> cleanUpFixtureData [
	self class resourceClass current clearTestTables 
	
]

{ #category : #accessing }
MySQLTestCase >> configureNotStrict: connection [
	"Change the sql_mode for the current session test (in case of strict mode enabled)"
	
	connection query: 'SET SESSION sql_mode = ''NO_ENGINE_SUBSTITUTION'';'.
]

{ #category : #accessing }
MySQLTestCase >> connection [
	^ self testConnection
	
]

{ #category : #accessing }
MySQLTestCase >> driverSpec [
	^ self class resourceClass driverSpecWithDb
	
]

{ #category : #accessing }
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

{ #category : #accessing }
MySQLTestCase >> resourceConnection [
	^ self class resourceClass current resourceConnection 
	
]

{ #category : #accessing }
MySQLTestCase >> specForTest [
	^ self class resourceClass current specForTest
]

{ #category : #running }
MySQLTestCase >> tearDown [
	self cleanUpFixtureData.
	super tearDown
	
]

{ #category : #tests }
MySQLTestCase >> testConnection [
	^ self class resourceClass current testConnection
	
]

{ #category : #accessing }
MySQLTestCase >> withFixtures: fixtureNameList do: testBlock [
	fixtureNameList do: [:each | self loadOneFixture: each].
	testBlock value: self resourceConnection 
	
]
