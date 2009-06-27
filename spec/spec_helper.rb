# require 'rubygems'
gem 'rspec'
require 'spec'
require 'rake'
require 'fileutils'

require File.join(File.dirname(__FILE__), '..', 'lib', 'distribunaut')

configatron.distribunaut.app_name = :test_app

$test_ring_server_started = false

Spec::Runner.configure do |config|
  
  config.before(:all) do
    unless $test_ring_server_started
      begin
        DRb.start_service
        Rinda::RingServer.new(Rinda::TupleSpace.new)
        $test_ring_server_started = true
      rescue Exception => e
        # it's fine to ignore this, it's expected that it's already running.
        # all other exceptions should be thrown
      end
    end
  end
  
  config.after(:all) do
    
  end
  
  config.before(:each) do
    begin
      Distribunaut::Utils::Rinda.remove_all_services!
    rescue Exception => e
      puts e.message
    end
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

module Distribunaut
  class TestingError < StandardError
  end
end
