Class {
	#name : #BaselineOfListPlus,
	#superclass : #BaselineOf,
	#category : #BaselineOfListPlus
}

{ #category : #baseline }
BaselineOfListPlus >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'ListPlus'
		]
]
