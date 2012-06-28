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
   file to create your build matrix. If you 
   are using [Metacello][3] with your project you shouldn't have to make any other edits. Metacello
   and FileTree are pre-installed in the image.
3. Create a [tests/travisCI.st][2] that contains the code to load your project, it's tests and launch 
   the test harness.
4. Enjoy.

## Dealing with Failure

Here's a [the output for a build that failed][4] because of unit test failures. Scroll to
the bottom of the console list and you'll see the following:

```
***********************************************
	Results for builderCI Test Suite
3 run, 1 passes, 0 expected failures, 1 failures, 1 errors, 0 unexpected passes
***********************************************
*** FAILURES *******************
	SampleTest debug: #testFailure.
*** ERRORS *******************
	SampleTest debug: #testError.
***********************************************
```

Tests that *fail* or produce *error* are listed. You should be able to
copy the the expressions and evaluate them in a workspace:

```Smalltalk
SampleTest debug: #testError.
```

## Debugging Travis CI scripts

At the beginning of the run, everthing written to the **Transcript** is routed to to the *TravisTranscript.txt* file. You can list the contents of the file by including the following line in your `.travis.yml` file:

```yml
   - cat TravisTranscript.txt
```

or conditionally dump the *TravisTranscript.txt* file upon an error:

```yml
   - if ( test -e PharoDebug.log ); then cat TravisTranscript.txt; fi
   - if ( test -e PharoDebug.log ); then cat PharoDebug.log; fi
   - if ( test -e PharoDebug.log ); then die; fi
```

## Projects using TravisCi and builderCI

* [Metacello](https://github.com/dalehenrich/metacello-work)
* [FileTree](https://github.com/dalehenrich/filetree)
* [Ston](https://github.com/dalehenrich/ston)

### Travis CI results

[![Build Status](https://secure.travis-ci.org/dalehenrich/builderCI.png?branch=master)](http://travis-ci.org/dalehenrich/builderCI)

[1]: https://github.com/dalehenrich/builderCI/blob/master/templates/travis.yml
[2]: https://github.com/dalehenrich/builderCI/blob/master/templates/travisCI.st
[3]: https://github.com/dalehenrich/metacello-work/blob/master/README.md
[4]: http://travis-ci.org/#!/dalehenrich/sample/jobs/1647159


