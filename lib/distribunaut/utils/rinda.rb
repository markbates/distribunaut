module Distribunaut
  module Utils # :nodoc:
    module Rinda
      
      def self.register_or_renew(options = {})
        options = handle_options(options)
        begin
          ring_server.take([options[:app_name], options[:space], nil, nil], options[:timeout])
        rescue ::Rinda::RequestExpiredError => e
          # it's ok that it expired. It could be that it was never registered.
        end
        register(options)
      end
      
      def self.register(options = {})
        options = handle_options(options)
        ring_server.write([options[:app_name], 
                           options[:space], 
                           options[:object], 
                           options[:description]], 
                          ::Rinda::SimpleRenewer.new)
      end
      
      def self.ring_server
        if configatron.distribunaut.retrieve(:acl, nil)
          acl = ACL.new(configatron.distribunaut.acl)
          DRb.install_acl(acl)
        end
        ::DRb.start_service
        rs = ::Rinda::RingFinger.primary
        rs
      end
      
      def self.read(options = {})
        options = handle_options(options)
        ring_server.read([options[:app_name], options[:space], nil, options[:description]], options[:timeout])[2]
      end
      
      private
      def self.handle_options(options = {})
        {:app_name => nil, 
         :space => nil, 
         :object => nil, 
         :description => nil, 
         :timeout => configatron.distribunaut.timeout
        }.merge(options)
      end
      
    end
  end
end