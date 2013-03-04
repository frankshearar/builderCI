| versionString |
"upgrade to GemStone 1.0-beta.8.7.2 ... earliest support for FileTree"
ConfigurationOfMetacello project currentVersion versionNumber < '1.0-beta.31.1' asMetacelloVersionNumber 
    ifTrue: [
        "load basic Metacello packages for version 1.0-beta.31.1. 
	 To load GLASS 1.0-beta.8.7.2:
	  - Metacello must handle symbolic versions
	  - MetacelloSkipDirtyPackageLoad needs to be defined"
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
versionString := '1.0-beta.8.7.2'.
ConfigurationOfGLASS project currentVersion < versionString asMetacelloVersionNumber 
    ifTrue: [ 
	Smalltalk 
	    at: #MetacelloSkipDirtyPackageLoad
	    ifPresent: [:cl |
		[
		(ConfigurationOfGLASS project version: versionString) load: #( 'Core' 'Monticello' 'Gofer Project Loader' ).
		(ConfigurationOfGLASS project version: versionString) load ]
			on: cl do: [:ex | ex resume: false ]]]

