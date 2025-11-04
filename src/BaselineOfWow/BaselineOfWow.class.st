Class {
	#name : #BaselineOfWow,
	#superclass : #BaselineOf,
	#category : #BaselineOfWow
}

{ #category : #baseline }
BaselineOfWow >> baseline: spec [
	<baseline>
	^ spec for: #common do: [ spec package: 'Wow' ]
]
