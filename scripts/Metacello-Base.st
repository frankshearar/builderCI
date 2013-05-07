Object subclass: #ConfigurationOf
	instanceVariableNames: 'project'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Metacello-Base'!
!ConfigurationOf commentStamp: 'dkh 5/30/2012 16:31' prior: 0!
You must use a *configuration* when your project is stored in a
repository using `.mcz` files.

If you are using a source code manager (SCM) like [git][1] and have
created a *baseline* (see the [**BaselineOf** class comment][3] for more info)
you may use a *configuration* to associate a specific
git commit (SHA, branch name, tag name) with a [Metacello version][2].

To create a new Metacello configuration:

1. Create a subclass of the **ConfigurationOf** class. The configuration
   class for your project should be names by appending the name of
   your project to the string `ConfigurationOf`. The name of the
   category and package should be the same as the name of the class:

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

4. Create a Monticello package for your **ConfigurationOf** class and save it in the repository where your packages are stored. 

[1]: http://git-scm.com/
[2]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#metacello-version-numbers
[3]: https://github.com/dalehenrich/metacello-work/blob/master/repository/Metacello-Base.package/BaselineOf.class/README.md
!


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


!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
customProjectAttributes
    "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes "

    ^ #()! !

!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 6/22/2012 14:31'!
project
    ^ project
        ifNil: [ 
            "Bootstrap Metacello if it is not already loaded"
            self class ensureMetacello.
            project := self projectClass new projectAttributes: self customProjectAttributes.	"Create the Metacello project"
            project versionNumberClass: self versionNumberClass.
            project class versionConstructorClass on: self project: project.	"Construct the project"
            project loadType: #'linear'.	"change to #atomic if desired"
            project ]! !

!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
project: aProject

	project ifNil: [ self class ensureMetacello ].
	project := aProject! !

!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
projectClass
    ^ MetacelloMCProject! !

!ConfigurationOf methodsFor: 'accessing' stamp: 'dkh 6/22/2012 12:09'!
versionNumberClass
    ^ MetacelloSemanticVersionNumber! !


