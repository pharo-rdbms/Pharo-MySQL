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
		for: #pharo
		do: [ self
				setUpDependencies: spec;
				setUpPackages: spec.
			spec
				group: 'CI' with: #('Tests' 'Glorp-Tests');
				group: 'Development' with: #('Tests' 'Tools');
				group: 'default' with: #('all');
				group: 'all' with: #('core' 'Tests')
			]
]

{ #category : #baselines }
BaselineOfMySQL >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfMySQL >> setUpDependencies: spec [

	spec
		baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON:master/repository' ];
		project: 'NeoJSON-Core' copyFrom: 'NeoJSON' with: [ spec loads: 'core' ].

	spec
		baseline: 'ZTimestamp'
		with: [ spec repository: 'github://svenvc/ztimestamp:master/repository' ].

	"If Glorp provides proper groups they can be used instead of referring to the packages by name"
	spec
		baseline: 'Glorp' with: [ spec repository: 'github://pharo-rdbms/glorp:master/' ];
		project: 'Glorp-Deployment' copyFrom: 'Glorp' with: [ spec loads: 'Glorp' ];
		project: 'Glorp-Tests' copyFrom: 'Glorp' with: [ spec loads: 'Glorp-Tests' ]
]

{ #category : #baselines }
BaselineOfMySQL >> setUpPackages: spec [

	spec
		package: 'MySQL-Core' with: [ spec requires: #('NeoJSON-Core' 'ZTimestamp') ];
		group: 'core' with: 'MySQL-Core'.

	spec
		package: 'MySQL-Glorp' with: [ spec requires: #('MySQL-Core' 'Glorp-Deployment') ];
		group: 'glorp' with: 'MySQL-Glorp'.

	spec
		package: 'MySQL-Core-Tests' with: [ spec requires: 'MySQL-Core' ];
		group: 'Tests' with: 'MySQL-Core-Tests'.

	spec
		package: 'MySQL-Core-Tests-Integration' with: [ spec requires: 'MySQL-Core-Tests' ];
		group: 'Tests' with: 'MySQL-Core-Tests-Integration'
]
