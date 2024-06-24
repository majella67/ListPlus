Extension { #name : #GtPhlowProtoView }

{ #category : #'*ListPlus' }
GtPhlowProtoView >> columnedListPlus [
	^ GtPhlowColumnedListPlusView new
		originalView: self;
		definingMethod: (GtPhlowDefiningMethodsCollector forContext: thisContext) collect
]

{ #category : #'*ListPlus' }
GtPhlowProtoView >> listPlus [
	^ GtPhlowListPlusView new
		originalView: self;
		definingMethod: (GtPhlowDefiningMethodsCollector new
				stack: thisContext stack;
				collect)
]
