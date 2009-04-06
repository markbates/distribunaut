module Distribunaut
  module Distributed
    module Routes # :nodoc:
      # A class used to house the Distribunaut::Routes::Url module for distributed applications.
      # Functionally this class does nothing, but since you can't cache a module, a class is needed.
      class Urls
        include DRbUndumped
        
        def initialize(dsd) # :nodoc:
          @dsd = dsd
        end
        
        def put
          Distribunaut::Distributed::Utils::Rinda.register_or_renew(:space => configatron.mack.distributed.app_name.to_sym, 
                                                            :klass_def => :distributed_routes, 
                                                            :object => self, :timeout => 0)
        end
        
        def run(meth, options)
          self.send(meth, options)
        end
        
        class << self
          
          def get(app_name)
            Distribunaut::Distributed::Utils::Rinda.read(:space => app_name.to_sym, :klass_def => :distributed_routes)
          end
          
        end
        
      end # Urls
      
    end # Routes
  end # Distributed
  
end # Distribunaut

Distribunaut::Routes.after_class_method(:build) do
  if configatron.mack.distributed.share_routes
    raise Distribunaut::Distributed::Errors::ApplicationNameUndefined.new if configatron.mack.distributed.app_name.nil?
    
    d_urls = Distribunaut::Distributed::Routes::Urls.new(configatron.mack.distributed.site_domain)
    d_urls.put
    Distribunaut::Routes::Urls.include_safely_into(Distribunaut::Distributed::Routes::Urls)
    Distribunaut::Distributed::Routes::Urls.protected_instance_methods.each do |m|
      Distribunaut::Distributed::Routes::Urls.instance_eval do
        public m if m.match(/_url$/)
      end
    end
  end
end