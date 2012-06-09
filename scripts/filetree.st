"Bootstrap FileTree"
Gofer new
    url: 'http://ss3.gemstone.com/ss/FileTree';
    version: 'MonticelloFileTree-Core.pharo13-dkh.58';
    load.

Gofer new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
        (FileDirectory default directoryNamed: 'git_cache/filetree/repository'));
    package: 'MonticelloFileTree-Core';
    load.

