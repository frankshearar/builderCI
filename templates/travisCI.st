"Sample travisCI.st file:

  Edit the Metacello api and test harness invocation
  using the correct configuration name and repository 
  location"

| gitCacheName gitPath |
gitCacheName := 'git_cache'.
gitPath := (Smalltalk at: #FileDirectory ifAbsent: [])
  ifNil: [ 
    "Pharo-2.x"
    ((Smalltalk at: #FileSystem) workingDirectory / gitCacheName) pathString]
  ifNotNil: [:fileDirectoryClass |
    "Pharo-1.x"
    (fileDirectoryClass default directoryNamed: gitCacheName) fullName ].


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

