Class {
	#name : #MySQLStatementParameterTest,
	#superclass : #TestCase,
	#category : #'MySQL-Core-Tests-Integration'
}

{ #category : #'as yet unclassified' }
MySQLStatementParameterTest >> testParamNull [
	| inParam |
	inParam := MySQLBindParameter new.

	inParam bindValue: nil.
	self assert: inParam isNull.

]
