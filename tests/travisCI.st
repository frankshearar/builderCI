"Load and run tests to be performed by TravisCI"
| metacelloPath |

"Load FileTree Tests"
Gofer new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
        (FileDirectory default directoryNamed: 'git_cache/filetree/tests/repository'));
    package: 'MonticelloFileTree-Tests';
    load.

"Early exit"
true ifTrue: [ ^self ].

"Load Metacello Tests"
metacelloPath := (FileDirectory default directoryNamed: 'git_cache/metacello-work/repository') fullName.
Metacello new
    baseline: 'Metacello';
    repository: 'filetree://' , metacelloPath;
    silently;
    load: 'Tests'.

