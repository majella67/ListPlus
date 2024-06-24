Class {
	#name : #BrFileSelectorPlus,
	#superclass : #BrFileSelector,
	#category : #ListPlus
}

{ #category : #accessing }
BrFileSelectorPlus >> createTable [
	| aTable |
	aTable := BrColumnedListPlusM new.
	aTable
		rowStencil: BrGlamorousColumnedListSelectableRowElementStencilBuilder new;
		padding: (BlInsets top: 5);
		matchParent.	"icon column"
	aTable
		filterDescriptors: {GtFilterDescriptor new
					creator: [ :aList :aFilterString | 
						aList
							select: [ :anItem | 
								anItem basename asString asLowercase
									includesSubstring: aFilterString asLowercase ] ];
					named: 'Name';
					order: 1;
					emptyDefaultValue: ''};
		addAptitude: BrSimpleListPlusMFoldAptitude simpleCount.
	aTable column
		title: 'Icon' translated;
		width: 40;
		stencil: [ :each | 
			each isDirectory
				ifTrue: [ BrGlamorousIcons folder ]
				ifFalse: [ BrGlamorousIcons file ] ].
	aTable column
		title: 'Name' translated;
		matchParent;
		cellStencil: [ :each | BrLabel new aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem | 
			aLabel
				text: ((folder isChildOf: eachItem)
						ifTrue: [ '..' ]
						ifFalse: [ eachItem basename asString ]) ].	"width: 200;"
	aTable column
		title: 'Size' translated;
		width: 100;
		cellStencil: [ :each | BrLabel new aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem | 
			aLabel
				text: (eachItem isDirectory
						ifTrue: [ '-' ]
						ifFalse: [ [ eachItem humanReadableSize ]
								on: FileException
								do: [ :anException | anException return: '? B' ] ]) ].
	aTable column
		title: 'Modified' translated;
		width: 100;
		cellStencil: [ :each | BrLabel new aptitude: BrGlamorousLabelAptitude new ];
		dataBinder: [ :aLabel :eachItem | 
			aLabel
				text: ([ String
						streamContents: [ :s | 
							eachItem creationTime printYMDOn: s.
							s nextPut: Character space.
							eachItem creationTime printHMSOn: s ] ]
						on: FileException
						do: [ :anException | anException return: '?' ]) ].

	aTable list
		when: BrSelectionDoubleClicked
		do: [ :anEvent | 
			anEvent selection
				ifNotEmpty: [ :theIndices | 
					| aWidgetElement selectedObject |
					aWidgetElement := anEvent currentTarget.
					selectedObject := aWidgetElement viewModel itemAt: theIndices first.
					self folder: selectedObject ] ].
	aTable list when: BrSelectionChanged do: [ :anEvent | okButton enable ].
	aTable addAptitude: BrColumnedListHeaderAptitude.

	^ aTable
]

{ #category : #accessing }
BrFileSelectorPlus >> executeAction [
	"Execute the receiver's load action"

	| selectedIndices |
	selectedIndices := table  list selectedIndices.
	selectedIndices ifEmpty: [ ^ self okAction cull: folder cull: okButton ].
	^ self okAction cull: ( table currentItems  at: selectedIndices first) cull: okButton
]
