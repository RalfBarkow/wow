Class {
	#name : #GtWowInputFile,
	#superclass : #GtInputFile,
	#category : #'Wow-Input'
}

{ #category : #examples }
GtWowInputFile class >> exampleWowSpecInput [
	<gtExample>
	^ self onWowSpec
]

{ #category : #'instance creation' }
GtWowInputFile class >> onWowSpec [
	"GtWowInputFile wrapping SPEC.md."
	^ self onFileReference: self wowSpecFileReference
]

{ #category : #paths }
GtWowInputFile class >> wowSpecFileReference [
	"FileReference for the WOW SPEC.md."
	^ WowCodebaseLocator wowSpecMarkdown
]
