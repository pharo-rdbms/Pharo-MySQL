Class {
	#name : 'MySQLCommandWithQuery',
	#superclass : 'MySQLCommandWithResults',
	#instVars : [
		'query'
	],
	#category : 'MySQL-Core-Command',
	#package : 'MySQL-Core',
	#tag : 'Command'
}

{ #category : 'defaults' }
MySQLCommandWithQuery >> commandArg [
	^ query 
]

{ #category : 'defaults' }
MySQLCommandWithQuery >> queryString: queryString [ 
	query := queryString
]
