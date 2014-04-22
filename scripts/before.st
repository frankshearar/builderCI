| fileDirectoryClass fileInBlock resultFileBlock transcriptFileName
transcriptStream platformIsGemStone  |
"Initialize Image for batch testing with Metacello"
Smalltalk at: #Deprecation ifPresent: [:class | 
  (class respondsTo: #'raiseWarning:')
    ifTrue: [ class raiseWarning: false ]].
transcriptFileName := 'TravisTranscript.txt'.
(fileDirectoryClass := Smalltalk at: #'FileDirectory' ifAbsent: [  ])
  ifNil: [ 
    fileInBlock := [ :fileName | 
    (Smalltalk at: #'FileSystem') workingDirectory / fileName
      readStreamDo: [ :fileStream | fileStream fileIn ] ].
    resultFileBlock := [ :resultsFileName :streamBlock | 
    (Smalltalk at: #'FileSystem') workingDirectory / resultsFileName
      writeStreamDo: streamBlock ].
    transcriptStream := ((Smalltalk at: #'FileSystem') workingDirectory
      / transcriptFileName) writeStream ]
  ifNotNil: [ 
    fileInBlock := [ :fileName | 
    fileDirectoryClass default
      fileNamed: fileName
      do: [ :fileStream | fileStream fileIn ] ].
    resultFileBlock := [ :resultsFileName :streamBlock |
      fileDirectoryClass default forceNewFileNamed: resultsFileName do: streamBlock ].
    transcriptStream := fileDirectoryClass default
      newFileNamed: transcriptFileName ].
platformIsGemStone := false.
Smalltalk at: #MetacelloPlatform ifPresent: [:platformClass |
  platformIsGemStone := platformClass current defaultPlatformAttributes includes: #gemstone ].
platformIsGemStone
  ifFalse: [ fileInBlock value: 'FileStream-show.st' ].
Smalltalk
  at: #'SystemVersion'
  ifPresent: [ :cl | 
    | versionString |
    versionString := cl current version.
    (versionString beginsWith: 'Squeak')
      ifTrue:  [
        "Force-update. Squeak does release artifacts too seldom."
        Smalltalk at: #MCMcmUpdater ifPresent: [ :updater |
          [updater updateFromDefaultRepository]
          on: Warning do: [ :ex | ex resume: true ]].
        "see https://github.com/dalehenrich/builderCI/issues/48"
        fileInBlock value: 'CommandLineToolSet.st' ]].
fileInBlock value: 'MetacelloBuilderTravisCI.st'.
Smalltalk at: #'TravisResultFileBlock' put: resultFileBlock.
Smalltalk at: #'OLDTranscript' put: Transcript.
platformIsGemStone
  ifFalse: [ 
    "Transcript streams to stdout in GemStone by default"
    (Smalltalk globals associationAt: #'Transcript') value: transcriptStream.
    Transcript file lineEndConvention: #'lf' ].
"Load krono's filetree fork from GitHub"
(Smalltalk at: #Metacello) new
  baseline: 'FileTree';
  repository: 'github://krono/filetree:48a986627bba1b64024fdd0a7c4d3314b2d545c0/repository';
  load.
Transcript
  cr;
  show: 'travis---->before.st'
