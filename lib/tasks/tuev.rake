require 'fileutils'
require 'rake'

def ansi_colors(color)
  case color
  when :green then ["\033[32m", "\033[0m"]
  when :red   then ["\033[31m", "\033[0m"]
  else ['','']
  end
end

def cp_if_not_already_there(source, destination)
  destination_expanded = File.join(Tuev.cwd, destination)
  source_expanded = File.join(Tuev.gem_path, source)
  print "%-60s" % destination

  if File.exists?(destination_expanded)
    prefix, suffix = ansi_colors(:red)
    puts "#{prefix} ... already exists ... skipping#{suffix}"
  else
    FileUtils.cp(source_expanded, destination_expanded)
    prefix, suffix = ansi_colors(:green)
    puts "#{prefix} ... copied#{suffix}"
  end
end

def mkdir_if_not_already_there(dir)
  dir_expanded = File.join(Tuev.cwd, dir)
  print "%-60s" % "#{dir}"

  if File.exists?(dir_expanded)
    prefix, suffix = ansi_colors(:red)
    puts "#{prefix} ... directory already exists#{suffix}"
  else
    FileUtils.mkdir_p(dir_expanded)
    prefix, suffix = ansi_colors(:green)
    puts "#{prefix} ... directory created#{suffix}"
  end
end

namespace :tuev do
  desc "prepare this project for tuev tests (create sample files, download qunit & friends)"
  task :prepare do
    mkdir_if_not_already_there("config")
    cp_if_not_already_there("contrib/tuev.yml", "config/tuev.yml")

    mkdir_if_not_already_there("test/tuev/qunit")
    mkdir_if_not_already_there("test/tuev/test_files")
    cp_if_not_already_there("contrib/tuev_helper.rb", "test/tuev_helper.rb")

    mkdir_if_not_already_there("test/tuev/contrib")
    cp_if_not_already_there("contrib/qunit/qunit/qunit.css",
                            File.join(Tuev.contrib_dir, "qunit.css"))
    cp_if_not_already_there("contrib/qunit/qunit/qunit.js",
                            File.join(Tuev.contrib_dir, "qunit.js"))
    cp_if_not_already_there("contrib/mockjax/jquery.mockjax.js",
                            File.join(Tuev.contrib_dir, "jquery.mockjax.js"))
    cp_if_not_already_there("contrib/test_default.html", 
                            File.join(Tuev.contrib_dir, "test_default.html"))
    cp_if_not_already_there("contrib/tuev_qunit.js", 
                            File.join(Tuev.contrib_dir, "tuev_qunit.js"))
  end

  desc "run tests"
  task :run do
    puts Tuev.config.inspect
  end

  desc "create static testfiles for qunit tests"
  task :create_testfiles => :clean_testfiles do
    files = []
    Tuev.test_suites.each do |test_suite|
      files << test_suite.create_test_files
    end

    puts "Created the following test files:\n\t#{files.join("\n\t")}"
  end

  desc "delete all statically created testfiles"
  task :clean_testfiles do
    FileUtils.rm_f(Dir.glob(File.join(Tuev.test_out, "*.html")))
  end
end
