require 'erb'

class Tuev
  @contrib_dir = "tests/tuev/contrib"
  class << self
    attr_accessor :cwd, :gem_path, :config, :contrib_dir, :read_config
  end

  def self.read_config
    config_file = ENV['TUEV_CONFIG'] || File.join(Tuev.cwd, "config/tuev.yml")

    if File.exists?(config_file)
      @config = YAML.load_file(config_file)
    else
      raise "\n\nERROR: Can't find '#{config_file}' ... create it or set TUEV_CONFIG to point to a valid tuev.yml\n\n"
    end
  end

  def self.config
    return @config ||= read_config
  end

  def self.test_suites
    config["test_suites"].inject([]) do |memo, test_suite_conf|
      memo << TestSuite.new(test_suite_conf)
    end
  end

  def self.test_out
    config["tests_out"] || "/tmp"
  end

  def self.selenium_conf
    @selenium_conf ||= {
       :host     => config["selenium"]["host"],
       :port     => config["selenium"]["port"],
       :browsers => [*config["selenium"]["browsers"]]
    }
  end

  class TestSuite
    def initialize(test_suite_config)
      begin
        @test_file_template = File.join(Tuev.cwd, test_suite_config["test_file_template"])
      rescue
        raise "could not find 'test_file_template' setting for current suite"
      end

      @jquery_js       = file_url(Tuev.contrib_dir, "jquery-1.5.1.js")
      @mockjax_js      = file_url(Tuev.contrib_dir, "jquery.mockjax.js")
      @qunit_js        = file_url(Tuev.contrib_dir, "qunit.js")
      @tuev_qunit_js   = file_url(Tuev.contrib_dir, "tuev_qunit.js")
      @qunit_css       = file_url(Tuev.contrib_dir, "qunit.css")
      @test_suite_name = test_suite_config["name"]

      @combine_tests   =  test_suite_config["combine_tests"]

      @test_set = @tests   = build_file_list(test_suite_config["test_files"])

      @dependencies = build_file_list(test_suite_config["dependencies"])
    end

    def create_test_files
      files = []
      if ENV['COMBINE_TESTS'] == 'true' || (ENV['COMBINE_TESTS'] != 'false' && @combine_tests)
        files << File.join(out_path, "#{@test_suite_name}.html")

        @test_set_name = title_from_filename(files.last)
        @test_set = @tests
        save(render_template(@tests), files.last)
      else
        @tests.each do |test|
          files << File.join(out_path, "#{@test_suite_name}_#{test.gsub('file://','').gsub(Tuev.cwd, '').tr('/.','_')}.html")

          @test_set_name = title_from_filename(files.last)
          @test_set = [test]
          save(render_template(test), files.last)
        end
      end

      files
    end

    private
    def title_from_filename(filename)
      filename.gsub(/#{out_path}[\/]*/, '').gsub('.html','').gsub('_js','').gsub('_',' ')
    end

    def out_path
      Tuev.test_out
    end

    def save(source_code, filename)
      File.open(filename, "w") do |f|
        f << source_code
      end
    end

    def render_template(tests)
      template = ERB.new(File.read(@test_file_template))
      template.result(binding)
    end


    def build_file_list(includes_and_excludes)
      file_list = [*includes_and_excludes["include"]].map do |pattern| 
        files = Dir.glob(pattern)
        if files.empty?
          raise "could not find file matching '#{pattern}'"
        end
        files
      end

      file_list.flatten!

      if excludes = includes_and_excludes["exclude"]
        [*excludes].each do |exclude_regexp|
          file_list.delete_if{|x| x =~ /#{exclude_regexp}/ }
        end
      end


      file_list.map{|x| file_url(x)}
    end

    def file_url(*relativ_path_parts)
      "file://#{File.expand_path(File.join(Tuev.cwd, *relativ_path_parts))}"
    end
  end
end
