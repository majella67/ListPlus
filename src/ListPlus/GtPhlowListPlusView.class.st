Class {
	#name : #GtPhlowListPlusView,
	#superclass : #GtPhlowListView,
	#instVars : [
		'aptitudes',
		'descriptors',
		'listPlus'
	],
	#category : #ListPlus
}

{ #category : #accessing }
GtPhlowListPlusView >> addAptitude: anAptitude [
	aptitudes ifNil: [ aptitudes := OrderedCollection new ].
	aptitudes add: anAptitude
]

{ #category : #accessing }
GtPhlowListPlusView >> asElementDo: aBlock [
	| itemsProvider |
	itemsProvider := self
			itemsProviderOnExceptionErrorElement: [ :anElement | ^ aBlock value: anElement ].
	listPlus := self elementClass new itemsProvider: itemsProvider.
	listPlus items: listPlus items.
	listPlus originalItems: listPlus items.
	listPlus filterDescriptors: self descriptors.
	listPlus
		addEventHandler: (GtPhlowListToSelectHandler new transformation: self transformation).
	aptitudes do: [ :a | listPlus addAptitude: a ].
	listPlus
		matchParent;
		constraintsDo: [ :c | c padding: (BlInsets top: 10 bottom: 10) ].
	listPlus
		itemStencil: self newDecoratedItemStencil;
		itemDataBinder: self newDecoratedItemDataBinder;
		itemType: self newDecoratedItemTypeStencil.
	itemId ifNotNil: [ listPlus itemId: itemId ].
	self hasMultipleSelection ifTrue: [ listPlus aptitude: BrMultiListAptitude ].
	self beViewElement: listPlus.
	^ aBlock value: listPlus
]

{ #category : #accessing }
GtPhlowListPlusView >> descriptors [
	^ descriptors ifNil: [ OrderedCollection new ] ifNotNil: [ descriptors ]
]

{ #category : #accessing }
GtPhlowListPlusView >> elementClass [
	^ BrSimpleListPlus
]

{ #category : #accessing }
GtPhlowListPlusView >> filterDescriptors: aGtFilterDescriptorList [
	descriptors := aGtFilterDescriptorList
]

{ #category : #accessing }
GtPhlowListPlusView >> listPlus [
	^ listPlus
]

{ #category : #accessing }
GtPhlowListPlusView >> originalItems: aCollection [
	self listPlus originalItems: aCollection
]
