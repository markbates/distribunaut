# require 'rubygems'
gem 'rspec'
require 'spec'
require 'rake'
require 'fileutils'

require File.join(File.dirname(__FILE__), '..', 'lib', 'distribunaut')

configatron.distribunaut.app_name = :test_app

class String
  
  def self.randomize(length = 10)
    chars = ("A".."H").to_a + ("J".."N").to_a + ("P".."T").to_a + ("W".."Z").to_a + ("3".."9").to_a
    newpass = ""
    1.upto(length) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass.upcase
  end
  
end
