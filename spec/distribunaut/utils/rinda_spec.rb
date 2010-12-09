require 'spec_helper'

describe Distribunaut::Utils::Rinda do
  
  describe 'available_services' do
    
    it 'should return an Array of Distribunaut::Tuple objects for all the available services' do
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :testing, :space => :String, :object => 'A', :description => "AAA")
      services = Distribunaut::Utils::Rinda.available_services
      services.first.should be_kind_of(Distribunaut::Tuple)
      services.first.app_name.should == :testing
      services.first.object.should == 'A'
    end
    
  end
  
  describe 'ring_server' do
    
    it "should have access to the ring server" do
      rs = Distribunaut::Utils::Rinda.ring_server
      rs.should_not be_nil
      rs.is_a?(Rinda::TupleSpace).should == true
    end
    
  end
  
  describe 'borrow' do
    
    it 'should lock a tuple for the duration of the block and then return it back at the end' do
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :testing, :space => :String, :object => 'A', :description => "AAA")
      obj = Distribunaut::Utils::Rinda.read(:app_name => :testing, :space => :String)
      obj.should_not be_nil
      obj.should == 'A'
      lambda do
        Distribunaut::Utils::Rinda.borrow(:app_name => :testing, :space => :String) do |tuple|
          tuple.object.should == 'A'
          tuple.space.to_s.should match(/(.+)\-onloan\-.+$/)
          lambda{Distribunaut::Utils::Rinda.read(:app_name => :testing, :space => :String)}.should raise_error(Rinda::RequestExpiredError)
          raise Distribunaut::TestingError.new
        end
      end.should raise_error(Distribunaut::TestingError)
      
      obj = Distribunaut::Utils::Rinda.read(:app_name => :testing, :space => :String)
      obj.should_not be_nil
      obj.should == 'A'
    end
    
  end
  
  describe 'read' do
    
    it 'should return a tuple from the ring server' do
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :testing, :space => :String, :object => 'A', :description => "AAA")
      obj = Distribunaut::Utils::Rinda.read(:app_name => :testing, :space => :String)
      obj.should_not be_nil
      obj.should == 'A'
      lambda {Distribunaut::Utils::Rinda.read(:app_name => :testing, :space => :String2)}.should raise_error(Rinda::RequestExpiredError)
    end
    
  end
  
  describe 'register' do
    
    it "should be able to register new service" do
      str = String.randomize(40)
      rs = Distribunaut::Utils::Rinda.ring_server
      serv = nil
      lambda { rs.read([:testing, :String, nil, "test_register-#{str}"], 0)[2] }.should raise_error(Rinda::RequestExpiredError)
      Distribunaut::Utils::Rinda.register(:app_name => :testing, :space => :String, :object => str, :description => "test_register-#{str}")
      serv = nil
      serv = rs.read([:testing, :String, nil, "test_register-#{str}"], 1)[2]
      serv.should_not be_nil
      serv.should == str
    end
    
  end
  
  describe 'register_or_renew' do

    it "should be able to register or renew service(s)" do
      str = String.randomize(40)
      rs = Distribunaut::Utils::Rinda.ring_server
      serv = nil
      lambda { rs.read([:testing, :String, nil, "test_register_or_renew"], 0)[2] }.should raise_error(Rinda::RequestExpiredError)
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :testing, :space => :String, :object => str, :description => "test_register_or_renew")
      serv = nil
      serv = rs.read([:testing, :String, nil, "test_register_or_renew"], 1)[2]
      serv.should_not be_nil
      serv.should == str
    
      str2 = String.randomize(40)
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :testing, :space => :String, :object => str2, :description => "test_register_or_renew")
      serv = nil
      serv = rs.read([:testing, :String, nil, "test_register_or_renew"], 1)[2]
      serv.should_not be_nil
      serv.should == str2
      serv.should_not == str
    end
    
  end
  
  describe 'remove_all_services!' do
    
    it 'should remove all services from the ring server' do
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :testing, :space => :StringA, :object => 'A', :description => "AAA")
      Distribunaut::Utils::Rinda.register_or_renew(:app_name => :testing, :space => :StringB, :object => 'B', :description => "BBB")
      Distribunaut::Utils::Rinda.available_services.size.should be 2
      Distribunaut::Utils::Rinda.remove_all_services!
      Distribunaut::Utils::Rinda.available_services.should be_empty
    end
    
  end
  
end