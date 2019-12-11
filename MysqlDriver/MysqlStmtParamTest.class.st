Class {
	#name : #MysqlStmtParamTest,
	#superclass : #TestCase,
	#category : #'MysqlDriver-Test-Integ'
}

{ #category : #'as yet unclassified' }
MysqlStmtParamTest >> testParamNull [
	| inParam |
	inParam := MysqlBindParam new.

	inParam bindValue: nil.
	self assert: inParam isNull.

]
