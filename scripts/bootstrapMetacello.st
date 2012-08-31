| fileInBlock |
Transcript cr; show: 'travis---->bootstrapMetacello.st'.

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
Transcript cr; show: 'travis---->before filein'.
      fileInBlock value: 'Metacello-Base.st'.
Transcript cr; show: 'travis---->after filein'.

      "ensure that Gofer is available on Squeak"
      (Smalltalk at: #ConfigurationOf) 
        ensureGoferVersion: 'Gofer-Core-lr.115' 
        repositoryUrl: 'http://seaside.gemstone.com/ss/metacello'.
Transcript cr; show: 'travis---->after Gofer load'.
 ]
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


