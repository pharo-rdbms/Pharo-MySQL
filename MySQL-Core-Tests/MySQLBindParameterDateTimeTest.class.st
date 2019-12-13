Class {
	#name : #MySQLBindParameterDateTimeTest,
	#superclass : #TestCase,
	#instVars : [
		'theParam'
	],
	#category : #'MySQL-Core-Tests'
}

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> setUp [
	theParam := MySQLBindParameter new.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> storeBinary [
	ByteArray streamContents: [:strm | 
		theParam storeBinaryOn: strm.
		^ strm contents]	
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testParamDate [
	theParam bindValue: (Date fromString: '06-21-2011').
	self assert: (theParam detectParamType = MySQLTypes typeDATE).
	self assert: theParam isUnsigned.
	
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testParamDateTime [
	theParam bindValue: DateAndTime current.
	self assert: (theParam detectParamType = MySQLTypes typeDATETIME).
	self assert: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testParamDuration [
	theParam bindValue: (Duration fromString: '10:02:30:45').
	self assert: (theParam detectParamType = MySQLTypes typeTIME).
	self assert: theParam isUnsigned.

	theParam bindValue: (Duration fromString: '-10:02:30:45').
	self assert: (theParam detectParamType = MySQLTypes typeTIME).
	self assert: theParam isUnsigned not.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testParamTime [
	theParam bindValue: Time now.
	self assert: (theParam detectParamType = MySQLTypes typeTIME).
	self assert: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testParamTimestamp [
	theParam bindValue: DateAndTime current.
	self assert: (theParam detectParamType = MySQLTypes typeTIMESTAMP).
	self assert: theParam isUnsigned.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testStoreBinaryDate [
	theParam bindValue: (Date fromString: '06-21-2011').
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '04DB070615'
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testStoreBinaryDateAndTime [
	theParam bindValue: (DateAndTime epoch). "Squeak epoch: 1901-01-01"
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '046D070101'.

	theParam bindValue: (DateAndTime fromString: '2011-06-21T16:45:30.00000000').
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '07DB070615102D1E'.
	
	theParam bindValue: (DateAndTime fromString: '2011-06-21T16:45:30.00123456').
	"Since the microseconds are stored form the nano (1234 from 1234560 ns)"
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '0BDB070615102D1ED2040000'.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testStoreBinaryDuration [
	theParam bindValue: (Duration zero).
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '00'.

	theParam bindValue: (Duration fromString: '10:02:30:45').
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '08000A000000021E2D'.

	theParam bindValue: (Duration fromString: '-10:02:30:45').
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '08010A000000021E2D'.

	theParam bindValue: (Duration fromString: '10:02:30:45.1234').
	self assert: 
		(MySQLHelper hexStringFromBytes: self storeBinary) = '0C000A000000021E2D08E20100'.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testStoreBinaryTime [
	theParam bindValue: (Time midnight).
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '00'.

	theParam bindValue: (Time fromString: '16:02:30').
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '08000000000010021E'.

	theParam bindValue: (Time hour: 16 minute: 02 second: 30 nanoSecond: 1234000).
	self assert: 
		(MySQLHelper hexStringFromBytes: self storeBinary) = '0C000000000010021ED2040000'.
	
]

{ #category : #'as yet unclassified' }
MySQLBindParameterDateTimeTest >> testStoreBinaryTimeStamp [
	theParam bindValue: (DateAndTime epoch). "Squeak epoch: 1901-01-01"
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '046D070101'.

	theParam bindValue: (DateAndTime year: 2011 month: 06 day: 21
							hour: 16 minute:45 second:30).
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '07DB070615102D1E'.
	
	theParam bindValue: (DateAndTime year: 2011 month: 06 day: 21
							hour: 16 minute:45 second:30 nanoSecond: 123456 offset: 0 asDuration).
	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '0BDB070615102D1E7B000000'.
	
]
