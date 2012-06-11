"Load and run tests to be performed by TravisCI"
| gitPath |
Transcript cr; show: 'travis---->travisCI.st'.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.	

"load the file tree tests"
Metacello new
    baseline: 'FileTreeTests';
    repository: 'filetree://' , gitPath , '/filetree/tests/repository';
    load.	

"Run the tests"
Transcript cr; show: 'travis---->TravisCIHarness'.
TravisCIHarness
  value: #( 'FileTreeTests' )
  value: 'TravisCISuccess.txt' 
  value: 'TravisCIFailure.txt'.


