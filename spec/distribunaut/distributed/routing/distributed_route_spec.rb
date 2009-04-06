require File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper")

describe "distributed_url" do
  
  before(:each) do
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
    configatron.mack.distributed.share_routes = true
    configatron.mack.distributed.app_name = :known_app
    configatron.mack.distributed.site_domain = 'http://localhost:3001'
    Distribunaut::Routes.build do |r| # force the routes to go the DRb server
      r.known "/my_known_app/my_known_url", :controller => :foo, :action => :bar
      r.known_w_opts "/my_known_app/my_known_url_w_opts/:id", :controller => :foo, :action => :bar
    end
  end
  
  after(:each) do
    configatron.mack.distributed.share_routes = false
    configatron.mack.distributed.app_name = nil
    configatron.mack.distributed.site_domain = nil
  end
  
  it "should raise error when unknown app url is requested" do
    lambda { distributed_url(:unknown_app, :foo_url) }.should raise_error(Rinda::RequestExpiredError)
  end
  
  # it "should raise error when unknown named route is requested" do
  #   lambda { distributed_url(:unknown_app, :unknown_url) }.should raise_error(Distribunaut::Distributed::Errors::UnknownRouteName)
  # end
  
  it "should be able to resolve d-route url" do
    distributed_url(:known_app, :known_url).should == "#{configatron.mack.distributed.site_domain}/my_known_app/my_known_url"
    distributed_url(:known_app, :known).should == "#{configatron.mack.distributed.site_domain}/my_known_app/my_known_url"
    distributed_url(:known_app, :known_distributed_url).should == "#{configatron.mack.distributed.site_domain}/my_known_app/my_known_url"
  end
  
  it "should be able to resolve d-route url with options" do
    distributed_url(:known_app, :known_w_opts_url, :id => 1).should ==
               "#{configatron.mack.distributed.site_domain}/my_known_app/my_known_url_w_opts/1"
  end
  
  it "should raise error when registering a nil application" do
    temp_app_config(:mack => {:distributed => {:app_name => nil}}) do
      lambda { Distribunaut::Routes.build {|r|} }.should raise_error(Distribunaut::Distributed::Errors::ApplicationNameUndefined)
    end
  end
  
end