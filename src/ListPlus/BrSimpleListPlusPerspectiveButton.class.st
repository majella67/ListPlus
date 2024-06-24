Class {
	#name : #BrSimpleListPlusPerspectiveButton,
	#superclass : #BrButton,
	#instVars : [
		'overlay',
		'aList',
		'listAptitudes'
	],
	#category : #ListPlus
}

{ #category : #accessing }
BrSimpleListPlusPerspectiveButton >> aptitiudes [
	^ listAptitudes
]

{ #category : #accessing }
BrSimpleListPlusPerspectiveButton >> initialize [
	| sButton1 aWithDropdownAptitude |
	super initialize.

	self
		aptitude: BrGlamorousButtonWithIconCircularAptitude;
		icon: BrGlamorousIcons settings;
		label: 'Modify perspective';
		constraintsDo: [ :c | c ignoreByLayout ].
	overlay := BlOverlayElement on: self.
	sButton1 := BrButton new
			aptitude: BrGlamorousButtonWithIconCircularAptitude;
			icon: BrGlamorousIcons settings;
			label: 'Modify perspective'.
	aWithDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ sButton1 ]
			content: [ BrSimpleList new
					items: (self aptitiudes
							select: [ :c | 
								({BrSimpleListPlusFoldAptitude} collect: [ :aClass | c isKindOf: aClass ])
									isNotEmpty ]);
					itemStencil: [ BrHorizontalPane new
							margin: (BlInsets
									top: 3
									bottom: 3
									left: 10
									right: 10);
							addChildren: {BrCheckbox new
										aptitude: BrGlamorousCheckboxAptitude;
										margin: (BlInsets right: 5).
									BrLabel new
										margin: (BlInsets right: 5);
										aptitude: BrGlamorousLabelAptitude
												+ (BrStyleCommonAptitude new
														selected: [ :aStyle | aStyle background: BrGlamorousColors selectedListItemColor ])} ];
					itemDataBinder: [ :eachElement :eachAptitude :eachIndex | 
						eachElement children second text: eachAptitude label.
						eachElement children first
							checked: (aList aptitude children includes: eachAptitude).
						eachElement children first
							whenCheckedDo: [ :cEvent | 
								(aList aptitude children includes: eachAptitude)
									ifFalse: [ aList addAptitude: eachAptitude ] ];
							whenUncheckedDo: [ :cEvent | aList removeAptitude: eachAptitude ].
						eachElement fitContent ] ]
			aptitudeDo: [ :aDropdownLook | aDropdownLook cornerRadius: 5 ].

	self aptitude: self aptitude + aWithDropdownAptitude
]

{ #category : #accessing }
BrSimpleListPlusPerspectiveButton >> list: anObject [
	aList := anObject.

	aList
		ifNotNil: [ listAptitudes := aList aptitude children
					select: [ :c | 
						({BrSimpleListPlusFoldAptitude} select: [ :aClass | c isKindOf: aClass ])
							isNotEmpty ].
			aList
				addEventHandlerOn: BlElementExtentChangedEvent
				do: [ self relocate: (aList extent x - 35) @ 5 ] ]
]

{ #category : #accessing }
BrSimpleListPlusPerspectiveButton >> listPlus [
	^ aList
]

{ #category : #accessing }
BrSimpleListPlusPerspectiveButton >> overlay [
	^ overlay
]
