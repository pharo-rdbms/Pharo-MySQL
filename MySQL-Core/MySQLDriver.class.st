"
Driver class for MySQL
"
Class {
	#name : #MySQLDriver,
	#superclass : #Object,
	#instVars : [
		'netSession',
		'handshakeInfo'
	],
	#category : #'MySQL-Core-Driver'
}

{ #category : #testing }
MySQLDriver >> assertConnection [
	self connected ifFalse: [^ MySQLNoConnectionError signal: 'Driver is not connected'].
	

]

{ #category : #accessing }
MySQLDriver >> changeUser: connSpec [ 
	| com scrmbl |
	self assertConnection.
	com := MySQLCommandChangeUser onSession: netSession.
	scrmbl := connSpec password isEmptyOrNil 
		ifTrue: [ '' asByteArray ]
		ifFalse: [ 
			MySQLHelper 
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
MySQLDriver >> connect: connSpec [ 
	| handshake resp |
	
	self connected ifTrue: [^ MySQLDriverError signal: 'Driver is already connected'].
	netSession ifNil: [netSession := MySQLNetworkSession new].
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
	resp isError ifTrue: [^ MySQLError from: netSession read].
	resp isOkay ifTrue: [
		self keepHandshakeInfo: handshake.
		^ MySQLOkay from: netSession read].
	
	MySQLDriverError signal: 'Unexpected response from server: data is not okay/error/eof'
	
]

{ #category : #testing }
MySQLDriver >> connected [
	^ netSession isNil not and: [netSession connected]
	
]

{ #category : #accessing }
MySQLDriver >> disconnect [
	self assertConnection.
	(MySQLCommandQuit  onSession: netSession) execute.
	netSession disconnect.
	
]

{ #category : #private }
MySQLDriver >> errorFromResponse: resp [
	^ MySQLError from: resp data

]

{ #category : #private }
MySQLDriver >> handshakeInfo [
	^ handshakeInfo 
]

{ #category : #private }
MySQLDriver >> keepHandshakeInfo: handshake [
	handshakeInfo := handshake
]

{ #category : #accessing }
MySQLDriver >> netSession [
	^ netSession
	
]

{ #category : #private }
MySQLDriver >> okayFromResponse: resp [
	^ MySQLOkay from: resp data
]

{ #category : #private }
MySQLDriver >> peekResponse [
	| buffer resp |
	
	buffer := netSession peek.
	resp := MySQLPacket from: buffer.
	^ resp
	
]

{ #category : #accessing }
MySQLDriver >> ping [
	self assertConnection.
	^ (MySQLCommandPing onSession: netSession) execute
]

{ #category : #accessing }
MySQLDriver >> prepare: queryString [
	| prepStmt prepResp |

	self assertConnection.		
	prepStmt := MySQLCommandPrepare onSession: netSession.
	prepStmt queryString: queryString.
	prepResp := prepStmt execute. "error or prepare reponse"
	
	^ prepResp

]

{ #category : #accessing }
MySQLDriver >> query: queryString [
	| qry results |

	self assertConnection.		
	qry := MySQLCommandQuery onSession: netSession.
	qry queryString: queryString.
	results := qry execute.
	
	^ results

]

{ #category : #private }
MySQLDriver >> readHandshake [

	| buffer handshake |

	buffer := netSession read.
	handshake := MySQLHandshake from: buffer.

	^handshake 
]

{ #category : #private }
MySQLDriver >> readResponse [
	| buffer resp |
	
	buffer := netSession read.
	resp := MySQLPacket from: buffer.
	^ resp
]

{ #category : #scrambling }
MySQLDriver >> send323Scramble: seed password: password [
	| scrmblPkt |
	scrmblPkt := MySQL323Scramble new.
	scrmblPkt password: password; scrambleBuff: seed.
	self writePacket: scrmblPkt.
	
]

{ #category : #private }
MySQLDriver >> writeAuthForHandshake: handshake onConnection: connSpec [

	| auth |

	handshake supportsProtocol41 
		ifTrue: [auth := MySQLClientAuth new]
		ifFalse: [MySQLUnsupportedProtocolError signal: 'Server does not support protocol version 41'].
	
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
MySQLDriver >> writePacket: packet [
	| buffer |
	
	buffer := packet write.
	netSession  write: buffer.

]
