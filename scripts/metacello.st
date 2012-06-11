"Bootstrap OSProcess - insulate from SqueakSource flakiness for now"
(Smalltalk at: #Gofer) new
  repository: (MCDirectoryRepository new directory: 
        (FileDirectory default directoryNamed:'mcz'));
  package: 'OSProcess';
  load.

"Bootstrap Metacello"
(Smalltalk at: #Gofer) new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
        (FileDirectory default directoryNamed: 'git_cache/metacello-work/repository'));
    package: 'Metacello-Base';
    package: 'Metacello-Core';
    package: 'Metacello-FileTree';
    package: 'Metacello-GitHub';
    package: 'Metacello-MC';
    package: 'Metacello-ToolBox';
    load.


