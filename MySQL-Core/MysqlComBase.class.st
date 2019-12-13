Class {
	#name : #MysqlComBase,
	#superclass : #Object,
	#instVars : [
		'session',
		'errorDict'
	],
	#classVars : [
		'ComChangeUser',
		'ComCreateDb',
		'ComDebug',
		'ComDropDb',
		'ComFieldList',
		'ComInitDb',
		'ComPing',
		'ComQuery',
		'ComQuit',
		'ComSetOption',
		'ComSleep',
		'ComStat',
		'ComStmtClose',
		'ComStmtExecute',
		'ComStmtFetch',
		'ComStmtPrepare',
		'ComStmtReset',
		'ComStmtSendLongData'
	],
	#category : #'MySQL-Core-Command'
}

{ #category : #'as yet unclassified' }
MysqlComBase class >> initialize [
	"self initialize"
	
	ComSleep := 16r00.
	ComQuit := 16r01.
	ComInitDb := 16r02.
	ComQuery := 16r03.
	ComFieldList := 16r04.
	ComStat := 16r09.
	ComDebug := 16r0D.
	ComPing := 16r0E.
	ComChangeUser := 16r11.
	ComStmtPrepare := 16r16.
	ComStmtExecute := 16r17.
	ComStmtSendLongData := 16r18.
	ComStmtClose := 16r19.
	ComStmtReset := 16r1A.
	ComSetOption := 16r1B.
	ComStmtFetch := 16r1C.
]

{ #category : #'as yet unclassified' }
MysqlComBase class >> onSession: ioSession [
	^ self new session: ioSession
	
]

{ #category : #'as yet unclassified' }
MysqlComBase >> commandArg [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
MysqlComBase >> commandCode [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
MysqlComBase >> execute [
	| resp cmd |
	session resetSequence.
	cmd := self prepare.
	self send: cmd.
	resp := self readResponse.

	^ resp
]

{ #category : #'as yet unclassified' }
MysqlComBase >> initialize [
	errorDict := Dictionary new
]

{ #category : #'as yet unclassified' }
MysqlComBase >> prepare [
	| cmd |
	cmd := MysqlCommand new.
	cmd command: self commandCode arg: self commandArg.
	^ cmd
]

{ #category : #'as yet unclassified' }
MysqlComBase >> readResponse [
	| resp |

	resp := MysqlPacket from: session peek.
	resp isError ifTrue: [^ MysqlError from: session read].
	resp isOkay ifTrue: [^ MysqlOkay from: session read].

	^ resp "Response type unknown at this point"
]

{ #category : #'as yet unclassified' }
MysqlComBase >> send: cmd [
	| buffer |

	buffer := cmd write.
	session write: buffer.

]

{ #category : #'as yet unclassified' }
MysqlComBase >> session: ioSession [
	session := ioSession
]

{ #category : #'as yet unclassified' }
MysqlComBase >> writePacket: packet [
	| buffer |
	
	buffer := packet write.
	session  write: buffer.
	
]
