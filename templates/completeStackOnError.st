"Since the debug logs truncate all of the interesting information and sometimes you have to debug test errors in Travis (can't reproduce in local image), here' sthe code that dumps a full and complete stack to the Transcript on an error"
[ "code throwing error"]
        on: Error
        do: [ :ex | 
            Transcript
                cr;
                show: '***************************************************';
                cr;
                show: ex description.
            (ex signalerContext stackOfSize: 100)
                do: [ :item | 
                    Transcript
                        cr;
                        show: item printString asString.
                    item tempScopedNames
                        doWithIndex: [ :title :index | 
                            Transcript
                                cr;
                                tab;
                                nextPutAll: title;
                                nextPut: $:;
                                space;
                                tab;
                                nextPutAll: (item tempAt: index) printString ].
                    Transcript
                        cr;
                        show: '***************************************************' ].
            ex pass ].

