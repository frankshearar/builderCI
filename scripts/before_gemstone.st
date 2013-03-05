| glassVersion versionString |
"upgrade to GemStone 1.0-beta.8.7.2 ... earliest support for FileTree"
glassVersion := ConfigurationOfGLASS project currentVersion.
versionString := '1.0-beta.8.7.2'.
Transcript cr; show: 'GLASS: ', glassVersion versionString.
Transcript cr; show: 'Metacello: ' , ConfigurationOfMetacello project currentVersion versionNumber versionString.
glassVersion versionNumber >= versionString asMetacelloVersionNumber 
    ifTrue: [ 
        Transcript cr; show: 'GLASS up-to-date'.
	^nil].
ConfigurationOfMetacello project currentVersion versionNumber < '1.0-beta.31.1' asMetacelloVersionNumber 
    ifTrue: [
        "load basic Metacello packages for version 1.0-beta.31.1. 
	 To load GLASS 1.0-beta.8.7.2:
	  - Metacello must handle symbolic versions
	  - MetacelloSkipDirtyPackageLoad needs to be defined"
	Transcript cr; show: 'load basic Metacello packages for version 1.0-beta.31.1'.
	((Smalltalk at: #Gofer) new)
		gemsource: 'metacello';
		version: 'Metacello-Base-DaleHenrichs.19';
		version: 'Metacello-Core-dkh.468';
		version: 'Metacello-MC-dkh.531';
		load.
	((Smalltalk at: #Gofer) new)
		gemsource: 'metacello';
		version: 'Metacello-Platform.gemstone-dkh.23';
		load ].
[
(ConfigurationOfGLASS project version: versionString) load: #( 'Core' 'Monticello' 'Gofer Project Loader' ).
(ConfigurationOfGLASS project version: versionString) load ]
	on: (Smalltalk at: #MetacelloSkipDirtyPackageLoad) 
	do: [:ex | ex resume: false ]

