require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")
require 'rinda/ring'
require 'rinda/tuplespace'

describe Mack::Distributable do

  before(:each) do
    configatron.mack.distributed.share_objects = true
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
  end
  
  after(:each) do
    configatron.mack.distributed.share_objects = false
  end

  it "should include DRbUndumped" do
    class Pool
      include Mack::Distributable
    end
    Pool.new.should be_is_a(DRbUndumped)
  end
  
  it "should defined a proxy singleton" do
    lambda{Mack::Distributed::BoatProxy}.should raise_error(Rinda::RequestExpiredError)
    class Boat
      include Mack::Distributable
    end
    lambda{
      Mack::Distributed::BoatProxy.instance.should_not be_nil
      Mack::Distributed::BoatProxy.instance.should be_is_a(DRbUndumped)
    }.should_not raise_error(NameError)
  end
  
  it "should respond with the methods of the underlying class" do
    class Car
      include Mack::Distributable
      def make
        "Toyota"
      end
      def self.buy
        true
      end
    end
    car = Mack::Distributed::CarProxy.instance.new
    car.should be_is_a(Car)
    car.make.should == "Toyota"
    car.respond_to?(:make).should == true
    Mack::Distributed::CarProxy.instance.buy.should == true
  end
  
  it "should reference the original objects inspect method" do
    class Bike
      include Mack::Distributable
      def inspect
        "<BikeClass>"
      end
      def to_s
        "i'm a bike"
      end
    end
    c = Mack::Distributed::Utils::Rinda.read(:klass_def => :Bike)
    c.inspect.should match(/Bike/)
    c.new.to_s.should match(/i'm a bike/)
  end

end