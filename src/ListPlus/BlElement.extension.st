Extension { #name : #BlElement }

{ #category : #'*ListPlus' }
BlElement >> gtFilteredChildrenShortcutsFor: aView [
	<gtView>
	^ aView columnedListPlus
		title: 'Filtered Children shortcuts' translated;
		priority: 11;
		filterDescriptors: {GtFilterDescriptor new
					creator: [ :aList :aFilterString | 
						aList
							select: [ :each | 
								(each value gtDisplayString , each value combination gtDisplayString
									, each key gtDisplayString) asLowercase
									includesSubstring: aFilterString asLowercase ] ];
					named: 'Name';
					order: 1;
					emptyDefaultValue: ''};
		items: [ | all |
			all := OrderedCollection new.
			self
				withAllParentsDo: [ :el | 
					all
						addAll: ((el shortcuts collect: [ :s | el -> s ])
								sorted: [ :a :b | a value gtDisplayString < b value gtDisplayString ]) ].
			all ];
		originalItems: [ | all |
			all := OrderedCollection new.
			self
				withAllParentsDo: [ :el | 
					all
						addAll: ((el shortcuts collect: [ :s | el -> s ])
								sorted: [ :a :b | a value gtDisplayString < b value gtDisplayString ]) ].
			all ] value;
		column: 'Name'
			text: [ :each | each value name ifNil: [ each value gtDisplayString ] ];
		column: 'Combination'
			text: [ :each | each value combination gtDisplayString ];
		column: 'Element'
			icon: [ :each | 
				each key = self
					ifTrue: [ BlElement new size: 1 @ 1 ]
					ifFalse: [ BrButton new
							beSmallSize;
							label: each key gtDisplayString;
							aptitude: (BrGlamorousButtonLabelAptitude new
									hoveredColor: Color black;
									pressedColor: Color black)
									+ (BrGlamorousButtonRectangularAptitude
											paddingScale: 0.8
											heightScale: 0.85
											cornerRadius: 3)
									+ (BrStyleCommonAptitude new
											default: [ :s | s background: (Color gray alpha: 0.1) ];
											hovered: [ :s | s background: (Color gray alpha: 0.2) ];
											pressed: [ :s | s background: (Color gray alpha: 0.3) ]);
							action: [ :aButtonElement | aButtonElement phlow spawnObject: each key ] ] ]
			width: 200;
		send: [ :each | each value ]
]
