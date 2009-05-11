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
    Distribunaut::Distributed::DylanProxy.instance.should be_kind_of(::Singleton)
    Distribunaut::Distributed::DylanProxy.instance.should be_kind_of(::DRbUndumped)
  end
  
  it 'should create proxy objects for modularize classes' do
    Distribunaut::Distributed.should_not be_const_defined('Bob_DylanProxy')
    module Bob
      class Dylan
        include Distribunaut::Distributable
      end
    end
    Distribunaut::Distributed.should be_const_defined('Bob_DylanProxy')
    Distribunaut::Distributed::Bob_DylanProxy.instance.should be_kind_of(::Singleton)
    Distribunaut::Distributed::Bob_DylanProxy.instance.should be_kind_of(::DRbUndumped)
  end
  
end
