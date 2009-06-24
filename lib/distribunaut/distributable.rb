module Distribunaut # :nodoc:
  # Include this module into any class it will instantly register that class with
  # the distribunaut_ring_server. The class will be registered with the name of the class
  # and the distribunaut.distributed_app_name configured in your config/configatron/*.rb file.
  # If the distribunaut.distributed_app_name configuration parameter is nil it will raise
  # an Distribunaut::Distributed::Errors::ApplicationNameUndefined exception.
  # 
  # Example:
  #  class User
  #    include Distribunaut::Distributable
  #    def name
  #      "mark"
  #    end
  #  end
  # 
  #  Distribunaut::Distributed::User.new.name # => "mark"
  module Distributable
      
      def self.included(base) # :nodoc:
        base.class_eval do
          include ::DRbUndumped
        end
        c_name = base.name.gsub('::', '_')
        eval %{
          class ::Distribunaut::Distributed::#{c_name}Proxy
            include Singleton
            include DRbUndumped

            def method_missing(sym, *args)
              #{base}.send(sym, *args)
            end
            
            undef :id if method_defined?(:id)
            undef :inspect if method_defined?(:inspect)
            undef :to_s if method_defined?(:to_s)
          
          end
        }
        obj = "Distribunaut::Distributed::#{c_name}Proxy".constantize.instance 
        raise Distribunaut::Distributed::Errors::ApplicationNameUndefined.new if configatron.distribunaut.app_name.nil?
        Distribunaut::Utils::Rinda.register_or_renew(:space => "#{base}".to_sym, 
                                                                  :object => obj,
                                                                  :description => "#{base} Service",
                                                                  :app_name => configatron.distribunaut.app_name.to_sym)
      end
      
  end # Distributable
end # Distribunaut