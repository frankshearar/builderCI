Object subclass: #ConfigurationOf
	instanceVariableNames: 'project'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Metacello-Base'!
!ConfigurationOf commentStamp: 'dkh 5/30/2012 16:31' prior: 0!
**ConfigurationOf** is the common superclass for all Metacello configurations.

A short description of why you would want to use a **ConfigurationOf**.

To create a new Metacello configuration:

1. Create a subclass of the class ConfigurationOf appending the name of
   your project (don't forget to change the **category:** to match the
   name of the configuration class):

    ```Smalltalk
    ConfigurationOf subclass: #ConfigurationOfExample
      instanceVariableNames: ''
      classVariableNames: ''
      poolDictionaries: ''
      category: 'ConfigurationOfExample'
    ```

2. Create a **baselineXXXX:** method where you specify the structure of your project:

    ```Smalltalk
    baseline0100: spec
      <baseline: '1.0-baseline'>

      spec for: #common do: [
        spec repository: 'http://ss3.gemstone.com/ss/Example'.
        spec
          package: 'Example-Core';
          package: 'Example-Tests' with: [
            spec requires: 'Example-Core' ]].
    ```

3. Create a **versionXXXX:** method where you specify the specific
   versions of the packages to be loaded for this version:

    ```Smalltalk
    version01000: spec
      <version: '1.0' imports: #('1.0-baseline')>

      spec for: #common do: [
        spec blessing: #release.
        spec
          package: 'Example-Core' with: 'Example-Core';
          package: 'Example-Tests' with: 'Example-Tests' ].
    ```

4. Create a Monticello package for your **ConfigurationOf** class and save it in the repository where your packages are stored. !


!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
customProjectAttributes
    "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes "

    ^ #()! !

!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
project
    ^ project
        ifNil: [ 
            "Bootstrap Metacello if it is not already loaded"
            self class ensureMetacello.
            project := self projectClass new projectAttributes: self customProjectAttributes.	"Create the Metacello project"
            project class versionConstructorClass on: self project: project.	"Construct the project"
            project loadType: #linear.	"change to #atomic if desired"
            project ]! !

!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
project: aProject

	project ifNil: [ self class ensureMetacello ].
	project := aProject! !

!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
projectClass
    ^ MetacelloMCProject! !


!ConfigurationOf methodsFor: 'defaults' stamp: 'dkh 5/31/2012 17:57:13'!
bleedingEdge 
	"override if different behavior desired.
	 Use:
		self versionDoesNotExistError: #bleedingEdge
	 if #bleedingEdge version is disallowed."

	<defaultSymbolicVersion: #bleedingEdge>
	
	^self defaultBleedingEdgeVersion! !

