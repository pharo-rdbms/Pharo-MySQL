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
								
			"Packages"
			spec 
				package: 'MySQL-Core';
				package: 'MySQL-Core-Tests' with: [ spec requires: #('MySQL-Core') ];
				package: 'MySQL-Core-Tests-Integration' with: [ spec requires: #('MySQL-Core-Tests') ].				
						
			"Groups"
			spec
				group: 'Core' with: #('MySQL-Core');		
				group: 'Tests' with: #('MySQL-Core-Tests' 'MySQL-Core-Tests-Integration'); 				
				group: 'all' with: #('Core' 'Tests');
				group: 'default' with: #('all')].
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
