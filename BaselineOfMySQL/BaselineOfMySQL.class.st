"
I represent the interdependencies of the subpackages of MySQL.
"
Class {
	#name : #BaselineOfMySQL,
	#superclass : #BaselineOf,
	#category : #BaselineOfMySQL
}

{ #category : #baselines }
BaselineOfMySQL >> baseline: spec [
	<baseline>
	
	spec 
		for: #common
		do: [ 
			spec blessing: #baseline.
								
			"Dependencies"			
			spec 
				baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON:master/repository' ];
				baseline: 'ZTimestamp' with: [ spec repository: 'github://svenvc/ztimestamp:master/repository' ];
				baseline: 'Glorp' with: [ spec repository: 'github://pharo-rdbms/glorp:master/'].
			"Packages"
			spec 
				package: 'MySQL-Core' with: [ spec requires: #('NeoJSON' 'ZTimestamp') ];
				package: 'MySQL-Glorp' with: [ spec requires: #('MySQL-Core' 'Glorp') ];
				package: 'MySQL-Core-Tests' with: [ spec requires: #('MySQL-Core') ];
				package: 'MySQL-Core-Tests-Integration' with: [ spec requires: #('MySQL-Core-Tests') ].				
						
			"Groups"
			spec
				group: 'default' with: #('all');
				group: 'core' with: #('MySQL-Core');		
				group: 'glorp' with: #('MySQL-Glorp');				
				group: 'all' with: #('MySQL-Core' 'MySQL-Core-Tests' 'MySQL-Core-Tests-Integration')
				].
]

{ #category : #accessing }
BaselineOfMySQL >> project [
	^ super project
		loadType: #atomic;
		yourself
]

{ #category : #baselines }
BaselineOfMySQL >> projectClass [
	^ MetacelloCypressBaselineProject
]
