"Load current version of Metacello"
| gitPath |
Transcript cr; show: 'travis---->metacello.st'.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

Metacello new
  baseline: 'Metacello';
  repository: 'filetree://', gitPath, '/metacello-work/repository';
  load: 'batch'.

