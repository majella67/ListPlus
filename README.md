# ListPlus

ListPlus is a collection of classes that adds filters to simple lists and columned lists in Glamorous Toolkit.
This allows you to query data with predefined filters.

Included 

      BrFileSelectorPlus - a file selector with file name search
      
      Hooks to creates views with lists of filters
      
      A playground to help you with exploring ListPlus
## Installation

```st
Metacello new
	repository: 'github://majella67/ListPlus:main/src';
	baseline: 'ListPlus';
	load
```

## Load Lepiter
				
After installing with Metacello, you will be able to execute

```st
#BaselineOfListPlus asClass loadLepiter
```

