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
				package: 'MySQL';
				package: 'MySQL-Driver' with: [ spec requires: #('MySQL' 'MySQL-Command' 'MySQL-Exception' 'MySQL-Helper' 'MySQL-Net' 'MySQL-Packet') ];
				package: 'MySQL-Test-Unit' with: [ spec requires: #('MySQL-Driver') ];
				package: 'MySQL-Test-Integ' with: [ spec requires: #('MySQL-Driver') ].				
						
			"Groups"
			spec
				group: 'Core' with: #('MySQL-Driver');		
				group: 'Tests' with: #('MySQL-Test-Integ' 'MySQL-Test-Unit'); 				
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
