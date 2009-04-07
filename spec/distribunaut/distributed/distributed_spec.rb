require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Distribunaut::Distributed do
  
  before(:each) do
    configatron.distribunaut.share_objects = true
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
  end
  
  after(:each) do
    configatron.distribunaut.share_objects = false
  end
  
  it "should recognize undefined constants and return it from rinda" do
    configatron.temp do
      configatron.distribunaut.app_name = :testing_app
      class Computer
        include Distribunaut::Distributable
        def processor
          "Intel"
        end
      end
      puts Distribunaut::Distributed::Computer.class.inspect
      Distribunaut::Distributed::Computer.should be_kind_of(Distribunaut::Distributed::ComputerProxy)
      comp = Distribunaut::Distributed::Computer.new
      comp.processor.should == "Intel"
    end
  end
  
  it "should recognize undefined constants and raise an error if it's not found in rinda" do
    lambda {
      Distribunaut::Distributed::Keyboard
    }.should raise_error(Rinda::RequestExpiredError)
  end
  
  it "should raise Distribunaut::Distributed::Errors::ApplicationNameUndefined if configatron.distribunaut.app_name is nil" do
    lambda {
      class Mouse
        include Distribunaut::Distributable
      end
    }.should raise_error(Distribunaut::Distributed::Errors::ApplicationNameUndefined)
  end
  
  describe "lookup" do
    
    it "should look up and return a specific service from rinda" do
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :app_1, :space => :Test, :object => "Hello World!")
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :app_2, :space => :Test, :object => "Hello WORLD!")
      Distribunaut::Distributed.lookup("distributed://app_1/Test").should == "Hello World!"
      Distribunaut::Distributed.lookup("distributed://app_2/Test").should == "Hello WORLD!"
    end
    
  end
  
end