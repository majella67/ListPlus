Class {
	#name : #BrSimpleListPlusFoldAptitude,
	#superclass : #BrAptitude,
	#instVars : [
		'foldBlock',
		'foldLabel',
		'stream'
	],
	#category : #ListPlus
}

{ #category : #accessing }
BrSimpleListPlusFoldAptitude class >> allClassesAverageExample [
	<gtExample>
	^ self
		fold: [ :aListOfItems | 
			((aListOfItems inject: 0 into: [ :all :each | all + each linesOfCode ])
				/ aListOfItems size) asFloat printShowingDecimalPlaces: 2 ]
		foldLabel: 'Lines of code avg : '
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude class >> allClassesCountExample [
	<gtExample>
	^ self
		fold: [ :aListOfItems | aListOfItems inject: 0 into: [ :all :each | all + each linesOfCode ] ]
		foldLabel: 'Lines of code sum : '
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude class >> fold: foldBlock foldLabel: aTextOrString [
	^ self new
		foldBlock: foldBlock;
		foldLabel: aTextOrString
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude class >> simpleCount [
	^ self fold: [ :aListOfItems | aListOfItems size ] foldLabel: 'Count : '
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude >> buildElement [
	| foldContent content |
	foldContent := BrLabel new
			aptitude: BrGlamorousLabelAptitude new glamorousRegularSmallSize;
			id: #foldContent.

	content := BrHorizontalPane new
			hMatchParent;
			alignCenterLeft;
			vFitContent;
			padding: (BlInsets all: 5);
			cellSpacing: 3;
			addChildren: {BrButton new
						id: #refreshButton;
						label: 'Refresh';
						icon: BrGlamorousVectorIcons refresh;
						aptitude: BrGlamorousButtonWithIconCircularAptitude;
						action: [ self refreshContent: content ];
						size: 12 @ 12.
					foldContent text: 'Calculating....'}.
	^ content
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude >> foldBlock [
	^ foldBlock
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude >> foldBlock: aBlock [
	foldBlock := aBlock
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude >> foldContentText [
	^ (self label asString
		, (self foldBlock value: self widget items) asString) asRopedText bold
		fontSize: 12
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude >> foldLabel: anObject [
	foldLabel := anObject
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude >> initialize [
	| foldElement |
	super initialize.
	self
		addChange: (BrLookChange new
				up: [ :e | 
					(e widget childNamed: #foldContainer)
						addChildFirst: (foldElement := self buildElement).
					(e widget childNamed: #perspectiveButton) list: e widget.
					self refreshContent: foldElement ];
				down: [ :e | (e widget childNamed: #foldContainer) removeChild: foldElement ])
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude >> label [
	^ foldLabel
]

{ #category : #accessing }
BrSimpleListPlusFoldAptitude >> refreshContent: aContainer [
	| foldContent refreshButton |
	foldContent := aContainer childNamed: #foldContent.
	refreshButton := aContainer childNamed: #refreshButton.
	refreshButton disable.
	foldContent text: 'Calculating....'.
	[ foldContent text: self foldContentText.
	refreshButton enable ] forkAt: 20
]
