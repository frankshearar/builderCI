"Load the Server-side support code for gci tests"
Transcript cr; show: 'travis---->gemstoneGCI.st'.

"Use the Sample project to verify that Metacello and FileTree are 
 booting correctly"

[Metacello new
  configuration: 'Sample';
  version: '0.9.0';
  repository: 'github://dalehenrich/sample:configuration';
  load: 'Tests' ]
        on: Warning
        do: [:ex |
                Transcript cr; show: 'Warning: ', ex description.
                ex resume: true].

"Don't run tests...those are run from the GCI client"
