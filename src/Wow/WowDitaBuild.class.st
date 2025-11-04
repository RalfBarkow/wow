Class {
	#name : #WowDitaBuild,
	#superclass : #Object,
	#category : #'Wow-Dita'
}

{ #category : #building }
WowDitaBuild class >> buildPositionPaperPdf [
	"Build the WOW position paper PDF with DITA-OT.
	 Uses WowCodebaseLocator for all paths."

	| inputMap outputDir builder output |
	inputMap := WowCodebaseLocator wowPositionPaperDitamap.
	outputDir := WowCodebaseLocator wowDitaBuildOutputDir.
	outputDir ensureCreateDirectory.

	builder := GtExternalProcessBuilder new.
	output := builder
			command: 'dita';
			arg: '-i';
			arg: inputMap fullName;
			arg: '-f';
			arg: 'pdf';
			arg: '-o';
			arg: outputDir fullName;
			output.

	^ output
]
