require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")
require 'rinda/ring'
require 'rinda/tuplespace'

describe Distribunaut::Distributable do

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

  it "should include DRbUndumped" do
    class Pool
      include Distribunaut::Distributable
    end
    Pool.new.should be_is_a(DRbUndumped)
  end
  
  it "should defined a proxy singleton" do
    lambda{Distribunaut::Distributed::BoatProxy}.should raise_error(Rinda::RequestExpiredError)
    class Boat
      include Distribunaut::Distributable
    end
    lambda{
      Distribunaut::Distributed::BoatProxy.instance.should_not be_nil
      Distribunaut::Distributed::BoatProxy.instance.should be_is_a(DRbUndumped)
    }.should_not raise_error(NameError)
  end
  
  it "should respond with the methods of the underlying class" do
    class Car
      include Distribunaut::Distributable
      def make
        "Toyota"
      end
      def self.buy
        true
      end
    end
    car = Distribunaut::Distributed::CarProxy.instance.new
    car.should be_is_a(Car)
    car.make.should == "Toyota"
    car.respond_to?(:make).should == true
    Distribunaut::Distributed::CarProxy.instance.buy.should == true
  end
  
  it "should reference the original objects inspect method" do
    class Bike
      include Distribunaut::Distributable
      def inspect
        "<BikeClass>"
      end
      def to_s
        "i'm a bike"
      end
    end
    c = Distribunaut::Distributed::Utils::Rinda.read(:space => :Bike)
    c.inspect.should match(/Bike/)
    c.new.to_s.should match(/i'm a bike/)
  end

end