!ConfigurationOf methodsFor: 'defaults' stamp: 'dkh 5/31/2012 17:57:13'!
defaultBleedingEdgeVersion
	| bleedingEdgeVersion |
	bleedingEdgeVersion := (self project map values select: [ :version | version blessing == #baseline ])
		detectMax: [ :version | version ].
	bleedingEdgeVersion ifNil: [ ^#'notDefined' ].
	^ bleedingEdgeVersion versionString! !


!ConfigurationOf methodsFor: 'private' stamp: 'dkh 5/31/2012 17:57:13'!
versionDoesNotExistError: versionStringOrSymbol

	((Smalltalk at: #MetacelloSymbolicVersionDoesNotExistError) project: self project versionString: versionStringOrSymbol) signal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ConfigurationOf class
	instanceVariableNames: ''!

!ConfigurationOf class methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
project

	^self new project! !

!ConfigurationOf class methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
validate
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore! !



!ConfigurationOf class methodsFor: 'unloading Metacello' stamp: 'dkh 5/31/2012 17:57:13'!
unloadMetacello
	"Unload the classes that implement Metacello. Metacello is not needed once a project has been loaded, so it can safely be unloaded."

	"self unloadMetacello"

	<apiDocumentation>
	| gofer |
	gofer := (Smalltalk at: #Gofer) new.
	MCWorkingCopy allManagers do: [:wc |
		((wc packageName beginsWith: 'Metacello') or: [ wc packageName beginsWith: 'OB-Metacello' ])
			ifTrue: [ gofer package: wc packageName ]].
	gofer unload.! !


!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 6/16/2012 21:22'!
bootstrapMetacelloFrom: repositoryUrl
    "Corresponds to version 1.0-beta.32"

    | platformPkg |
    self ensureGoferVersion: 'Gofer-Core-lr.115' repositoryUrl: repositoryUrl.
    #('Metacello-Base-dkh.67' 'Metacello-Core-dkh.587' 'Metacello-MC-dkh.624' 'ConfigurationOfMetacello-dkh.694')
        do: [ :pkg | self bootstrapPackage: pkg from: repositoryUrl ].
    platformPkg := Smalltalk
        at: #'SystemVersion'
        ifPresent: [ :cl | 
            | versionString |
            versionString := cl current version.
            (versionString beginsWith: 'Squeak')
                ifTrue: [ 
                    (versionString beginsWith: 'Squeak3')
                        ifTrue: [ 'Metacello-Platform.squeak-dkh.5' ]
                        ifFalse: [ 'Metacello-Platform.squeak-dkh.10' ] ]
                ifFalse: [ 
                    (versionString beginsWith: 'Pharo')
                        ifTrue: [ 'Metacello-Platform.pharo-DaleHenrichs.25' ] ] ].
    self bootstrapPackage: platformPkg from: repositoryUrl! !

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 5/31/2012 17:57:13'!
bootstrapPackage: aString from: aPath 
	| repository version |
	repository := (MCCacheRepository default includesVersionNamed: aString)
		ifTrue: [MCCacheRepository default]
		ifFalse: [MCHttpRepository
				location: aPath
				user: ''
				password: ''].
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]! !

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 6/10/2012 22:01'!
ensureGoferVersion: goferVersion repositoryUrl: repositoryUrl
    "load the p=file goferVersion if Gofer isn't loaded or an earlier version of Gofer is currently loaded"

    | goferVersionNumber wc pName |
    (Smalltalk at: #'Gofer' ifAbsent: [  ]) == nil
        ifTrue: [ ^ self bootstrapPackage: goferVersion from: repositoryUrl ].
    goferVersionNumber := (goferVersion copyAfterLast: $.) asNumber.
    wc := [ ((Smalltalk at: #'GoferPackageReference') name: 'Gofer') workingCopy ]
        on: Error
        do: [ :ex | ex return: ((Smalltalk at: #'GoferPackageReference') name: 'Gofer-Core') workingCopy ].
    pName := wc ancestry ancestors first name.
    (pName copyAfterLast: $.) asNumber <= goferVersionNumber
        ifTrue: [ self bootstrapPackage: goferVersion from: repositoryUrl ]! !

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 6/11/2012 11:05'!
ensureMetacello
    "Bootstrap Metacello and load the 'botstrap' group"

    self ensureMetacello: #('batch')! !

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 6/11/2012 10:10'!
ensureMetacello: loadList
    "Bootstrap Metacello, retry using alternate repository, if primary repository is not accessible"

    Smalltalk
        at: #'MetacelloProject'
        ifAbsent: [ 
            | retry version error |
            retry := false.
            (Array with: 'http://seaside.gemstone.com/ss/metacello' with: 'http://www.squeaksource.com/metacello')
                do: [ :repositoryUrl | 
                    [ 
                    "bootstrap Metacello"
                    self bootstrapMetacelloFrom: repositoryUrl.	"load latest version of Metacello"
                    version := (Smalltalk at: #'ConfigurationOfMetacello') project version: '1.0-beta.32'.
                    retry
                        ifTrue: [ 
                            "on retry, use #repositoryOverrides:"
                            version
                                repositoryOverrides:
                                    (Array with: (MCHttpRepository location: repositoryUrl user: '' password: '')) ].
                    version load: loadList.
                    ^ self ]
                        on: Error
                        do: [ :ex | 
                            error := ex.
                            Transcript
                                cr;
                                show: 'failed ensureMetacello: ';
                                show: ex description printString;
                                show: '...retrying'.	"try again"
                            retry := true.
                            ex return: nil ] ].	"shouldn't get here unless the load failed ... throw an error"
            self error: 'retry with alternate repository failed: ' , error description printString ]! !


Object subclass: #Metacello
	instanceVariableNames: 'scriptEngine ensureList statements'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Metacello-Base'!
!Metacello commentStamp: 'dkh 5/30/2012 16:46' prior: 0!
**Metacello** is The entry point for the *Metacello Scripting API*.

Use the *Metacello Scripting API* to load projects into your image and to publish load instructions for your own projects.

The following expression will load **ConfigurationOfExample** configuration from the *http://ss3.gemstone.com/ss/Example* repository and then loads version **1.0** of the **Example project**:

```Smalltalk
Metacello new
  configuration: 'Example';
  version: '1.0';
  repository: 'http://ss3.gemstone.com/ss/Example';
  load.
```
!


!Metacello methodsFor: 'private' stamp: 'dkh 5/31/2012 17:57:13'!
addStatement: selector args: args
    self statements add: selector -> args! !

!Metacello methodsFor: 'private' stamp: 'dkh 5/31/2012 17:57:13'!
execute
    | script |
    script := self statements.
    self statements: nil.
    ^ self scriptEngine execute: script! !

!Metacello methodsFor: 'private' stamp: 'dkh 5/31/2012 17:57:13'!
scriptEngine
    scriptEngine ifNil: [ scriptEngine := (self class scriptEngineClass: self ensureList) new ].
    ^ scriptEngine! !


!Metacello methodsFor: 'accessing' stamp: 'dkh 6/11/2012 11:05'!
ensureList
    ensureList ifNil: [ ensureList := OrderedCollection with: #'MetacelloScriptEngine' -> 'batch' ].
    ^ ensureList! !

!Metacello methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
ensureList: anObject
	ensureList := anObject! !

!Metacello methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
statements
    statements ifNil: [ statements := OrderedCollection new ].
    ^ statements! !

!Metacello methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
statements: anObject
	statements := anObject! !


!Metacello methodsFor: 'actions api' stamp: 'dkh 5/31/2012 17:57:13'!
fetch
    self addStatement: #'fetch' args: #().
    ^ self execute! !

!Metacello methodsFor: 'actions api' stamp: 'dkh 5/31/2012 17:57:13'!
fetch: required
    self addStatement: #'fetch:' args: {required}.
    ^ self execute! !

!Metacello methodsFor: 'actions api' stamp: 'dkh 5/31/2012 17:57:13'!
get
    "resolve project name in given repository and return an instance of MetacelloProject resolved from a ConfigurationOf or BaselineOf"

    self addStatement: #'get' args: #().
    ^ self execute! !

!Metacello methodsFor: 'actions api' stamp: 'dkh 5/31/2012 17:57:13'!
load
    self addStatement: #'load' args: #().
    ^ self execute! !

!Metacello methodsFor: 'actions api' stamp: 'dkh 5/31/2012 17:57:13'!
load: required
    self addStatement: #'load:' args: {required}.
    ^ self execute! !


!Metacello methodsFor: 'options api' stamp: 'dkh 6/13/2012 16:05'!
ignoreImage
    "ignore image state"

    self addStatement: #'ignoreImage:' args: {true}! !

!Metacello methodsFor: 'options api' stamp: 'dkh 6/7/2012 15:34'!
onConflict: aBlock
    self addStatement: #'onConflict:' args: {aBlock}! !

!Metacello methodsFor: 'options api' stamp: 'dkh 6/8/2012 14:03:46'!
onDowngrade: aBlock
    self addStatement: #'onDowngrade:' args: {aBlock}! !

!Metacello methodsFor: 'options api' stamp: 'dkh 6/7/2012 15:33'!
onUpgrade: aBlock
    self addStatement: #'onUpgrade:' args: {aBlock}! !

!Metacello methodsFor: 'options api' stamp: 'dkh 5/31/2012 17:57:13'!
silently
    "no progress bars"

    self addStatement: #'silently:' args: {true}! !


!Metacello methodsFor: 'api' stamp: 'dkh 5/31/2012 17:57:13'!
baseline: projectName
    self addStatement: #'baseline:' args: {projectName}! !

!Metacello methodsFor: 'api' stamp: 'dkh 5/31/2012 17:57:13'!
className: className
    self addStatement: #'className:' args: {className}! !

!Metacello methodsFor: 'api' stamp: 'dkh 5/31/2012 17:57:13'!
configuration: projectName
    self addStatement: #'configuration:' args: {projectName}! !

!Metacello methodsFor: 'api' stamp: 'dkh 5/31/2012 17:57:13'!
project: projectName
    self addStatement: #'project:' args: {projectName}! !

!Metacello methodsFor: 'api' stamp: 'dkh 5/31/2012 17:57:13'!
repository: repositoryDescription
    self addStatement: #'repository:' args: {repositoryDescription}! !

!Metacello methodsFor: 'api' stamp: 'dkh 5/31/2012 17:57:13'!
version: versionString
    self addStatement: #'version:' args: {versionString}! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Metacello class
	instanceVariableNames: ''!

!Metacello class methodsFor: 'instance creation' stamp: 'dkh 6/13/2012 16:09'!
classic
    "set the options such that the load performed will be identical to the classic ConfigurationOf load:
	(ConfigurationOfExample project version: '1.0') load
	
	#classic forces Metacello to look at image state to determine which version of a project is loaded instead of using
		the registry to tell us explicitly which version of a project is loaded .. image state is not PRECISE"

    "useCurrentVersion is a 'private' option for enforcing classic rules, so it's not part of scripting api"

    ^ self new
        onUpgrade: [ :ex | ex allow ];
        onConflict: [ :ex | ex allow ];
        addStatement: #'useCurrentVersion:' args: {true};
        yourself! !


!Metacello class methodsFor: 'private' stamp: 'dkh 5/31/2012 17:57:13'!
scriptEngineClass
    ^ self scriptEngineClass: {(#'MetacelloScriptEngine' -> 'default')}! !

!Metacello class methodsFor: 'private' stamp: 'dkh 6/11/2012 12:31'!
scriptEngineClass: loadList
    | list |
    list := OrderedCollection new.
    loadList do: [ :assoc | Smalltalk at: assoc key ifAbsent: [ list add: assoc value ] ].
    list notEmpty
        ifTrue: [ ConfigurationOf ensureMetacello: list ].
    ^ Smalltalk at: #'MetacelloScriptEngine'! !


ConfigurationOf subclass: #BaselineOf
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Metacello-Base'!
!BaselineOf commentStamp: 'dkh 5/30/2012 16:30' prior: 0!
**BaselineOf** is the common superclass for all Metacello baselines.

A short description of why you would want to use a **BaselineOf**.

To create a new Metacello baseline

1. Create a subclass of the class BaselineOf appending the name of
   your project (don't forget to change the **category:** to match the
   name of the configuration class):

    ```Smalltalk
    BaselineOf subclass: #BaselineOfExample
      instanceVariableNames: ''
      classVariableNames: ''
      poolDictionaries: ''
      category: 'BaselineOfExample'
    ```

2. Create a **baseline:** method where you specify the structure of your project:

    ```Smalltalk
    baseline: spec
      <baseline>

      spec for: #common do: [
        spec
          package: 'Example-Core';
          package: 'Example-Tests' with: [
            spec requires: 'Example-Core' ]].
    ```

3. Create a Monticello package for your **BaselineOf** class and save it in the repository where your packages are stored.!


!BaselineOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
projectClass
    ^ MetacelloMCBaselineProject! !

