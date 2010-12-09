require 'spec_helper'

describe Distribunaut::Distributable do

  it 'should include DRbUndumped into the base class' do
    class Lisa
      include Distribunaut::Distributable
    end

    Lisa.new.should be_kind_of(::DRbUndumped)
  end

  it "should raise Distribunaut::Distributed::Errors::ApplicationNameUndefined if configatron.distribunaut.app_name is nil" do
    configatron.temp do
      configatron.distribunaut.app_name = nil
      lambda {
        class Mouse
          include Distribunaut::Distributable
        end
      }.should raise_error(Distribunaut::Distributed::Errors::ApplicationNameUndefined)
    end
  end

  it 'should create a proxy object' do
    Distribunaut::Distributed.should_not be_const_defined('DylanProxy')
    class Dylan
      include Distribunaut::Distributable
    end
    Distribunaut::Distributed.should be_const_defined('DylanProxy')
  end

  it 'should create proxy objects for modularize classes' do
    Distribunaut::Distributed.should_not be_const_defined('Bob_DylanProxy')
    module Bob
      class Dylan
        include Distribunaut::Distributable
      end
    end
    Distribunaut::Distributed.should be_const_defined('Bob_DylanProxy')
  end

  it 'should pass calls from the proxy to the base object' do
    class Axl
      include Distribunaut::Distributable

      def inspect
        "Sweet Child O'Mine"
      end

      def yell
        'YEAH!!!!'
      end

      def self.find
        [self.new, self.new]
      end

    end

    axl_proxy = Distribunaut::Distributed::Axl.new
    # axl_proxy.inspect.should == "Sweet Child O'Mine"
    axl_proxy.inspect.should match(/#<DRb::DRbObject:0x\d{1,10} @ref=\d{1,10}, @uri=\\"druby:\/\/127.0.0.1:\d{3,6}\\">|Sweet Child O'Mine/)
    axl_proxy.yell.should == 'YEAH!!!!'

    axls = Distribunaut::Distributed::Axl.find
    axls.should be_kind_of(Array)
    axls.size.should == 2
  end

  describe 'borrow' do

    it 'should return the object and prevent others from accessing it' do
      class Cracker
        include Distribunaut::Distributable

        def self.monkeys
          "You should be guarded by monkeys..."
        end
      end
      lambda {
        Distribunaut::Distributed::Cracker.borrow do |cracker|
          cracker.monkeys.should == "You should be guarded by monkeys..."
          lambda{Distribunaut::Distributed::Cracker.monkeys}.should raise_error(Rinda::RequestExpiredError)
        end
        raise Distribunaut::TestingError
      }.should raise_error(Distribunaut::TestingError)
    end

  end

end
