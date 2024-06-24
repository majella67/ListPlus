Class {
	#name : #BrSimpleListPlus,
	#superclass : #BrSimpleList,
	#instVars : [
		'elements',
		'list',
		'itemDescriptionBlock',
		'filtersElement',
		'originalItems'
	],
	#category : #ListPlus
}

{ #category : #accessing }
BrSimpleListPlus class >> barebones [
	<gtExample>
	^ self new matchParent
]

{ #category : #accessing }
BrSimpleListPlus class >> simple [
	<gtExample>
	| aSimple |
	aSimple := self new.
	aSimple
		filterDescriptors: {GtFilterDescriptor new
					creator: [ :aList :aString | 
						aList
							select: [ :item | item name asLowercase includesSubstring: aString asLowercase ] ];
					named: 'Class';
					order: 1;
					emptyDefaultValue: ''.
				GtFilterDescriptor new
					creator: [ :aList :aString | 
						aList
							select: [ :item | item package name asLowercase includesSubstring: aString asLowercase ] ];
					named: 'Package';
					order: 1;
					emptyDefaultValue: ''};
		items: (SystemNavigation new allClasses sorted: [ :a :b | a name < b name ]);
		originalItems: aSimple items.
	aSimple
		itemStencil: [ | anItem |
			anItem := BrLabel new
					aptitude: BrGlamorousLabelAptitude new
							+ (BrStyleCommonAptitude new
									selected: [ :aStyle | aStyle background: BrGlamorousColors selectedListItemColor ]);
					padding: (BlInsets all: 5) ];
		itemDataBinder: [ :eachLabel :eachClass :eachIndex | eachLabel text: eachClass name ].
	aSimple
		addAptitude: BrSimpleListPlusFoldAptitude allClassesCountExample;
		addAptitude: BrSimpleListPlusFoldAptitude allClassesAverageExample;
		border: Color veryLightGray asBlBorder.
	^ aSimple matchParent removeFromParent
]

{ #category : #accessing }
BrSimpleListPlus >> currentItems [
	| filteredItems |
	filteredItems := self items.
	^ filtersElement currentFilters
		ifEmpty: [ self items ]
		ifNotEmpty: [ filtersElement currentFilters
				do: [ :aF | filteredItems := aF key creationBlock cull: filteredItems cull: aF value ].
			filteredItems ]
]

{ #category : #accessing }
BrSimpleListPlus >> elements [
	^ elements ifNil: [ elements := OrderedCollection new ] ifNotNil: [ elements ]
]

{ #category : #accessing }
BrSimpleListPlus >> elements: anObject [
	elements := anObject
]

{ #category : #accessing }
BrSimpleListPlus >> filterDescriptors: aGtFilterDescriptorList [
	filtersElement
		clearFilters;
		descriptors: aGtFilterDescriptorList
]

{ #category : #accessing }
BrSimpleListPlus >> filtersElement [
	^ filtersElement
]

{ #category : #accessing }
BrSimpleListPlus >> initialize [
	super initialize.
	filtersElement := GtFiltersElement new id: #filterElements.
	originalItems := OrderedCollection new.
	filtersElement
		when: GtFiltersChangedEvent
		do: [ :event | 
			| listItems |
			listItems := originalItems.
			event currentTarget
				filtersDo: [ :aDescriptor :aValue | 
					self items: (aDescriptor creationBlock cull: listItems cull: aValue).
					listItems := self items ] ].
	self
		addChildFirst: filtersElement;
		addChild: (BrHorizontalPane new
					id: #foldContainer;
					hMatchParent;
					vFitContent;
					addChildren: self elements)
			after: (self childNamed: #filterElements);
		addChildren: self perspectiveButtonElements
]

{ #category : #accessing }
BrSimpleListPlus >> itemDescriptionBlock [
	^ itemDescriptionBlock
]

{ #category : #accessing }
BrSimpleListPlus >> itemDescriptionBlock: anObject [
	itemDescriptionBlock := anObject
]

{ #category : #accessing }
BrSimpleListPlus >> items: aCollection [
	super items: aCollection.
]

{ #category : #accessing }
BrSimpleListPlus >> originalItems [
	^ originalItems
]

{ #category : #accessing }
BrSimpleListPlus >> originalItems: anObject [
	originalItems := anObject
]

{ #category : #accessing }
BrSimpleListPlus >> perspectiveButtonElements [
	| pButton |
	pButton := BrSimpleListPlusPerspectiveButton new
			list: self;
			id: #perspectiveButton.
	^ {pButton.
		pButton overlay}
]
