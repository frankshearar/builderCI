"Load current version of Metacello"
| gitPath |
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

Metacello new
  baseline: 'Metacello';
  repository: 'filetree://', gitPath, '/metacello-work/repository';
  load: 'batch'.

