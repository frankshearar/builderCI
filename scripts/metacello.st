"Ensure minimal Metacello loaded ... need to adjust Configuration to
make this easier:)"

ConfigurationOfMetacello bootstrapMetacelloFrom: 'http://seaside.gemstone.com/ss/metacello'.

"Bootstrap OSProcess"
Gofer new
  squeaksource: 'MetacelloRepository';
  package: 'ConfigurationOfOSProcess';
  load.
((Smalltalk at: #'ConfigurationOfOSProcess') project version: #stable) load.

"Bootstrap Metacello"
Gofer new
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


