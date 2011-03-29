require "selenium/client"
class QunitRunner 
  def initialize(path, selenium_conf)
    @test_file = path
    @selenium_conf = selenium_conf
  end

  def run_in_browser(browser_string)
    selenium = Selenium::Client::Driver.new(
      :host => @selenium_conf[:host],
      :port => @selenium_conf[:port],
      :browser => browser_string,
      :url => "file://",
      :timeout_in_second => 60
    )

    selenium.start_new_browser_session
    yield(selenium)
    selenium.close_current_browser_session

  end

  def run
    num_of_errors = 0

    @selenium_conf[:browsers].each do |browser_id|
      run_in_browser(browser_id) do |browser|
        browser.open "file://#{@test_file}"
        browser.wait_for_page_to_load "60000"
        puts "\n****** testing #{browser.get_text('css=title')} in #{browser_id}"
        60.times{ break if (browser.is_element_present("id=qunit-testresult") rescue false); sleep 1 }
        puts browser.get_eval('window.results.join("\n")')
        60.times{ break if (browser.get_text('id=qunit-testresult') != "Running..." rescue false); sleep 1 }
        puts browser.get_text('id=qunit-testresult')
        num_of_errors += browser.get_text("css=#qunit-testresult .failed").to_i
      end
    end
    num_of_errors
  end
end
