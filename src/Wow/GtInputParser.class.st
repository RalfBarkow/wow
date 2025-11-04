Class {
	#name : #GtInputParser,
	#superclass : #Object,
	#category : #'Wow-Input'
}

{ #category : #documentation }
GtInputParser class >> gtDescription [
	^ 'Abstract input parser. Subclasses implement #canHandle: and #parse: for a given kind of input.'
]

{ #category : #matching }
GtInputParser >> canHandle: aGtInput [
	"Default: do not handle anything. Subclasses override."

	^ false
]

{ #category : #parsing }
GtInputParser >> parse: aGtInput [
	"Default: return the input unchanged. Subclasses override."

	^ aGtInput
]
