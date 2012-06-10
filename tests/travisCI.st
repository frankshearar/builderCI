"Load and run tests to be performed by TravisCI"
| gitPath projectName suite result resultsFileName |

"prime the pump with FileTree install using Metacello scripting API"
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.	
Metacello new
    baseline: 'FileTree';
    repository: 'filetree://' , gitPath , '/filetree/repository';
    load.	

"load the file tree tests"
Metacello new
    baseline: 'FileTreeTests';
    repository: 'filetree://' , gitPath , '/filetree/tests/repository';
    load.	

"Run the tests"
projectName := 'FileTreeTests'.
suite := TestCase suiteClass named: projectName , ' Suite'.
((MetacelloProjectRegistration registrationForProjectNamed: 'FileTreeTests' ifAbsent: [  ]) baselineProjectSpec
    version currentlyLoadedClassesInVersion select: [ :cl | cl inheritsFrom: TestCase ])
    do: [ :cl | 
        cl isAbstract
            ifFalse: [ suite addTest: cl buildSuiteFromSelectors ] ].
result := suite run.
resultsFileName := result defects isEmpty 
    ifTrue: ['TravisCISuccess.txt'] 
    ifFalse: ['TravisCIFailure.txt'].
FileDirectory default
    forceNewFileNamed: resultsFileName 
    do: [ :fileStream | 
        fileStream lineEndConvention: #'lf'.
        fileStream nextPutAll: '***********************************************'; cr.
        fileStream
            tab;
            nextPutAll: 'Results for ' , suite name;
            cr;
            nextPutAll: result printString;
            cr.
        fileStream nextPutAll: '***********************************************'; cr.
        result defects
            do: [ :each | 
                fileStream tab
                    nextPutAll: each class name asString, ' debug: ' , each testSelector printString , '.';
                    cr ]. 
        fileStream nextPutAll: '***********************************************'; cr ]
