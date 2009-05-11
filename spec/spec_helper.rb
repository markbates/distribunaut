# require 'rubygems'
gem 'rspec'
require 'spec'
require 'rake'
require 'fileutils'

require File.join(File.dirname(__FILE__), '..', 'lib', 'distribunaut')

configatron.distribunaut.app_name = :test_app

Spec::Runner.configure do |config|
  
  config.before(:all) do
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
  end
  
  config.after(:all) do
    
  end
  
  config.before(:each) do
    
  end
  
  config.after(:each) do
    
  end
  
end

class String
  
  def self.randomize(length = 10)
    chars = ("A".."H").to_a + ("J".."N").to_a + ("P".."T").to_a + ("W".."Z").to_a + ("3".."9").to_a
    newpass = ""
    1.upto(length) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass.upcase
  end
  
end
