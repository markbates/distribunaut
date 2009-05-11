require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Distribunaut::Distributed do
  
  before(:each) do
  end
  
  after(:each) do
  end
  
  it "should recognize undefined constants and return it from rinda" do
    class Computer
      include Distribunaut::Distributable
      def processor
        "Intel"
      end
    end
    Distribunaut::Distributed::Computer.should be_kind_of(Distribunaut::Distributed::ComputerProxy)
    comp = Distribunaut::Distributed::Computer.new
    comp.processor.should == "Intel"
  end
  
  it "should recognize undefined constants and raise an error if it's not found in rinda" do
    lambda {
      Distribunaut::Distributed::Keyboard
    }.should raise_error(Rinda::RequestExpiredError)
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