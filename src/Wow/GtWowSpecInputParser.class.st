Class {
	#name : #GtWowSpecInputParser,
	#superclass : #AnObsoleteGtInputParser,
	#category : #'Wow-Input'
}

{ #category : #examples }
GtWowSpecInputParser class >> exampleEvaluateWowSpecOnHome [
    <gtExample>
    | fileRef input parser result |
    fileRef := FileLocator home / 'workspace/wow/SPEC.md'.
    input := GtInputFile new
        fileReference: fileRef;
        yourself.
    parser := self new.
    (parser canHandle: input)
        ifFalse: [ ^ 'GtWowSpecInputParser does not recognise this file.' ].
    result := parser parse: input.
    ^ result
]

{ #category : #documentation }
GtWowSpecInputParser class >> gtDescription [
    ^ 'Recognises WOW SPEC markdown files (e.g. workspace/wow/SPEC.md) and provides a domain-specific parsed representation.'
]

{ #category : #registration }
GtWowSpecInputParser class >> registerOn: aParserRegistry [
    self flag: #todo.
    "Example pattern to adapt once you know the real registry API:
        aParserRegistry addParser: self withPriority: 0.9"
]
