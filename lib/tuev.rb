require 'tuev/tuev.rb'
require 'tuev/tuev_runner.rb'
require 'yaml'

Tuev.gem_path = Gem.searcher.find('tuev').full_gem_path

if defined?(TESTING)
  Tuev.cwd = File.join(Dir.pwd, "spec", "fixtures", "fake_root")
else
  Tuev.cwd = Dir.pwd
  Dir["#{Tuev.gem_path}/lib/tasks/*.rake"].each { |ext| load ext }
end

