"Load current version of Metacello"
| gitPath |
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

Metacello new
  baseline: 'Monticello';
  repository: 'filetree://', gitPath, '/metacello-work/repository';
  load: 'bootstrap'.

