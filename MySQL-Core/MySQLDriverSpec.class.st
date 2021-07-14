"
Driver specification
"
Class {
	#name : #MySQLDriverSpec,
	#superclass : #Object,
	#instVars : [
		'host',
		'port',
		'user',
		'password',
		'database',
		'options'
	],
	#category : #'MySQL-Core-Driver'
}

{ #category : #accessing }
MySQLDriverSpec >> database: dbName [
	database := dbName
]

{ #category : #accessing }
MySQLDriverSpec >> db [
	^ database
]

{ #category : #accessing }
MySQLDriverSpec >> db: dbName [
	database := dbName
]

{ #category : #accessing }
MySQLDriverSpec >> host [
	^ host
]

{ #category : #accessing }
MySQLDriverSpec >> host: server [
	host := server
]

{ #category : #accessing }
MySQLDriverSpec >> options: driverOptions [
	options := driverOptions
]

{ #category : #accessing }
MySQLDriverSpec >> password [
	^ password
]

{ #category : #accessing }
MySQLDriverSpec >> password: userPassword [
	password := userPassword
]

{ #category : #accessing }
MySQLDriverSpec >> port [
	^ port ifNil: [ port := 3306 ]
]

{ #category : #accessing }
MySQLDriverSpec >> port: serverPort [
	port := serverPort
]

{ #category : #accessing }
MySQLDriverSpec >> user [
	^ user
]

{ #category : #accessing }
MySQLDriverSpec >> user: userName [
	user := userName
]
