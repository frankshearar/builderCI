"Initialize Image Building"
(Deprecation respondsTo: #raiseWarning:)
  ifTrue: [ Deprecation raiseWarning: false ].

"Bootstrap Base Metacello - see https://github.com/dalehenrich/builderCI/issues/6"
FileDirectory default 
  fileNamed: 'Metacello-Base.st'
  do: [:fileStream | fileStream fileIn ].


