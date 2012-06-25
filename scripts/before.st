"Initialize Image for batch testing with Metacello"

false 
  ifTrue: [ "Tie Transcript to stdout"
    FileDirectory default 
      fileNamed: 'FileStream-show.st'
      do: [:fileStream | fileStream fileIn ].
    (Smalltalk associationAt: #Transcript) value: FileStream stdout ].
Transcript cr; show: 'travis---->before.st'.

(Deprecation respondsTo: #raiseWarning:)
  ifTrue: [ Deprecation raiseWarning: false ].

"Bootstrap Metacello-Base to simulate conditions when it's included in base images"
FileDirectory default 
  fileNamed: 'Metacello-Base.st'
  do: [:fileStream | fileStream fileIn ].

"ensure that Gofer is available on Squeak"
(Smalltalk at: #ConfigurationOf) 
  ensureGoferVersion: 'Gofer-Core-lr.115' 
  repositoryUrl: 'http://seaside.gemstone.com/ss/metacello'.
