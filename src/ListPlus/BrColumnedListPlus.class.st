Class {
	#name : #BrColumnedListPlus,
	#superclass : #BrColumnedList,
	#instVars : [
		'filtersElement',
		'list',
		'elements',
		'originalItems'
	],
	#category : #ListPlus
}

{ #category : #accessing }
BrColumnedListPlus >> currentItems [
	| filteredItems |
	filteredItems := self items.
	^ filtersElement currentFilters
		ifEmpty: [ self items ]
		ifNotEmpty: [ filtersElement currentFilters
				do: [ :aF | filteredItems := aF key creationBlock cull: filteredItems cull: aF value ].
			filteredItems ]
]

{ #category : #accessing }
BrColumnedListPlus >> elements [
	^ elements ifNil: [ elements := OrderedCollection new ] ifNotNil: [ elements ]
]

{ #category : #accessing }
BrColumnedListPlus >> filterDescriptors: aGtFilterDescriptorList [
	filtersElement descriptors: aGtFilterDescriptorList
]

{ #category : #accessing }
BrColumnedListPlus >> initialize [
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
BrColumnedListPlus >> list [
	^ list ifNil: [ list := BrColumnedList new ] ifNotNil: [ list ]
]

{ #category : #accessing }
BrColumnedListPlus >> originalItems: aCollection [
	originalItems := aCollection
]

{ #category : #accessing }
BrColumnedListPlus >> perspectiveButtonElements [
	| pButton |
	pButton := BrSimpleListPlusPerspectiveButton new
			list: self;
			id: #perspectiveButton.
	^ {pButton.
		pButton overlay}
]
