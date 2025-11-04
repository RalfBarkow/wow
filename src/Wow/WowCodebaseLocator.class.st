Class {
	#name : #WowCodebaseLocator,
	#superclass : #Object,
	#category : #'Wow-Infra'
}

{ #category : #paths }
WowCodebaseLocator class >> wowDitaBuildOutputDir [
	"Where generated PDFs go."

	^ self wowWorkspaceRoot / 'build/pdf'
]

{ #category : #paths }
WowCodebaseLocator class >> wowDitaProjectDir [
	"Return the root directory of the WOW DITA project.
	 Initial stub implementation.
	 The codebase-locator agent is expected to refine this
	 (e.g., by using git roots / workspace config)."

	^ FileLocator home / 'workspace/wow/src/dita'
]

{ #category : #paths }
WowCodebaseLocator class >> wowPositionPaperDitamap [
	"Main DITA map for the WOW position paper:
	 /Users/rgb/workspace/wow/src/dita/wow-position.ditamap"

	^ self wowWorkspaceRoot / 'src/dita/wow-position.ditamap'
]

{ #category : #paths }
WowCodebaseLocator class >> wowWorkspaceRoot [
	"Root of the wow git repo: /Users/rgb/workspace/wow"

	^ FileLocator home / 'workspace/wow'
]
