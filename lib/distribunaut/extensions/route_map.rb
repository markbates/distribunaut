module Distribunaut
  module Routes # :nodoc:
    class RouteMap # :nodoc:

      alias_instance_method :connect_with_name
    
      def connect_with_name(name, path, options = {}, &block) # :nodoc:
        n_route = name.methodize
        _original_connect_with_name(n_route, path, options, &block)
        if configatron.distribunaut.share_routes
          Distribunaut::Routes::Urls.class_eval %{
            def #{n_route}_distributed_url(options = {})
              (@dsd || configatron.distribunaut.site_domain) + #{n_route}_url(options)
            end
          }
        end
      end # connect_with_name
      
    end # RouteMap
  end # Routes
end # Distribunaut