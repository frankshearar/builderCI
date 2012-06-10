"builderCI test harness ... invoked by the following expression:

    TravisCIHarness
      value: #( 'FileTreeTests' )
      value: 'TravisCISuccess.txt' 
      value: 'TravisCIFailure.txt'.

"

Smalltalk 
  at: #TravisCIHarness
  put: 
  [ :projectNameList :successFilename :failFilename | 
    | suite result resultsFileName |
    suite := TestCase suiteClass named: 'builderCI Test Suite'.
    projectNameList
        do: [ :projectName | 
            ((MetacelloProjectRegistration registrationForProjectNamed: projectName ifAbsent: [  ]) baselineProjectSpec version
                currentlyLoadedClassesInVersion select: [ :cl | cl inheritsFrom: TestCase ])
                do: [ :cl | 
                    cl isAbstract
                        ifFalse: [ suite addTest: cl buildSuiteFromSelectors ] ] ].
    result := suite run.
    resultsFileName := result defects isEmpty
        ifTrue: [ successFilename ]
        ifFalse: [ failFilename ].
    FileDirectory default
        forceNewFileNamed: resultsFileName
        do: [ :fileStream | 
            fileStream lineEndConvention: #'lf'.
            fileStream
                nextPutAll: '***********************************************';
                cr.
            fileStream
                tab;
                nextPutAll: 'Results for ' , suite name;
                cr;
                nextPutAll: result printString;
                cr.
            fileStream
                nextPutAll: '***********************************************';
                cr.
            result defects
                do: [ :each | 
                    fileStream tab
                        nextPutAll: each class name asString , ' debug: ' , each selector printString , '.';
                        cr ].
            fileStream
                nextPutAll: '***********************************************';
                cr ] ]
