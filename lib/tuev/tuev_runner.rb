require "selenium/client"
class QunitRunner
  def initialize(path, selenium_conf)
    @test_file = path

    if local_file? && !(@test_file =~ /file:\/\//)
      @test_file = "file://#{File.expand_path(@test_file)}"
    end

    @selenium_conf = selenium_conf
  end

  def local_file?
    # it's a local file if it has not any protocoll or the file:// protcoll
    !(@test_file =~ /:\/\//) || !!(@test_file =~ /file:\/\//)
  end

  def split_url
    @test_file.match(/(.*:\/\/[^\/]+)(.*)$/)
  end

  # host & path as is needed below ...
  def host
    local_file? ? "file://" : split_url[1]
  end

  def path
    local_file? ? @test_file : split_url[2]
  end


  def run_in_browser(browser_string)
    begin
      Net::HTTP.new(@selenium_conf[:host], @selenium_conf[:port]).get2("/")
    rescue
      puts
      puts "It seems that there is no selenium server listening on '#{@selenium_conf[:host]}:#{@selenium_conf[:port]}'"
      puts
      puts "... aborting (try installing the gem 'selenium-server' and execute 'selenium-server' for an easy solution)"
      puts
      puts
      exit(1)
    end

    selenium = Selenium::Client::Driver.new(
      :host => @selenium_conf[:host],
      :port => @selenium_conf[:port],
      :browser => browser_string,
      :url => host,
      :timeout_in_second => 60
    )

    selenium.start_new_browser_session
    yield(selenium)
    selenium.close_current_browser_session

  end

  def run
    num_of_errors = 0
    errors = ""

    @selenium_conf[:browsers].each do |browser_id|
      run_in_browser(browser_id) do |browser|
        test_framework = ""

        browser.open path
        browser.wait_for_page_to_load "60000"
        puts "\ntesting on #{browser_id}: #{@test_file}\n\n"
        120.times{
          if  (browser.get_text("css=.jasmine_reporter") rescue false)
            test_framework = "jasmine"
            break
          end

          if (browser.get_text('id=qunit-testresult') != "Running..." rescue false)
            test_framework = "qunit"
            break
          end

          sleep 1
        }

        sleep 1

        output =""
        num_of_errors = 0
        if test_framework == "qunit"
          if browser.get_eval("typeof(window.results)") == "undefined"
            $stderr.puts "\tINFO: some lines of javascript will give you detailed testing output. For more info, see:"
            $stderr.puts "\thttps://github.com/kesselborn/tuev/raw/master/contrib/tuev_qunit.js"
            $stderr.puts
          else
            puts browser.get_eval('window.results.join("\n")')
            errors += browser.get_eval('window.errors.join("\n")')
          end

          output = browser.get_text('id=qunit-testresult')
          num_of_errors += browser.get_text("css=#qunit-testresult .failed").to_i
        else
          output = browser.get_eval('window.message')
          junit_output = browser.get_eval('window.junitXML')
          File.open("junit_results.xml", "w") do |f|
            f << junit_output
          end
          num_of_errors += browser.get_eval('window.isSuccess') ? 0 : 1
        end

        puts output
        puts

        num_of_errors
      end
    end

    unless errors == ""
      puts
      puts "Finished with these errors:"
      puts
      puts errors
    end

    num_of_errors
  end
end
