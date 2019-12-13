Class {
	#name : #MysqlStmtParamTest,
	#superclass : #TestCase,
	#category : #'MySQL-Core-Tests-Integration'
}

{ #category : #'as yet unclassified' }
MysqlStmtParamTest >> testParamNull [
	| inParam |
	inParam := MysqlBindParam new.

	inParam bindValue: nil.
	self assert: inParam isNull.

]
