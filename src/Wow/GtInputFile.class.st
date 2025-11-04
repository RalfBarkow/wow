Class {
	#name : #GtInputFile,
	#superclass : #Object,
	#instVars : [
		'fileReference'
	],
	#category : #'Wow-Input-Compat'
}

{ #category : #'instance creation' }
GtInputFile class >> onFileReference: aFileReference [
	^ self new
		fileReference: aFileReference;
		yourself
]

{ #category : #accessing }
GtInputFile >> fileReference [
	^ fileReference
]

{ #category : #accessing }
GtInputFile >> fileReference: aFileReference [
	fileReference := aFileReference
]
