"Initialize Image Building"
(Deprecation respondsTo: #raiseWarning:)
  ifTrue: [ Deprecation raiseWarning: false ].

"Bootstrap Base Metacello"
FileDirectory default 
  fileNamed: 'Metacello-Base.st'
  do: [:fileStream | fileStream fileIn ].


