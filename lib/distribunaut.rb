require 'configatron'
require 'cachetastic'
require 'drb/drb'
require 'drb/acl'
require 'rinda/ring'
require 'rinda/tuplespace'
require 'addressable/uri'
require 'activesupport'

base = File.join(File.dirname(__FILE__), 'distribunaut')

configatron.distribunaut.set_default(:share_objects, false)
configatron.distribunaut.set_default(:app_name, nil)
configatron.distribunaut.set_default(:timeout, 0)

# load *.rb files
Dir.glob(File.join(base, "**", "*.rb")).each do |f|
  require(f)
end

