"Load and run tests to be performed by TravisCI"
| filetreeTestPath metacelloPath |
filetreeTestPath := '/home/vagrant/filetree/tests/repository'.
metacelloPath := '/home/vagrant/metacello-work/repository'.

"Load FileTree Tests"
Gofer new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
                    (FileDirectory on: filetreeTestPath));
    package: 'MonticelloFileTree-Tests';
    load.

"Early exit"
true ifTrue: [ ^self ].

"Load Metacello Tests"
Metacello new
    baseline: 'Metacello';
    repository: 'filetree://' , metacelloPath;
    silently;
    load: 'Tests'.

