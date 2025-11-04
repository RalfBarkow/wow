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
WowCodebaseLocator class >> wowDitaSrcDir [
	"Directory that contains the DITA map(s)."

	^ self wowWorkspaceRoot / 'src/dita'
]

{ #category : #paths }
WowCodebaseLocator class >> wowLepiterDir [
	^ self wowWorkspaceRoot / 'lepiter'
]

{ #category : #paths }
WowCodebaseLocator class >> wowPositionPaperDitamap [
	"Main DITA map for the WOW position paper:
	   <wowWorkspaceRoot>/src/dita/wow-position.ditamap"

	^ self wowDitaSrcDir / 'wow-position.ditamap'
]

{ #category : #paths }
WowCodebaseLocator class >> wowSpecMarkdown [
	"Canonical WOW spec file:
	   <wowWorkspaceRoot>/SPEC.md"
	^ self wowWorkspaceRoot / 'SPEC.md'
]

{ #category : #paths }
WowCodebaseLocator class >> wowWorkspaceRoot [
	"Root of the wow git repo: /Users/rgb/workspace/wow"
	^ FileLocator home / 'workspace/wow'
]
