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

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> database: dbName [
	database := dbName
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> db [
	^ database
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> db: dbName [
	database := dbName
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> host [
	^ host
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> host: server [
	host := server
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> options: driverOptions [
	options := driverOptions
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> password [
	^ password
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> password: userPassword [
	password := userPassword
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> port [
	^ port
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> port: serverPort [
	port := serverPort
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> user [
	^ user
]

{ #category : #'as yet unclassified' }
MySQLDriverSpec >> user: userName [
	user := userName
]
