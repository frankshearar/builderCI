"Initialize Image for batch testing with Metacello"

"Tie Transcript to stdout"
FileDirectory default 
  fileNamed: 'FileStream-show.st'
  do: [:fileStream | fileStream fileIn ].
FileStream stdout file lineEndConvention: #'lf'.
(Smalltalk associationAt: #Transcript) value: FileStream stdout.
Transcript cr; show: 'travis---->before.st'.

(Deprecation respondsTo: #raiseWarning:)
  ifTrue: [ Deprecation raiseWarning: false ].

"Bootstrap Metacello-Base to simulate conditions when it's included in base"
FileDirectory default 
  fileNamed: 'Metacello-Base.st'
  do: [:fileStream | fileStream fileIn ].

"explicitly load OSProcess to avoid SqueakSource flakiness:
     https://github.com/dalehenrich/builderCI/issues/6"
(Smalltalk at: #ConfigurationOf) 
  ensureGoferVersion: 'Gofer-Core-lr.115' 
  repositoryUrl: 'http://seaside.gemstone.com/ss/metacello'.
(Smalltalk at: #Gofer) new
  repository: (MCDirectoryRepository new directory: 
        (FileDirectory default directoryNamed:'mcz'));
  package: 'OSProcess';
  load.
