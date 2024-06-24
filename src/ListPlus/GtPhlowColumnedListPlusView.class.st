Class {
	#name : #GtPhlowColumnedListPlusView,
	#superclass : #GtPhlowColumnedListView,
	#instVars : [
		'aptitudes',
		'descriptors',
		'listPlus'
	],
	#category : #ListPlus
}

{ #category : #accessing }
GtPhlowColumnedListPlusView >> addAptitude: anAptitude [
	aptitudes ifNil: [ aptitudes := OrderedCollection new ].
	aptitudes add: anAptitude
]

{ #category : #accessing }
GtPhlowColumnedListPlusView >> asElementDo: aBlock [
	"it evaluates aBlock if the view should have content"

	| aContainer header itemsProvider |
	itemsProvider := self
			itemsProviderOnExceptionErrorElement: [ :anElement | ^ aBlock value: anElement ].
	listPlus := self columnedListClass new itemsProvider: itemsProvider.
	listPlus items: listPlus items.
	listPlus filterDescriptors: self descriptors.
	listPlus
		id: GtPhlowColumnedListContainerId;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].


	self hasMultipleSelection
		ifTrue: [ listPlus aptitude: BrColumnedMultiListAptitude ].

	listPlus 
		id: GtPhlowColumnedListId;
		itemsProvider: itemsProvider;
		addEventHandler: (GtPhlowListToSelectHandler new transformation: self transformation);
		rowStencil: self newDecoratedItemStencil.

	rowDataBinder ifNotNil: [ listPlus list rowDataBinder: rowDataBinder ].

	self buildColumnsInList: listPlus.
	header := self buildHeaderForItems: listPlus columns.	"Setup  filtersElement"

	aptitudes ifNotNil: [ aptitudes do: [ :a | listPlus addAptitude: a ] ].
	aContainer := self elementClass new.
	aContainer layout: BlLinearLayout vertical.
	aContainer
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		addChildren: {listPlus addChild: header after: (listPlus childNamed: #foldContainer)}.
	horizontalScrollingEnabled
		ifTrue: [ | aScrollableElement |
			aContainer constraintsDo: [ :c | c horizontal fitContent ].
			listPlus hFitContent.
			header constraintsDo: [ :c | c horizontal fitContent ].

			aScrollableElement := BrScrollPane new
					aptitude: BrScrollPaneAptitude + BrGlamorousWithHorizontalScrollbarAptitude;
					matchParent;
					content: aContainer;
					margin: (BlInsets bottom: 2).

			aContainer := aScrollableElement ].

	self beViewElement: aContainer.

	^ aBlock value: aContainer
]

{ #category : #accessing }
GtPhlowColumnedListPlusView >> columnedListClass [
	^ BrColumnedListPlus
]

{ #category : #accessing }
GtPhlowColumnedListPlusView >> currentItems [
	^ listPlus currentItems
]

{ #category : #accessing }
GtPhlowColumnedListPlusView >> descriptors [
	^ descriptors ifNil: [ OrderedCollection new ] ifNotNil: [ descriptors ]
]

{ #category : #accessing }
GtPhlowColumnedListPlusView >> elementClass [
	^ BlElement
]

{ #category : #accessing }
GtPhlowColumnedListPlusView >> filterDescriptors: aGtFilterDescriptorList [
	descriptors := aGtFilterDescriptorList
]

{ #category : #accessing }
GtPhlowColumnedListPlusView >> listPlus [
	^ listPlus
]

{ #category : #accessing }
GtPhlowColumnedListPlusView >> originalItems: aCollection [
	listPlus ifNil: [ listPlus := self columnedListClass new ].
	listPlus originalItems: aCollection
]
