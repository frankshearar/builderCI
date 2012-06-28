"builderCI test harness ... invoked by the following expression:

    TravisCIHarness
      value: #( 'BaselineOfFileTreeTests' 'ConfigurationOfMetacello')
      value: 'TravisCISuccess.txt' 
      value: 'TravisCIFailure.txt'.

"

    Smalltalk
        at: #'TravisCIHarness'
        put: [ :configurationClassNameList :successFilename :failFilename | 
            [
            | suite result resultsFileName |
            (Smalltalk at: #'TravisCITranscriptLogging' ifAbsent: [ false ])
                ifTrue: [ 
                    FileDirectory default fileNamed: 'FileStream-show.st' do: [ :fileStream | fileStream fileIn ].
                    (Smalltalk associationAt: #'Transcript') value: FileStream stdout ].
            suite := TestCase suiteClass named: configurationClassNameList printString, ' Test Suite'.
            configurationClassNameList
                do: [ :className | 
                    ((MetacelloProjectRegistration
                        registrationForClassNamed: className
                        ifAbsent: [ self error: className printString , ' not registered (loaded)' ])
                            currentlyLoadedClassesInProject select: [ :cl | cl inheritsFrom: TestCase ])
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
                    result failures notEmpty
                        ifTrue: [ 
                            fileStream
                                nextPutAll: '*** FAILURES ***';
                                nextPutAll: '****************';
                                cr ].
                    result failures
                        do: [ :each | 
                            fileStream tab
                                nextPutAll: each class name asString , ' debug: ' , each selector printString , '.';
                                cr ].
                    result errors notEmpty
                        ifTrue: [ 
                            fileStream
                                nextPutAll: '*** ERRORS ***';
                                nextPutAll: '****************';
                                cr ].
                    result errors
                        do: [ :each | 
                            fileStream tab
                                nextPutAll: each class name asString , ' debug: ' , each selector printString , '.';
                                cr ].
                    fileStream
                        nextPutAll: '***********************************************';
                        cr ]] ensure: [ (Smalltalk associationAt: #Transcript) close ]]
