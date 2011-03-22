require 'tuev/tuev.rb'
require 'yaml'

Tuev.gem_path = Gem.searcher.find('tuev').full_gem_path

if defined?(TESTING)
  Tuev.cwd = File.join(Dir.pwd, "spec", "fixtures", "fake_root")
else
  Tuev.cwd = Dir.pwd
  Dir["#{Tuev.gem_path}/lib/tasks/*.rake"].each { |ext| load ext }
end

config_file = File.join(Tuev.cwd, "config/tuev.yml")
Tuev.config = YAML.load_file(config_file) if File.exists?(config_file)
