require "selenium/client"
class QunitRunner 
  def initialize(path)
    @test_file = path
  end

  def run
    @browser = "*firefox"
    selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => @browser,
      :url => "file://#{@test_file}",
      :timeout_in_second => 60

    selenium.start_new_browser_session

    selenium.open @test_file
    selenium.wait_for_page_to_load "60000"
    puts "\n\n\n****** testing #{selenium.get_text('css=title')} in #{@browser}"
    60.times{ break if (selenium.is_element_present("id=qunit-testresult") rescue false); sleep 1 }
    puts selenium.get_eval('window.results.join("\n")')
    60.times{ break if (selenium.get_text('id=qunit-testresult') != "Running..." rescue false); sleep 1 }
    puts selenium.get_text('id=qunit-testresult')

    num_of_errors = selenium.get_text("css=#qunit-testresult .failed").to_i
    selenium.close_current_browser_session

    num_of_errors
  end
end
