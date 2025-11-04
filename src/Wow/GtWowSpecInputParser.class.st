Class {
	#name : #GtWowSpecInputParser,
	#superclass : #AnObsoleteGtInputParser,
	#category : #'Wow-Input'
}

{ #category : #matching }
GtWowSpecInputParser class >> canHandle: aGtInput [
	^ self new canHandle: aGtInput
]

{ #category : #examples }
GtWowSpecInputParser class >> exampleEvaluateWowSpecOnHome [
	<gtExample>
	| input parser result |

	input := GtWowInputFile onWowSpec.
	parser := self new.

	(parser canHandle: input)
		ifFalse: [ self error: 'GtWowSpecInputParser is expected to recognise SPEC.md but did not.' ].

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

{ #category : #matching }
GtWowSpecInputParser >> canHandle: aGtInput [
	"Answer whether this parser can handle the given input.
	For now: the one canonical WOW SPEC.md file."

	| fileRef |
	(aGtInput respondsTo: #fileReference) ifFalse: [ ^ false ].
	fileRef := aGtInput fileReference.
	fileRef ifNil: [ ^ false ].

	^ fileRef = WowCodebaseLocator wowSpecMarkdown
]

{ #category : #parsing }
GtWowSpecInputParser >> parse: aGtInput [
	"Parse the WOW SPEC.md input into a simple domain dictionary.
	For now we:
	  - read the raw text
	  - take the first heading as a quick summary
	  - tag it as #wowSpec."

	| fileRef contents firstHeading |

	(aGtInput respondsTo: #fileReference) ifFalse: [
		self error: 'GtWowSpecInputParser expects an input with #fileReference' ].

	fileRef := aGtInput fileReference.
	fileRef ifNil: [
		self error: 'GtWowSpecInputParser requires a non-nil fileReference' ].

	contents := fileRef readStreamDo: [ :str | str upToEnd ].

	firstHeading := (contents lines
		detect: [ :each | each beginsWith: '#' ]
		ifNone: [ '' ]).

	^ {
		#type          -> #wowSpec.
		#fileReference -> fileRef.
		#firstHeading  -> firstHeading.
		#rawText       -> contents
	} asDictionary
]
