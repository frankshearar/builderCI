"Load current version of FileTree"
| gitPath |
Transcript cr; show: 'travis---->filetree.st'.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

Transcript cr; show: 'ensure Metacello'.
ConfigurationOf ensureMetacello.

Transcript cr; show: 'PATH: filetree://', gitPath, '/filetree/repository'.
Transcript cr; show: (FileDirectory default directoryNamed:
'git_cache/filetree/repository/BaselineOfFileTree.package') exists.
Metacello new
  baseline: 'FileTree';
  repository: 'filetree://', gitPath, '/filetree/repository';
  load.

