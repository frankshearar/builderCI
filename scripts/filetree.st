"Ensure minimal Metacello loaded ... need to adjust Configuration to
make this easier:)"

(Smalltalk at: #ConfigurationOf) 
    bootstrapMetacelloFrom: 'http://seaside.gemstone.com/ss/metacello'.

"Bootstrap FileTree"
(Smalltalk at: #Gofer) new
    url: 'http://ss3.gemstone.com/ss/FileTree';
    package: 'ConfigurationOfFileTree';
    load.

((Smalltalk at: #ConfigurationOfFileTree) project version: '1.0') load.

(Smalltalk at: #Gofer) new
    disablePackageCache;
    repository: (MCFileTreeRepository new directory: 
        (FileDirectory default directoryNamed: 'git_cache/filetree/repository'));
    package: 'MonticelloFileTree-Core';
    load.

