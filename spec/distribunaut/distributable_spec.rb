require File.dirname(__FILE__) + '/../spec_helper'

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
    axl_proxy.inspect.should == "Sweet Child O'Mine"
    axl_proxy.yell.should == 'YEAH!!!!'
    
    axls = Distribunaut::Distributed::Axl.find
    axls.should be_kind_of(Array)
    axls.size.should == 2
  end
  
end