!ConfigurationOf methodsFor: 'private' stamp: 'dkh 5/31/2012 17:57:13'!
versionDoesNotExistError: versionStringOrSymbol

	((Smalltalk at: #MetacelloSymbolicVersionDoesNotExistError) project: self project versionString: versionStringOrSymbol) signal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ConfigurationOf class
	instanceVariableNames: ''!

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 05/05/2013 17:04'!
bootstrapMetacelloFrom: repositoryUrl
  "Corresponds to version 1.0.0-beta.32.5"

  "KEEP MetacelloConfigTemplate class>>ensureMetacelloBaseConfiguration in synch!!"

  | platformPkg |
  self ensureGoferVersion: 'Gofer-Core-lr.115' repositoryUrl: repositoryUrl.
  #('Metacello-Base-dkh.104' 'Metacello-Core-dkh.678' 'Metacello-MC-dkh.674')
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
            ifFalse: [ 'Metacello-Platform.squeak-dkh.22' ] ]
        ifFalse: [ 
          (versionString beginsWith: 'Pharo')
            ifTrue: [ 
              (versionString beginsWith: 'Pharo2')
                ifTrue: [ 'Metacello-Platform.pharo20-dkh.33' ]
                ifFalse: [ 'Metacello-Platform.pharo-dkh.33' ] ] ] ].
  self bootstrapPackage: platformPkg from: repositoryUrl! !

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 9/4/2012 17:09'!
bootstrapPackage: aString from: aPath
    | repository version |
    repository := (MCCacheRepository default includesVersionNamed: aString)
        ifTrue: [ MCCacheRepository default ]
        ifFalse: [ MCHttpRepository location: aPath user: '' password: '' ].
    self
        retry: [ 
            repository
                versionReaderForFileNamed: aString , '.mcz'
                do: [ :reader | 
                    version := reader version.
                    version load.
                    version workingCopy repositoryGroup addRepository: repository ] ]! !

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

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 05/05/2013 16:09'!
ensureMetacello: loadList
  "Bootstrap Metacello, retry using alternate repository, if primary repository is not accessible"

  Smalltalk
    at: #'MetacelloProject'
    ifAbsent: [ 
      | version error gofer |
      (Array
        with: 'http://seaside.gemstone.com/ss/metacello'
        with: 'http://www.squeaksource.com/metacello')
        do: [ :repositoryUrl | 
          "bootstrap Metacello"
          [ 
          self bootstrapMetacelloFrom: repositoryUrl.
          Smalltalk
            at: #'ConfigurationOfMetacello'
            ifAbsent: [ 
              self
                retry: [ 
                  gofer := (Smalltalk at: #'Gofer') new.
                  gofer
                    perform: #'url:' with: repositoryUrl;
                    perform: #'package:' with: 'ConfigurationOfMetacello';
                    perform: #'load' ] ].
          version := (Smalltalk at: #'ConfigurationOfMetacello') project
            version: #'previewBootstrap'.	"bootstrap with #'previewBootstrap' currently 1.0-beta.32.1"
          version load: loadList.
          self
            retry: [ 
              gofer := (Smalltalk at: #'Gofer') new.
              Smalltalk
                at: #'ConfigurationOfMetacelloPreview'
                ifAbsent: [ 
                  gofer
                    perform: #'url:' with: repositoryUrl;
                    perform: #'package:'
                      with: 'ConfigurationOfMetacelloPreview';
                    perform: #'load' ] ].
          version := (Smalltalk at: #'ConfigurationOfMetacelloPreview') project
            version: #'stable'.	"load latest from GitHub"
          version load: loadList.
          ^ self ]
            on: Error
            do: [ :ex | 
              error := ex.
              Transcript
                cr;
                show: 'failed ensureMetacello using ';
                show: repositoryUrl printString;
                show: ' : ';
                show: ex description printString;
                show: '...retrying'.	"try again"
              ex return: nil ] ].	"shouldn't get here unless the load failed ... throw an error"
      self
        error:
          'retry with alternate repository failed: ' , error description printString ]! !

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 9/4/2012 17:09'!
retry: aBlock
    self retry: aBlock retryCount: 3! !

!ConfigurationOf class methodsFor: 'private' stamp: 'dkh 9/4/2012 20:50'!
retry: aBlock retryCount: retryCount
    | count |
    count := 1.
    [ true ]
        whileTrue: [ 
            [ 
            aBlock value.
            ^ self ]
                on: Error
                do: [ :ex | 
                    count < retryCount
                        ifTrue: [ 
                            Transcript
                                cr;
                                show: 'RETRYING AFTER:';
                                cr;
                                show: ex description printString.
                            (Delay forSeconds: 5) wait ]
                        ifFalse: [ 
                            Transcript
                                cr;
                                show: 'FAILED RETRYING:';
                                cr;
                                show: ex description printString.
                            ex pass ] ].
            count := count + 1 ]! !


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


ConfigurationOf subclass: #BaselineOf
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Metacello-Base'!
!BaselineOf commentStamp: 'dkh 5/30/2012 16:30' prior: 0!
You should use a *baseline* when you are using a disk-based source
code manager (SCM) like [git][1].

When using a disk-based SCM it is not necessary to use the Metacello
*version* method, because it is intended for use with `.mcz` files. 

With a disk-based SCM you only need a single `baseline:` method. When
you change the structure of your project you can change the baseline and
save everything in a single commit. So multiple `baseline:` methods are
no longer needed.

You may still need a *configuration* when using a *baseline*. The
[Sample project][3] on GitHub has a good example of a configuration used
in conjunction with a *baseline*. See the [**ConfigurationOf** class comment][2] 
for information on creating a *configuration*.

To create a new Metacello baseline:

1. Create a subclass of the **BaselineOf** class. The baseline
   class for your project should be named by appending the name of
   your project to the string `BaselineOf`. The name of the category and
   package should be the same as the name of the class:

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

3. Create a Monticello package for your **BaselineOf** class and save it in the repository where your packages are stored.

[1]: http://git-scm.com/
[2]: https://github.com/dalehenrich/metacello-work/blob/master/repository/Metacello-Base.package/ConfigurationOf.class/README.md
[3]: https://github.com/dalehenrich/sample/tree/configuration/ConfigurationOfSample.package/ConfigurationOfSample.class
!


!BaselineOf methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
projectClass
    ^ MetacelloMCBaselineProject! !

!BaselineOf methodsFor: 'accessing' stamp: 'dkh 6/22/2012 12:09'!
versionNumberClass
    ^ MetacelloVersionNumber! !


Object subclass: #Metacello
	instanceVariableNames: 'executorSpec statements'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Metacello-Base'!
!Metacello commentStamp: 'dkh 7/28/2012 20:04' prior: 0!
# Metacello User Guide

In this guide we'll take a walk through a couple of common development
scenarios and highlight some of the features of the *Metacello Scripting
API*.

*For installatation and more detailed documentation on the Metacello
Scripting API, see the [Metcello Scripting API Documentation][1].*

## Introduction

The number one job of the *Metacello Scripting API* is to simplify the
job of loading projects into your image. As you are probably all
too aware, today it's a two step process where you first load the
configuration into your image using [Gofer][2] and then load your
project using Metacello:

```Smalltalk
Gofer new
  package: 'ConfigurationOfSeaside30';
  squeaksource: 'MetacelloRepository';
  load.
((Smalltalk at: #ConfigurationOfSeaside30) version: #stable) load.
```

In the early days of Metacello (and Gofer) this was a great improvement
over the alternatives, but today, 3 years after the introduction of
Metacello, there should be a better way...and there is.
Using the *Metacello Scripting API* the above expression reduces to the
following:

```Smalltalk
Metacello new
  configuration: 'Seaside30';
  load.
```

## Loading

In this example of the [`load` command][5] we are leveraging a couple of
default values, namely the `version` of the project and the `repository` where the
**ConfigurationOfSeaside** package can be found:

```Smalltalk
Metacello new
  configuration: 'Seaside30';
  load.
```

Here is a variant
of the same expression with the (current) default values explicitly specified:

```Smalltalk
Metacello new
  configuration: 'Seaside30';
  version: #stable;
  squeaksource: 'MetacelloRepository';
  load.
```

The `version` attribute can be any legal [version number][10].
`squeaksource` is a [repository shortcut][4]. You can also specify the
full [repository description][3] as follows:

```Smalltalk
Metacello new
  configuration: 'Seaside30';
  version: #stable;
  repository: 'http://www.squeaksource.com/MetacelloRepository';
  load.
```

##Listing

Once you've loaded one or more projects into your image, you may want to
list them. The following is an example of the [`list` command][6]:

```Smalltalk
Metacello image
  configuration: [:spec | true ];
  list.
```

The `image` message tells Metacello that you'd like to look
at only loaded configurations. 

The *block* argument to the
`configuration:` message is used to *select* against the list of loaded
[MetacelloProjectSpec][7] instances in the [registry][8].

The `list` command itself returns a list of [MetacelloProjectSpec][7] instances that can be printed, inspected or otherwise manipulated.

In addition to a *select block*, you can specify a *select collection*
specifying the names of the projects you'd like to select:

```Smalltalk
Metacello registry
  configuration: #('Seaside30' 'MetacelloPreview');
  list.
```

The `registry` message tells Metacello that you'd like to
look at all projects in the [registry][8] whether or not they are loaded.

The *collection* argument to the `configuration:` message is used to
*select* against the list of project names in the [registry][8].

The `list` command can also be used to look at configurations in
Monticello repositories. For example:

```Smalltalk
Metacello new
  configuration: [:spec | spec name beginsWith: 'Seaside'];
  squeaksource: 'MetacelloRepository';
  list.
```

lists the configurations whose names (sans the `ConfigurationOf`) begin
with `Seaside` in the `MetacelloRepositry` in the
[Squeaksource](http://www.squeaksource.com) repostory.

## Getting

Once you've loaded a project into your image the next logical step is
upgrading your project to a new version. 

Let's say that a new `#stable` version of Seaside30 has been released
and that you want to upgrade. This is a two step process: 

* [get a new version of the configuration][11]
* [load the new version][12]

### Get a new version of the configuration

The following expression gets the latest version of the
configuration:

```Smalltalk
Metacello image
  configuration: 'Seaside30';
  get.
```

By using the `image` message, you can leverage the fact that the [registry][8] remembers
from which repository you loaded the original version of the configuration.

The `get` command simply downloads the latest version of the
configuration package from the repository.

You may download the configuration from a different repository:

```Smalltalk
Metacello image
  configuration: 'Seaside30';
  squeaksource: 'Seaside30;
  get.
```

The `get` command will update the [registry][8] with the new
repository location information.

You may also use the `get` command to load a configuration for a project
into your image without actually loading the project itself:

```Smalltalk
Metacello image
  configuration: 'SeasideRest';
  squeaksource: 'Seaside30';
  get.
```

The 'SeasideRest' project information will be registered in the [registry][8] and marked
as *unloaded*.

### Load the new version

Once you've got a new copy of the Seaside30 configuration loaded into your image, you may
upgrade your image with the following expression:

```Smalltalk
Metacello image
  configuration: 'Seaside30';
  version: #stable;
  load.
```

By using the `image` message, you are asking Metacello to look the
project up in the [registry][8] before performing the
operation, so it isn't necessary to supply all of the project details for every
command operation.

Of course, the `load` command updates the [registry][8].

If you want to load a project for which you've already done a `get`
(like the SeasideRest project earlier), you can do the following:

```Smalltalk
Metacello registry
  configuration: 'SeasideRest';
  version: #stable;
  load.
```

In this case you use the `registry` message to indicate that you are
interested in both *loaded* and *unloaded* projects.

##Locking

Let's say that you are using an older version of Seaside30 (say 3.0.5)
instead of the #stable version (3.0.7) and that your application doesn't
work with newer versions of Seaside30 (you've tried and it's more work
to get you application to work with the newer version of Seaside30 than
it's worth).

Let's also say that you want to try out something in the
SeasideRest project, but when you try loading SeasideRest, you end up
having Seaside 3.0.7 loaded as well. 

This is an unfortunate side effect of Metacello trying to *do the right
thing*, only in your case it is the wrong thing.

Fortunately, the [`lock` command][9] can give you control. First you
need to `lock` the Seaside30 project:

```Smalltalk
Metacello image
  configuration: 'Seaside30';
  lock.
```

The `image` message tells Metacello to do a lookup in the list of loaded
projects and then to put a lock on the loaded version of the project.

If you want you can specify which version of the project you want
locked:

```Smalltalk
Metacello image
  configuration: 'Seaside30';
  version: '3.0.5';
  lock.
```

After a project is locked an error (**MetacelloLockedProjectError**) is 
thrown when you attempt to load a project that has a dependency upon a 
different version of Seaside30. The error is thrown before any packages 
are actually loaded.

### Bypassing locks

Let's say that you want to load the SeasideRest project even though it may
require a version of Seaside30 that is later than the version that you have
locked. To do that you need to suppress the upgrade of the Seaside30
project during the load of the SeasideRest project and you can do that
with the use of the `onUpgrade:` message:

```Smalltalk
Metacello new
  configuration: 'SeasideRest';
  version: #stable;
  onUpgrade: [:ex :existing :new | 
    existing baseName = 'Seaside30'
      ifTrue: [ ex disallow ].
    ex pass ];
  load.
```

The `onUpgrade:` block tells Metacello to disallow the upgrade of any
project whose `baseName` is `Seaside30` and to continue with the load.
Of course if there are any explicit dependencies between SeasideRest and
the later version of Seaside30 (missing classes, etc.) then you may very
well get load errors or errors while using the SeasideRest, but that's
the price you pay for not upgrading.

### Upgrading a locked project

If you want to explicitly upgrade a locked project, you can use the
`load` command. The following command will upgrade Seaside30 to version
3.0.6 even if it is locked:

 ```Smalltalk
Metacello image
  configuration: 'Seaside30';
  version: '3.0.6';
  lock.
```

The newly loaded of the project will continue to be locked.

[1]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md
[2]: http://www.lukas-renggli.ch/blog/gofer
[3]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#repository-descriptions
[4]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#repository-shortcuts
[5]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#loading
[6]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#listing
[7]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#metacelloprojectspec
[8]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#metacello-project-registry
[9]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#locking
[10]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloScriptingAPI.md#metacello-version-numbers
[11]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloUserGuide.md#get-a-new-version-of-the-configuration
[12]: https://github.com/dalehenrich/metacello-work/blob/master/docs/MetacelloUserGuide.md#load-the-new-version!


!Metacello methodsFor: 'private' stamp: 'dkh 5/31/2012 17:57:13'!
addStatement: selector args: args
    self statements add: selector -> args! !

!Metacello methodsFor: 'private' stamp: 'dkh 7/12/2012 14:29'!
execute
    | script |
    script := self statements.
    self statements: nil.
    ^ self scriptExecutor execute: script! !


!Metacello methodsFor: 'api projectSpec' stamp: 'dkh 7/12/2012 13:45'!
baseline: projectName
    self addStatement: #'baselineArg:' args: {projectName}! !

!Metacello methodsFor: 'api projectSpec' stamp: 'dkh 7/12/2012 13:45'!
className: className
    self addStatement: #'classNameArg:' args: {className}! !

!Metacello methodsFor: 'api projectSpec' stamp: 'dkh 7/12/2012 13:46'!
configuration: projectName
    self addStatement: #'configurationArg:' args: {projectName}! !

!Metacello methodsFor: 'api projectSpec' stamp: 'dkh 7/12/2012 13:46'!
project: projectName
    self addStatement: #'projectArg:' args: {projectName}! !

!Metacello methodsFor: 'api projectSpec' stamp: 'dkh 7/12/2012 13:46'!
repository: repositoryDescription
    self addStatement: #'repositoryArg:' args: {repositoryDescription}! !

!Metacello methodsFor: 'api projectSpec' stamp: 'dkh 7/12/2012 13:46'!
version: versionString
    self addStatement: #'versionArg:' args: {versionString}! !


!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:46'!
blueplane: projectName
    self repository: 'http://squeaksource.blueplane.jp/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:48'!
croquet: projectName
    self repository: 'http://hedgehog.software.umn.edu:8888/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:48'!
gemsource: projectName
    self repository: 'http://seaside.gemstone.com/ss/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:48'!
impara: projectName
    self repository: 'http://source.impara.de/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:48'!
renggli: projectName
    self repository: 'http://source.lukas-renggli.ch/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:49'!
saltypickle: projectName
    self repository: 'http://squeak.saltypickle.com/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:49'!
squeakfoundation: projectName
    self repository: 'http://source.squeakfoundation.org/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:50'!
squeaksource3: projectName
    self repository: 'http://ss3.gemstone.com/ss/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:50'!
squeaksource: projectName
    self repository: 'http://www.squeaksource.com/' , projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:46'!
ss3: projectName
    self squeaksource3: projectName! !

!Metacello methodsFor: 'api repository shortcuts' stamp: 'dkh 7/17/2012 16:50'!
wiresong: projectName
    self repository: 'http://source.wiresong.ca/' , projectName! !


!Metacello methodsFor: 'api options' stamp: 'dkh 7/23/2012 16:17'!
cacheRepository: aRepositoryDescription
    self addStatement: #'cacheRepository:' args: {aRepositoryDescription}! !

!Metacello methodsFor: 'api options' stamp: 'dkh 6/13/2012 16:05'!
ignoreImage
    "ignore image state"

    self addStatement: #'ignoreImage:' args: {true}! !

!Metacello methodsFor: 'api options' stamp: 'dkh 6/7/2012 15:34'!
onConflict: aBlock
    self addStatement: #'onConflict:' args: {aBlock}! !

!Metacello methodsFor: 'api options' stamp: 'dkh 6/8/2012 14:03:46'!
onDowngrade: aBlock
    self addStatement: #'onDowngrade:' args: {aBlock}! !

!Metacello methodsFor: 'api options' stamp: 'dkh 6/7/2012 15:33'!
onUpgrade: aBlock
    self addStatement: #'onUpgrade:' args: {aBlock}! !

!Metacello methodsFor: 'api options' stamp: 'dkh 7/23/2012 19:27'!
repositoryOverrides: aRepositoryDescriptionCollection
    self addStatement: #'repositoryOverrides:' args: {aRepositoryDescriptionCollection}! !

!Metacello methodsFor: 'api options' stamp: 'dkh 5/31/2012 17:57:13'!
silently
    "no progress bars"

    self addStatement: #'silently:' args: {true}! !


!Metacello methodsFor: 'accessing' stamp: 'dkh 7/13/2012 09:12'!
executorSpec
    executorSpec ifNil: [ executorSpec := #'MetacelloScriptApiExecutor' -> 'batch' ].
    ^ executorSpec! !

!Metacello methodsFor: 'accessing' stamp: 'dkh 7/13/2012 09:13'!
executorSpec: anAssoc
    executorSpec := anAssoc! !

!Metacello methodsFor: 'accessing' stamp: 'dkh 7/13/2012 09:16'!
scriptExecutor
    ^ (self class scriptExecutorClass: self executorSpec) new! !

!Metacello methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
statements
    statements ifNil: [ statements := OrderedCollection new ].
    ^ statements! !

!Metacello methodsFor: 'accessing' stamp: 'dkh 5/31/2012 17:57:13'!
statements: anObject
	statements := anObject! !


!Metacello methodsFor: 'api actions' stamp: 'dkh 7/23/2012 15:55'!
fetch
    self addStatement: #'fetch:' args: #(#()).
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 7/23/2012 15:49'!
fetch: required
    self addStatement: #'fetch:' args: {required}.
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 5/31/2012 17:57:13'!
get
    "resolve project name in given repository and return an instance of MetacelloProject resolved from a ConfigurationOf or BaselineOf"

    self addStatement: #'get' args: #().
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 7/13/2012 16:35'!
list
    "list projects in registry"

    self addStatement: #'list' args: #().
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 7/23/2012 15:56'!
load
    self addStatement: #'load:' args: #(#()).
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 5/31/2012 17:57:13'!
load: required
    self addStatement: #'load:' args: {required}.
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 7/17/2012 10:53'!
lock
    "lock projects in registry"

    self addStatement: #'lock' args: #().
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 7/23/2012 15:56'!
record
    self addStatement: #'record:' args: #(#()).
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 7/19/2012 07:40'!
record: required
    self addStatement: #'record:' args: {required}.
    ^ self execute! !

!Metacello methodsFor: 'api actions' stamp: 'dkh 7/17/2012 12:31'!
unlock
    "unlock projects in registry"

    self addStatement: #'unlock' args: #().
    ^ self execute! !

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

!Metacello class methodsFor: 'instance creation' stamp: 'dkh 7/16/2012 10:12'!
image
    ^ self new
        executorSpec: #'MetacelloScriptImageExecutor' -> 'batch';
        yourself! !

!Metacello class methodsFor: 'instance creation' stamp: 'dkh 7/13/2012 09:13'!
registry
    ^ self new
        executorSpec: #'MetacelloScriptRegistryExecutor' -> 'batch';
        yourself! !


!Metacello class methodsFor: 'private' stamp: 'dkh 7/13/2012 09:08'!
scriptExecutorClass
    ^ self scriptExecutorClass: {(#'MetacelloScriptApiExecutor' -> 'batch')}! !

!Metacello class methodsFor: 'private' stamp: 'dkh 7/13/2012 09:15'!
scriptExecutorClass: anExecutorSpec
    Smalltalk at: anExecutorSpec key ifAbsent: [ ConfigurationOf ensureMetacello: anExecutorSpec value ].
    ^ Smalltalk at: anExecutorSpec key! !

