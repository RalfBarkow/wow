Extension { #name : #LePage }

{ #category : #'*Wow' }
LePage class >> storeOnScribeAgentSpec [
	"Return a Lepiter page that documents the store-on-scribe agent spec."

	^ self unnamedPage
		addSnippet: (LeTextSnippet new
				string: '# Agent: store-on-scribe
Serializes agent outputs into Lepiter "Store on" LePage/LeTextSnippet snippets for DM6 Agenda.';
				yourself);
		addSnippet: (LeTextSnippet new
				string: '## SPEC
name: store-on-scribe
description: Serializes agent outputs into Lepiter "Store on" snippets.
model: gpt-5-thinking
inputs: codebase-locator, docs-steward, architecture-scribe, runtime-orchestrator, pharo-code-emitter
tools: none
';
				yourself);
		addSnippet: (LeTextSnippet new
				string: '## Responsibilities
* Convert structured agent answers into executable "Store on" Smalltalk snippets.
* Preserve indentation and nesting conventions.
* Keep Lepiter serialization consistent across DM6-related projects.
';
				yourself);
		addSnippet: (LeTextSnippet new
				string: '## Triggers
* User requests: "want: Store on" or similar.
* Other agents hand off content for Lepiter encoding.
';
				yourself);
		addSnippet: (LeTextSnippet new
				string: '## Deliverables
* `LePage ...` snippets with nested `LeTextSnippet` content.
* Copy-pasteable do-its to create pages in a Lepiter database.
';
				yourself);
		addSnippet: (LeTextSnippet new
				string: '## Out of scope
* Designing content (delegated to docs-steward, architecture-scribe, runtime-orchestrator, pharo-code-emitter).
* Talking directly to DMX or GitHub.';
				yourself);
		yourself
]
