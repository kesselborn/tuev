tuev
====

In a nutshell
-------------
tuev is a little helper program that makes it easy to run qunit-tests using 
Seleinum. 

Why do you want this?
---------------------
It makes it possible to start qunit test from a script and evaluate by the 
return code whether tests pass or not. Combine it with ... and you have
CI-able testing for qunit tests

Kickstart
=========
Install gem with

    gem install tuev

or, if you use bundler for your project, add the line

    gem 'tuev'

to your Gemfile. 

If you want to use tuev's rake tasks, add 

    require 'bundler/setup' # if you use bundler
    require 'tuev'

Usage
=====
Command line utility
--------------------
Call

    tuev <qunit-html-file>

for more info, call

    tuev -h

Rake tasks
----------


Contributing to tuev
--------------------
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2011 kesselborn. See LICENSE.txt for
further details.

