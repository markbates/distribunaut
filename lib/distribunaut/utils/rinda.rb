module Distribunaut
  module Distributed
    module Utils # :nodoc:
      module Rinda
        
        def self.register_or_renew(options = {})
          options = handle_options(options)
          begin
            ring_server.take([options[:space], options[:klass_def], nil, nil], options[:timeout])
          rescue Exception => e
            # Distribunaut.logger.error(e)
          end
          register(options)
        end
        
        def self.register(options = {})
          options = handle_options(options)
          ring_server.write([options[:space], 
                             options[:klass_def], 
                             options[:object], 
                             options[:description]], 
                            ::Rinda::SimpleRenewer.new)
        end
        
        def self.ring_server
          if configatron.mack.distributed.retrieve(:acl, nil)
            acl = ACL.new(configatron.mack.distributed.acl)
            DRb.install_acl(acl)
          end
          ::DRb.start_service
          rs = ::Rinda::RingFinger.primary
          rs
        end
        
        def self.read(options = {})
          options = handle_options(options)
          ring_server.read([options[:space], options[:klass_def], nil, options[:description]], options[:timeout])[2]
        end
        
        private
        def self.handle_options(options = {})
          {:space => nil, :klass_def => nil, :object => nil, :description => nil, :timeout => configatron.mack.distributed.timeout}.merge(options)
        end
        
      end
    end
  end
end