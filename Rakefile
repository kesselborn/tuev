require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "tuev"
  gem.homepage = "http://github.com/kesselborn/tuev"
  gem.license = "MIT"
  gem.summary = %Q{run qunit & selenium tests with rake}
  gem.description = %Q{...}
  gem.email = "daniel@soundcloud.com"
  gem.authors = ["kesselborn"]
  gem.executables = ["tuev"]
  gem.files.include "contrib/qunit/qunit/qunit.css"
  gem.files.include "contrib/qunit/qunit/qunit.js"
  gem.files.include "contrib/mockjax/jquery.mockjax.js"
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |spec|
  spec.libs << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
