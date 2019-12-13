Class {
	#name : #MysqlDriver,
	#superclass : #Object,
	#instVars : [
		'netSession',
		'handshakeInfo'
	],
	#category : #'MySQL-Core-Driver'
}

{ #category : #testing }
MysqlDriver >> assertConnection [
	self connected ifFalse: [^ MysqlNoConnectionError signal: 'Driver is not connected'].
	

]

{ #category : #accessing }
MysqlDriver >> changeUser: connSpec [ 
	| com scrmbl |
	self assertConnection.
	com := MysqlComChangeUser onSession: netSession.
	scrmbl := connSpec password isEmptyOrNil 
		ifTrue: [ '' asByteArray ]
		ifFalse: [ 
			MysqlHelper 
				secureScramble: 
					handshakeInfo scrambleBuff , handshakeInfo scrambleBuffMore
				with: connSpec password ].
	com
		user: connSpec user;
		scrambledPassword: scrmbl;
		database: connSpec db;
		password: connSpec password;
		scrambleBuff: handshakeInfo scrambleBuff;
		charset: handshakeInfo serverLang.
	^ com execute
]

{ #category : #accessing }
MysqlDriver >> connect: connSpec [ 
	| handshake resp |
	
	self connected ifTrue: [^ MysqlDriverError signal: 'Driver is already connected'].
	netSession ifNil: [netSession := MysqlNetSession new].
	netSession toHost: connSpec host andPort: connSpec port.

	handshake := self readHandshake.
	self writeAuthForHandshake: handshake onConnection: connSpec.

	resp := self peekResponse.
	resp isEof ifTrue: [
		"Read the send short hash indicator: ainsgle eof(254) byte)"
		self readResponse.
		"This is an indication that comes from server if the password for this user
		follows the old style (short hash) instead of the new style (long hash). 
		We need to send back the 323 scramble"
		self send323Scramble: handshake scrambleBuff password: connSpec password.
		resp := self peekResponse]. 
	resp isError ifTrue: [^ MysqlError from: netSession read].
	resp isOkay ifTrue: [
		self keepHandshakeInfo: handshake.
		^ MysqlOkay from: netSession read].
	
	MysqlDriverError signal: 'Unexpected response from server: data is not okay/error/eof'
	
]

{ #category : #testing }
MysqlDriver >> connected [
	^ netSession isNil not and: [netSession connected]
	
]

{ #category : #accessing }
MysqlDriver >> disconnect [
	self assertConnection.
	(MysqlComQuit  onSession: netSession) execute.
	netSession disconnect.
	
]

{ #category : #private }
MysqlDriver >> errorFromResponse: resp [
	^ MysqlError from: resp data

]

{ #category : #private }
MysqlDriver >> handshakeInfo [
	^ handshakeInfo 
]

{ #category : #private }
MysqlDriver >> keepHandshakeInfo: handshake [
	handshakeInfo := handshake
]

{ #category : #accessing }
MysqlDriver >> netSession [
	^ netSession
	
]

{ #category : #private }
MysqlDriver >> okayFromResponse: resp [
	^ MysqlOkay from: resp data
]

{ #category : #private }
MysqlDriver >> peekResponse [
	| buffer resp |
	
	buffer := netSession peek.
	resp := MysqlPacket from: buffer.
	^ resp
	
]

{ #category : #accessing }
MysqlDriver >> ping [
	self assertConnection.
	^ (MysqlComPing onSession: netSession) execute
]

{ #category : #accessing }
MysqlDriver >> prepare: queryString [
	| prepStmt prepResp |

	self assertConnection.		
	prepStmt := MysqlComPrepare onSession: netSession.
	prepStmt queryString: queryString.
	prepResp := prepStmt execute. "error or prepare reponse"
	
	^ prepResp

]

{ #category : #accessing }
MysqlDriver >> query: queryString [
	| qry results |

	self assertConnection.		
	qry := MysqlComQuery onSession: netSession.
	qry queryString: queryString.
	results := qry execute.
	
	^ results

]

{ #category : #private }
MysqlDriver >> readHandshake [

	| buffer handshake |

	buffer := netSession read.
	handshake := MysqlHandshake from: buffer.

	^handshake 
]

{ #category : #private }
MysqlDriver >> readResponse [
	| buffer resp |
	
	buffer := netSession read.
	resp := MysqlPacket from: buffer.
	^ resp
]

{ #category : #'as yet unclassified' }
MysqlDriver >> send323Scramble: seed password: password [
	| scrmblPkt |
	scrmblPkt := Mysql323Scramble new.
	scrmblPkt password: password; scrambleBuff: seed.
	self writePacket: scrmblPkt.
	
]

{ #category : #private }
MysqlDriver >> writeAuthForHandshake: handshake onConnection: connSpec [

	| auth |

	handshake supportsProtocol41 
		ifTrue: [auth := MysqlClientAuth new]
		ifFalse: [MysqlUnsupportedProtocolError signal: 'Server does not support protocol version 41'].
	
	auth
		serverCaps: handshake serverCaps ;
		charset: handshake serverLang ;
		user: connSpec user ;
		password: connSpec password ;
		database: connSpec db ;
		scrambleBuff: handshake scrambleBuff ;
		scrambleBuffMore: handshake scrambleBuffMore .
		
	self writePacket: auth 
]

{ #category : #private }
MysqlDriver >> writePacket: packet [
	| buffer |
	
	buffer := packet write.
	netSession  write: buffer.

]
