| fileInBlock |
(Smalltalk at: #FileDirectory ifAbsent: [])
  ifNil: [ 
    fileInBlock := [:fileName | ((Smalltalk at: #FileSystem) workingDirectory / fileName)
      readStreamDo: [:fileStream | fileStream fileIn ] ] ]
  ifNotNil: [:fileDirectoryClass | 
    fileInBlock := [:fileName | fileDirectoryClass default 
      fileNamed: fileName
      do: [:fileStream | fileStream fileIn ] ] ].

"Bootstrap Metacello-Base to simulate conditions when it's included in base images"
(Smalltalk
  at: #'MetacelloProject'
  ifAbsent: []) 
    ifNil: [
      "Metacello not pre-installed install Metacello-Base"
      fileInBlock value: 'Metacello-Base.st' ]
    ifNotNil: [
      "Metacello already installed, install Preview".
      (Smalltalk at: #Gofer) new
        gemsource: 'metacello';
        package: 'ConfigurationOfMetacello';
        load.
      ((Smalltalk at: #ConfigurationOfMetacello) project 
        version: '1.0-beta.32') load.
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        version: #stable;
        repository: 'github://dalehenrich/metacello-work:configuration';
        load ].
