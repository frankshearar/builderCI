"Initialize Image Building"
| gitPath |
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

(Deprecation respondsTo: #raiseWarning:)
  ifTrue: [ Deprecation raiseWarning: false ].

"Bootstrap Metacello-Base to simulate conditions when it's included in base"
FileDirectory default 
  fileNamed: 'Metacello-Base.st'
  do: [:fileStream | fileStream fileIn ].

"explicitly load OSProcess to avoid SqueakSource flakiness:
     https://github.com/dalehenrich/builderCI/issues/6"
(Smalltalk at: #ConfigurationOf) ensureMetacello: #('bootstrap'). "loads Gofer"
(Smalltalk at: #Gofer) new
  repository: (MCDirectoryRepository new directory: 
        (FileDirectory default directoryNamed:'mcz'));
  package: 'OSProcess';
  load.

