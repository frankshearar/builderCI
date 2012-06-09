"Bootstrap FileTree"
| filetreePath |
filetreePath := '/home/vagrant/filetree/repository'.

Gofer new
    url: 'http://ss3.gemstone.com/ss/FileTree';
    package: 'ConfigurationOfFileTree';
    load.
((Smalltalk at: #ConfigurationOfFileTree) project version: '1.0') load.

Gofer new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
        (FileDirectory on: filetreePath));
    package: 'MonticelloFileTree-Core';
    load.

