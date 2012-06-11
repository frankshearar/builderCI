"Load current version of FileTree"
| gitPath |
Transcript cr; show: 'travis---->filetree.st'.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

Metacello new
  baseline: 'FileTree';
  repository: 'filetree://', gitPath, '/filetree/repository';
  load.

