Class {
	#name : #MysqlDriverSpec,
	#superclass : #Object,
	#instVars : [
		'host',
		'port',
		'user',
		'password',
		'database',
		'options'
	],
	#category : #'MysqlDriver-Driver'
}

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> database: dbName [
	database := dbName
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> db [
	^ database
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> db: dbName [
	database := dbName
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> host [
	^ host
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> host: server [
	host := server
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> options: driverOptions [
	options := driverOptions
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> password [
	^ password
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> password: userPassword [
	password := userPassword
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> port [
	^ port
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> port: serverPort [
	port := serverPort
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> user [
	^ user
]

{ #category : #'as yet unclassified' }
MysqlDriverSpec >> user: userName [
	user := userName
]
