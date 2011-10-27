require 'spec_helper'

describe "QunitRunner" do
  it "should detect correctly whether we have a local file or not" do
    QunitRunner.new("http://example.com", "").local_file?.should == false
    QunitRunner.new("https://example.com", "").local_file?.should == false
    QunitRunner.new("/tmp/foo", "").local_file?.should == true
    QunitRunner.new("file:///tmp/foo", "").local_file?.should == true
    QunitRunner.new("../foo", "").local_file?.should == true
  end

  it "should detect the base host correctly" do
    QunitRunner.new("http://example.com:1234", "").host.should == "http://example.com:1234"
    QunitRunner.new("http://example.com:1234/", "").host.should == "http://example.com:1234"
    QunitRunner.new("http://example.com:1234/lirumlarum", "").host.should == "http://example.com:1234"

    QunitRunner.new("https://example.com:1234", "").host.should == "https://example.com:1234"
    QunitRunner.new("https://example.com:1234/", "").host.should == "https://example.com:1234"
    QunitRunner.new("https://example.com:1234/lirumlarum", "").host.should == "https://example.com:1234"

    QunitRunner.new("http://example.com", "").host.should == "http://example.com"
    QunitRunner.new("http://example.com/", "").host.should == "http://example.com"
    QunitRunner.new("http://example.com/lirumlarum", "").host.should == "http://example.com"

    QunitRunner.new("https://example.com", "").host.should == "https://example.com"
    QunitRunner.new("https://example.com/", "").host.should == "https://example.com"
    QunitRunner.new("https://example.com/lirumlarum", "").host.should == "https://example.com"

    QunitRunner.new("/tmp/foo", "").host.should == "file://"
    QunitRunner.new("file:///tmp/foo", "").host.should == "file://"
    QunitRunner.new("../foo", "").host.should == "file://"
  end

  it "should detect the base path correctly" do
    QunitRunner.new("http://example.com", "").path.should == ""
    QunitRunner.new("http://example.com/", "").path.should == "/"
    QunitRunner.new("http://example.com/lirumlarum", "").path.should == "/lirumlarum"

    QunitRunner.new("https://example.com", "").path.should == ""
    QunitRunner.new("https://example.com/", "").path.should == "/"
    QunitRunner.new("https://example.com/lirumlarum", "").path.should == "/lirumlarum"

    QunitRunner.new("/tmp/foo", "").path.should == "file:///tmp/foo"
    QunitRunner.new("file:///tmp/foo", "").path.should == "file:///tmp/foo"
    QunitRunner.new("../foo", "").path.should == "file://#{File.expand_path("../foo")}"
  end

end
