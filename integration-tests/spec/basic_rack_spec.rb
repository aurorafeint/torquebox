require 'spec_helper'

shared_examples_for "basic rack" do

  before(:each) do
    visit "/basic-rack"
    page.should have_content('it worked')
  end

  it "should work" do
    page.find("#success")[:class].strip.should == 'basic-rack'
  end

  it "should be running under the proper ruby version" do
    page.find("#ruby-version").text.strip.should == RUBY_VERSION
  end

  it "should not have a vfs path for __FILE__" do
    page.find("#path").text.strip.should_not match(/^vfs:/)
  end

  it "should set ENV['TORQUEBOX_CONTEXT'] to 'web'" do
    page.find("#context").text.strip.should == 'web'
  end

end

describe "basic rack test with heredoc" do

  deploy <<-END.gsub(/^ {4}/,'')

    application:
      root: #{File.dirname(__FILE__)}/../apps/rack/basic
      env: development
    web:
      context: /basic-rack
    ruby:
      version: #{RUBY_VERSION[0,3]}

  END

  it_should_behave_like "basic rack"

end

describe "basic rack test with hash" do

  deploy( :application => { :root => "#{File.dirname(__FILE__)}/../apps/rack/basic", :env => 'development' },
          :web => { :context => '/basic-rack' },
          :ruby => { :version => RUBY_VERSION[0,3] } )  

  
  it_should_behave_like "basic rack"

end

describe "back rack with JRUBY_OPTS" do

  deploy <<-END.gsub(/^ {4}/,'')

    application:
      root: #{File.dirname(__FILE__)}/../apps/rack/basic
      env: development
    web:
      context: /basic-rack
    environment:
      JRUBY_OPTS: --#{RUBY_VERSION[0,3]}

  END

  it_should_behave_like "basic rack"

end
