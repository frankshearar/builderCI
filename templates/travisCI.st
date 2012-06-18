"Sample travisCI.st file:

  Edit the Metacello api and test harness invocation
  using the correct configuration name and repository 
  location"

| gitPath |
false 
  ifTrue: [ "enable to tie Transcript to stdout for debugging script"
    FileDirectory default 
      fileNamed: 'FileStream-show.st'
      do: [:fileStream | fileStream fileIn ].
    (Smalltalk associationAt: #Transcript) value: FileStream stdout.
    Transcript cr; show: 'Loading MyProject....'.].


gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

"Use Metacello to load your project and tests"
Metacello new
  configuration: 'MyProject';
  repository: 'filetree://', gitPath, '/MyProject/repository';
  load: 'Tests'.

"Run the tests"
TravisCIHarness
  value: #( 'ConfigurationOfMyProject' )
  value: 'TravisCISuccess.txt' 
  value: 'TravisCIFailure.txt'.

