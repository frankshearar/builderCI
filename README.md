## Intro
[Serge got things started](https://github.com/SergeStinckwich/PlayerST) 
using [Lukas' builder](https://github.com/renggli/builder), with [travis-ci](http://travis-ci.org/), so I'm aiming
to team up [Metacello](https://github.com/dalehenrich/metacello-work) and **builder** to make the 
setup and maintenance of CI test scripts for [Pharo](http://www.pharo-project.org/home) 
and [Squeak](http://www.squeak.org/) as painless as possible ...

## Using builderCI

1. Read [Travis CI docs](http://about.travis-ci.org/docs/)
2. Create your own .travis.yml file by copying [the template travis.yml][1] into the 
   home directory of your git project. 
3. Decide which platforms you want tested (Squeak4.3 and/or Pharo1.3) and edit the .travis.yml 
   file to create your test matrix. If you 
   are using [Metacello][3] with your project you shouldn't have to make any other edits.
3. Create a [tests/travisCI.st][2] that contains the code to load your project, it's tests and launch 
   the test harness.
4. Enjoy.

## Projects using TravisCi and builderCI

* [Metacello](https://github.com/dalehenrich/metacello-work)
* [FileTree](https://github.com/dalehenrich/filetree)
* [Ston](https://github.com/dalehenrich/ston)

### Travis CI results

[![Build Status](https://secure.travis-ci.org/dalehenrich/builderCI.png?branch=master)](http://travis-ci.org/dalehenrich/builderCI)

[1]: https://github.com/dalehenrich/builderCI/blob/master/templates/travis.yml
[2]: https://github.com/dalehenrich/builderCI/blob/master/templates/travisCI.st
[3]: https://github.com/dalehenrich/metacello-work/blob/master/README.md
