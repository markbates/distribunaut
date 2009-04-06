# require 'rubygems'
gem 'rspec'
require 'spec'
require 'rake'
require 'fileutils'

require File.join(File.dirname(__FILE__), '..', 'lib', 'distribunaut')

configatron.distribunaut.app_name = :test_app
