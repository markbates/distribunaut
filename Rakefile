require 'rubygems'

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)

Bundler.require

Gemstub.test_framework = :rspec

Gemstub.gem_spec do |s|
  s.name = "distribunaut"
  s.version = "0.3.0"
  s.summary = "distribunaut"
  s.description = "distribunaut was developed by: markbates"
  s.author = "markbates"
  s.email = "mark+github@markbates.com"
  s.homepage = "http://www.metabates.com"
  s.add_dependency('configatron', '>=2.3.0')
  s.add_dependency('addressable', '>=2.0.0')
  s.add_dependency('daemons', '>=1.0.10')
  s.add_dependency('activesupport', '>=3.0.3')
  s.add_dependency('i18n')
  s.executables << "distribunaut_ring_server"
end

Gemstub.rdoc do |rd|
  rd.title = 'DJ Remixes'
end