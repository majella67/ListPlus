Class {
	#name : #BaselineOfListPlus,
	#superclass : #BaselineOf,
	#category : #BaselineOfListPlus
}

{ #category : #accessing }
BaselineOfListPlus class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'ListPlus' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfListPlus >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'ListPlus'
		]
]
