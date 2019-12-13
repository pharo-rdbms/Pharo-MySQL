Class {
	#name : #MysqlTestCase,
	#superclass : #TestCase,
	#category : #'MySQL-Test-Integ'
}

{ #category : #'as yet unclassified' }
MysqlTestCase class >> fixtureClass [
	"Override this in order to offer test specific fixture class"
	^ MysqlTestFixture
	
]

{ #category : #'as yet unclassified' }
MysqlTestCase class >> resourceClass [
	^ MysqlTestResource
]

{ #category : #'as yet unclassified' }
MysqlTestCase class >> resources [
	^ Set new 
		add: self resourceClass; 
		yourself
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> cleanUpFixtureData [
	self class resourceClass current clearTestTables 
	
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> configureNotStrict: connection [
	"Change the sql_mode for the current session test (in case of strict mode enabled)"
	
	connection query: 'SET SESSION sql_mode = ''NO_ENGINE_SUBSTITUTION'';'.
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> connection [
	^ self testConnection
	
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> driverSpec [
	^ self class resourceClass driverSpecWithDb
	
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> loadOneFixture: fixtureName [
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
MysqlTestCase >> resourceConnection [
	^ self class resourceClass current resourceConnection 
	
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> specForTest [
	^ self class resourceClass current specForTest
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> tearDown [
	self cleanUpFixtureData
	
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> testConnection [
	^ self class resourceClass current testConnection
	
]

{ #category : #'as yet unclassified' }
MysqlTestCase >> withFixtures: fixtureNameList do: testBlock [
	fixtureNameList do: [:each | self loadOneFixture: each].
	testBlock value: self resourceConnection 
	
]
