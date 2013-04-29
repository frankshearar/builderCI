| gitPath |
Transcript cr; show: 'travis---->clientGCI.st'.

gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

"Sample clientGCI.st file:

  Edit the Metacello api and test harness invocation used to launch GCI tests
  using the correct configuration name and repository 
  location.

Use gci_travis.yml as template .travis.yml for gci tests"

Metacello new
  baseline: '<projectName>';
  repository: 'filetree://', gitPath, '/<projectName>/<path to filetree packages root>';
  get.

Metacello new
  baseline: '<projectName>';
  repository: 'filetree://', gitPath, '/<projectName>/<path to filetree packages root>';
  load: 'TravisCI'.

"Run the tests"
TravisCIHarness
  value: #( '<full baseline name>' )
  value: 'TravisCISuccess.txt' 
  value: 'TravisCIFailure.txt'.

