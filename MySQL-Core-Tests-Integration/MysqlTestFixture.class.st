"
Test fixture for MySQL testing
"
Class {
	#name : #MySQLTestFixture,
	#superclass : #Object,
	#category : #'MySQL-Core-Tests-Integration-Test-Fixtures'
}

{ #category : #accessing }
MySQLTestFixture class >> fixtureBlobs [
	^ #(
	'insert into 
		testBlobs (tinyblobValue, blobValue, mediumblobValue, longBlobValue)
	values 
		(''0123456789'', ''0123456789'', ''0123456789'', ''0123456789''),
		(''1234567890'', null, null, ''1234567890'')'
	)
]

{ #category : #accessing }
MySQLTestFixture class >> fixtureChars [
	^ #(
	'insert into 
		testChars (charValue, varcharValue)
	values 
		(''smalltalk'', ''An awesome programming environment''),
		(''lisp'', ''So is this one'')'
	)
	
]

{ #category : #accessing }
MySQLTestFixture class >> fixtureIntegers [
	^ #(
	'insert into 
		testIntegers (tinyintValue, smallIntValue, mediumintValue, intValue, bigintValue)
		values 
		(0, 300, 40000, 100000, 6000000000), (1, 301, 40001, 100001, 6000000001),
		(2, null, null, null, 6000000002), (3, 303, 40003, 100003, null),
		(-101, -301, -40001, -100001, -6000000001)'
	)
]

{ #category : #accessing }
MySQLTestFixture class >> fixtureReals [
	^ #(
	'insert into 
		testReals (floatValue, doubleValue, realValue, decimalValue, numericValue)
	values 
		(1.1, 11.11, 222.222, 3333.333333, 4444.444444), 
		(null, null, null, null, -5555.555555),
		(-1.1, -11.11, -222.222, -3333.333333, -4444.444444)' 
	)
]

{ #category : #accessing }
MySQLTestFixture class >> fixtureTimes [
	^ #(
	'insert into 
		testTimes (dateValue, timeValue, datetimeValue, timestampvalue, yearValue)
	values 
		(''2011-07-01'', ''18:35:23'', ''2011-07-02 10:12:45'', ''1980-01-12 00:45:56'', ''1999''), 
		(''2011-06-01'', ''03 17:34:22'', ''2011-06-02 09:11:44'', ''1980-02-13 01:44:55'', ''2000''), 
		(null, null, null, null, null),
		(null, ''-16:33:21.3579'', null, ''1980-03-14 02:43:54'', ''2002'')' "null in quote is not null"
	)
]

{ #category : #accessing }
MySQLTestFixture class >> fixtureZero [
	^ #(
	'insert into testMisc (name, value, entryOn, notes) values 
		(''key-0001'', ''value-0001'', ''2011-07-01'', ''test entry 1''), 
		(''key-0002'', ''value-0002'', ''2011-07-01'', ''test entry 2''),
		(''key-0003'', ''value-0003'', ''2011-07-01'', ''test entry 3''), 
		(''key-0004'', ''value-0004'', ''2011-07-01'', ''test entry 4''),
		(''key-0005'', ''value-0005'', ''2011-07-01'', ''test entry 5''), 
		(''key-0006'', ''value-0006'', ''2011-07-01'', ''test entry 6''),
		(''key-0007'', ''value-0007'', ''2011-07-01'', ''test entry 7''), 
		(''key-0008'', ''value-0008'', ''2011-07-01'', ''test entry 8''),
		(''key-0009'', ''value-0009'', ''2011-07-01'', ''test entry 9''), 
		(''key-0010'', ''value-0010'', ''2011-07-01'', ''test entry 10'')
		'
	)
]
