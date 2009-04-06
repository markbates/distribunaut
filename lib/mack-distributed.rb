require File.join(File.dirname(__FILE__), 'gems')

require 'drb/acl'
require 'addressable/uri'
require 'ruby-debug'
require 'mack-caching'

base = File.join(File.dirname(__FILE__), "mack-distributed")

configatron.mack.distributed.set_default(:share_routes, false)
configatron.mack.distributed.set_default(:share_objects, false)
configatron.mack.distributed.set_default(:share_views, false)
configatron.mack.distributed.set_default(:app_name, nil)
configatron.mack.distributed.set_default(:site_domain, nil)
configatron.mack.distributed.set_default(:timeout, 0)
configatron.mack.distributed.set_default(:enable_view_cache, false)

# load *.rb files
Dir.glob(File.join(base, "**", "*.rb")).each do |f|
  load(f)
end

Mack::Distributed::View.register

