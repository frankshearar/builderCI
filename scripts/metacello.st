"Bootstrap Metacello"
| metacelloPath |
metacelloPath := '/home/vagrant/metacello-work/repository'.

"OSProcess required for now"
Gofer new
  squeaksource: 'MetacelloRepository';
  package: 'ConfigurationOfOSProcess';
  load.
((Smalltalk at: #'ConfigurationOfOSProcess') project version: #stable) load.

"Metacello"
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


