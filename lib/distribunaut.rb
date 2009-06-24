require 'configatron'
require 'drb/drb'
require 'drb/acl'
require 'rinda/ring'
require 'rinda/tuplespace'
require 'addressable/uri'
require 'activesupport'

base = File.join(File.dirname(__FILE__), 'distribunaut')

configatron.distribunaut.set_default(:app_name, nil)
configatron.distribunaut.set_default(:timeout, 0)

# load *.rb files
Dir.glob(File.join(base, "**", "*.rb")).each do |f|
  require(f)
end

# Make sure no one can call eval() and related 
# methods remotely!
$SAFE = 1 unless $SAFE > 0
