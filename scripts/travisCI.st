| filetreePackagePath filetreePath metacelloPath |
filetreePackagePath := '/home/vagrant/builds/dalehenrich/builderCI/packages'.
filetreePath := '/home/vagrant/filetree/repository'.
metacelloPath := '/home/vagrant/metacello-work/repository'.

Gofer new
    disablePackageCache;
    repository: (MCDirectoryRepository new directory: 
        (FileDirectory on: filetreePackagePath));
    package: 'MonticelloFileTree-Core.pharo13';
    load.

Gofer new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
        (FileDirectory on: filetreePath));
    package: 'MonticelloFileTree-Core';
    load.

Gofer new
  squeaksource: 'MetacelloRepository';
  package: 'ConfigurationOfOSProcess';
  load.
((Smalltalk at: #'ConfigurationOfOSProcess') project version: #stable) load.

Gofer new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
                    (FileDirectory on: metacelloPath));
    package: 'Metacello-Base';
    package: 'Metacello-Core';
    package: 'Metacello-FileTree';
    package: 'Metacello-GitHub';
    package: 'Metacello-MC';
    package: 'Metacello-ToolBox';
    package: 'BaselineOfMetacello';
    load.


