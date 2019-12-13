"
Abstract superclass for all MySQL commands
"
Class {
	#name : #MySQLCommandBase,
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

{ #category : #'class initialization' }
MySQLCommandBase class >> initialize [
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

{ #category : #'instance creation' }
MySQLCommandBase class >> onSession: ioSession [
	^ self new session: ioSession
	
]

{ #category : #defaults }
MySQLCommandBase >> commandArg [
	self subclassResponsibility 
]

{ #category : #defaults }
MySQLCommandBase >> commandCode [
	self subclassResponsibility 
]

{ #category : #operating }
MySQLCommandBase >> execute [
	| resp cmd |
	session resetSequence.
	cmd := self prepare.
	self send: cmd.
	resp := self readResponse.

	^ resp
]

{ #category : #initialization }
MySQLCommandBase >> initialize [
	errorDict := Dictionary new
]

{ #category : #operating }
MySQLCommandBase >> prepare [
	| cmd |
	cmd := MySQLCommand new.
	cmd command: self commandCode arg: self commandArg.
	^ cmd
]

{ #category : #operating }
MySQLCommandBase >> readResponse [
	| resp |

	resp := MySQLPacket from: session peek.
	resp isError ifTrue: [^ MySQLError from: session read].
	resp isOkay ifTrue: [^ MySQLOkay from: session read].

	^ resp "Response type unknown at this point"
]

{ #category : #operating }
MySQLCommandBase >> send: cmd [
	| buffer |

	buffer := cmd write.
	session write: buffer.

]

{ #category : #operating }
MySQLCommandBase >> session: ioSession [
	session := ioSession
]

{ #category : #operating }
MySQLCommandBase >> writePacket: packet [
	| buffer |
	
	buffer := packet write.
	session  write: buffer.
	
]
