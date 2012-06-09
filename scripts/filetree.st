"Bootstrap FileTree"
Gofer new
    url: 'http://ss3.gemstone.com/ss/FileTree';
    package: 'ConfigurationOfFileTree';
    load.
((Smalltalk at: #ConfigurationOfFileTree) project version: '1.0') load.

Gofer new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
        (FileDirectory default directoryNamed: 'git_cache/filetree/repository'));
    package: 'MonticelloFileTree-Core';
    load.

