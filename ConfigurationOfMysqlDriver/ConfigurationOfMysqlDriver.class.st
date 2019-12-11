Class {
	#name : #ConfigurationOfMysqlDriver,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfMysqlDriver
}

{ #category : #private }
ConfigurationOfMysqlDriver class >> bootstrapPackage: aString from: aPath [ 
	| repository version |
	repository := MCHttpRepository
				location: aPath
				user: ''
				password: ''.
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]
]

{ #category : #private }
ConfigurationOfMysqlDriver class >> ensureMetacello [
        "Bootstrap Gofer (if necessary), load latest mcz file for ConfigurationOfMetacello (using old 
         Gofer API), then load the latest version of Metacello itself."

        Smalltalk at: #MetacelloProject ifAbsent: [ | error |
                "list of repositories to try, in case primary repository is not accessible"
                (Array 
                        with: 'http://www.squeaksource.com/MetacelloRepository' 
                        with: 'http://seaside.gemstone.com/ss/metacello') do: [:repositoryUrl |
                                ([
                                        Smalltalk at: #Gofer ifAbsent: [
                                        "Current version of Gofer from which to bootstrap - as of 1.0-beta.21"
                                                self bootstrapPackage: 'Gofer-Core-lr.115' from: repositoryUrl ].
                                        Smalltalk at: #Gofer ifPresent: [:goferClass | | gofer |
                                                gofer := goferClass new
                                                        url: repositoryUrl;
                                                        yourself.
                                                [ gofer addPackage: 'ConfigurationOfMetacello' ] on: Warning do: [:ex | ex resume ].
                                                gofer load ]]
                                                        on: Error
                                                        do: [ :ex |
                                                                error := ex.
                                                                Transcript 
                                                                        cr; 
                                                                        show: 'failed ensureMetacello: ';
                                                                        show: ex description printString;
                                                                        show: '...retrying'.
                                                                "try again"
                                                                ex return: nil ]) ~~ nil
                                        ifTrue: [
                                                "load 'default' group of Metacello"
                                                (Smalltalk at: #ConfigurationOfMetacello) perform: #load.
                                                ^self ]].
                "shouldn't get here unless the load failed ... throw an error"
                self error: 'retry with alternate repository failed: ', error description printString ]
]

{ #category : #'metacello tool support' }
ConfigurationOfMysqlDriver class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #'metacello tool support' }
ConfigurationOfMysqlDriver class >> lastMetacelloVersionLoad [
	"Answer the last version loaded and the list of packages loaded for that version."

	LastVersionLoad == nil ifTrue: [ LastVersionLoad := nil -> 'default' ].
	^LastVersionLoad
]

{ #category : #'metacello tool support' }
ConfigurationOfMysqlDriver class >> metacelloVersion: versionString loads: anArrayOrString [
	"Stash the last version loaded and the list of packages loaded for that version. The list
	 of packages will be used by the tools when doing 'Load Package Version'"

	LastVersionLoad := versionString -> anArrayOrString
]

{ #category : #accessing }
ConfigurationOfMysqlDriver class >> project [

	^self new project
]

{ #category : #baselines }
ConfigurationOfMysqlDriver >> baseline10: spec [
	<version: '1.0-baseline'>
	
	spec for: #common do: [
		spec blessing: #baseline.
		spec repository: 'http://smalltalkhub.com/mc/DBXTalk/MysqlDriver/main/'.
		spec package: 'MysqlDriver'
		].
]

{ #category : #accessing }
ConfigurationOfMysqlDriver >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project ]
]

{ #category : #baselines }
ConfigurationOfMysqlDriver >> stable: spec [ 
	<symbolicVersion: #stable>
	
	spec for: #'pharo3.0.x' version: '1.0'. 
]

{ #category : #versions }
ConfigurationOfMysqlDriver >> version10: spec [
	<version: '1.0' imports: #('1.0-baseline')>
	
	spec for: #common do: [
		spec blessing: #development.
		spec package: 'MysqlDriver' with: 'MysqlDriver-GuillermoPolito.6'. ]
]
