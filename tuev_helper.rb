require 'tuev'

Tuev::qunit_tests << {:include => 'tests/qunit/**/*.js',
                      :dependencies => 'public/javascripts/**/*.js',
                      :one_file_per_test => true,
                      :exclude => 'config.js'}


Tuev::selenium_tests << ['selenium/**/*.rb]

Tuev::start
