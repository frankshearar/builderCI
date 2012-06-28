"Initialize Image for batch testing with Metacello"

"Unconditionally route Transcript output to TravisTranscript.txt ... projects can choose whether or not to display"
FileDirectory default 
  fileNamed: 'FileStream-show.st'
  do: [:fileStream | fileStream fileIn ].
Smalltalk at: #OLDTranscript put: Transcript.
(Smalltalk associationAt: #Transcript) value: (FileDirectory default fileNamed: 'TravisTransript.txt').
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
