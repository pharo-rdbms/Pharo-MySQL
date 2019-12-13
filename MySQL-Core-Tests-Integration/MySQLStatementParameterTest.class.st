Class {
	#name : #MySQLStatementParameterTest,
	#superclass : #TestCase,
	#category : #'MySQL-Core-Tests-Integration-Base'
}

{ #category : #tests }
MySQLStatementParameterTest >> testParamNull [
	| inParam |
	inParam := MySQLBindParameter new.

	inParam bindValue: nil.
	self assert: inParam isNull.

]
