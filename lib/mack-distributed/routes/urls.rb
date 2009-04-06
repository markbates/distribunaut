module Mack
  module Distributed
    module Routes # :nodoc:
      # A class used to house the Mack::Routes::Url module for distributed applications.
      # Functionally this class does nothing, but since you can't cache a module, a class is needed.
      class Urls
        include DRbUndumped
        
        def initialize(dsd) # :nodoc:
          @dsd = dsd
        end
        
        def put
          Mack::Distributed::Utils::Rinda.register_or_renew(:space => configatron.mack.distributed.app_name.to_sym, 
                                                            :klass_def => :distributed_routes, 
                                                            :object => self, :timeout => 0)
        end
        
        def run(meth, options)
          self.send(meth, options)
        end
        
        class << self
          
          def get(app_name)
            Mack::Distributed::Utils::Rinda.read(:space => app_name.to_sym, :klass_def => :distributed_routes)
          end
          
        end
        
      end # Urls
      
    end # Routes
  end # Distributed
  
end # Mack

Mack::Routes.after_class_method(:build) do
  if configatron.mack.distributed.share_routes
    raise Mack::Distributed::Errors::ApplicationNameUndefined.new if configatron.mack.distributed.app_name.nil?
    
    d_urls = Mack::Distributed::Routes::Urls.new(configatron.mack.distributed.site_domain)
    d_urls.put
    Mack::Routes::Urls.include_safely_into(Mack::Distributed::Routes::Urls)
    Mack::Distributed::Routes::Urls.protected_instance_methods.each do |m|
      Mack::Distributed::Routes::Urls.instance_eval do
        public m if m.match(/_url$/)
      end
    end
  end
end