$browsers = ENV['BROWSERS'] && ENV['BROWSERS'].split(",") || ["*firefox", "*safari"]

def run_test
  $browsers.each do |browserstring|
    browser = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 5555,
      :browser => browserstring,
      :url => "http://deck.s-cloud.net",
      :timeout_in_second => 60

    browser.start_new_browser_session

    yield(browser)

    browser.close_current_browser_session
  end
end

def goto_start_state(browser)
  browser.open "/"
  browser.refresh
  browser.wait_for_page_to_load "60000"
  browser.click "link=logout"
  browser.wait_for_page_to_load "60000"
end

def login(browser)
  goto_start_state(browser)
  browser.type "id=login-username", "arms-test"
  browser.type "name=password", "geheim"
  browser.click "css=#login-form input[type=submit]"
  wait{ browser.is_element_present("css=body.logging-in-state") }
  wait{ browser.is_element_present("css=body.whitelist-view-state") }
end

def delete_all_whitelisted_users(browser)
  while browser.is_element_present("css=#whitelisted-users-list tbody.user") do
    browser.click "css=.revoke"
    browser.get_confirmation
    wait{ !browser.is_element_present("css=tr.pending-state-true") }
  end

  wait(60, "*** error while deleting all whitelist users") do 
    !browser.is_element_present("css=#whitelisted-users-list tbody.user") 
  end
end

def add_a_user(browser)
  if !browser.is_element_present("css=#whitelisted-users-list tbody.user") 
    browser.click "id=show-hide-add-user-dialog"
    wait{ browser.is_element_present("css=body.add-user-state") }
    browser.type "id=search-term", "arms-test"
    browser.click "name=commit"
    wait{ browser.is_element_present("css=body.show-search-result-state") }
    browser.check "name=new-whitelist-users"
    browser.type "name=note", "test-adding"
    browser.click "id=submit"
    wait(15, "no pending state when adding user #{__FILE__} / #{__LINE__}") do
      browser.is_element_present("css=tr.pending-state-true") 
    end
    wait{ !browser.is_element_present("css=tr.pending-state-true") }
    wait{ browser.is_element_present("css=#whitelisted-users-list tbody.user") }
  end
end

def wait(timeout = 30, message = "")
  assert !timeout.times{ break if (yield rescue false); sleep 1 },
    message
end
