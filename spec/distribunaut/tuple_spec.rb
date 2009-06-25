require File.dirname(__FILE__) + '/../spec_helper'

describe Distribunaut::Tuple do
  
  describe 'to_array' do
    
    it 'should create an Array from the Tuple' do
      tuple = Distribunaut::Tuple.new(:app_name => 'my app',
                                      :space => 'my space',
                                      :object => 'my object',
                                      :description => 'my description',
                                      :timeout => 3)
      tuple.to_array.should == ['my app', 'my space', 'my object', 'my description']
    end
    
  end
  
  describe 'to_search_array' do
    
    it 'should create an Array from the Tuple with object and description nil' do
      tuple = Distribunaut::Tuple.new(:app_name => 'my app',
                                      :space => 'my space',
                                      :object => 'my object',
                                      :description => 'my description',
                                      :timeout => 3)
      tuple.to_search_array.should == ['my app', 'my space', nil, nil]
    end
    
  end
  
  describe 'from_array' do
    
    it 'should build a tuple from an Array' do
      ar = ['my app', 'my space', 'my object', 'my description']
      tuple = Distribunaut::Tuple.from_array(ar)
      tuple.to_array.should == ar
    end
    
  end
  
  describe 'to_s' do
    
    it 'should print the inspect of the to_array method' do
      tuple = Distribunaut::Tuple.new(:app_name => 'my app',
                                      :space => 'my space',
                                      :object => 'my object',
                                      :description => 'my description',
                                      :timeout => 3)
      tuple.to_s.should == tuple.to_array.inspect
    end
    
  end
  
end
