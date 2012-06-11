"Load current version of FileTree"
| gitPath |

"bootstrap latest versio, for now"
(Smalltalk at: #Gofer) new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
        (FileDirectory default directoryNamed: 'git_cache/filetree/repository'));
    package: 'MonticelloFileTree-Core';
    load.

"now do proper load"
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.
Metacello new
  baseline: 'FileTree';
  repository: 'filetree://', gitPath, '/filetree/repository';
  load.

