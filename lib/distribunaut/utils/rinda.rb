module Distribunaut
  module Utils # :nodoc:
    module Rinda
      
      def self.register_or_renew(values = {})
        tuple = build_tuple(values)
        begin
          ring_server.take(tuple.to_search_array, tuple.timeout)
        rescue ::Rinda::RequestExpiredError => e
          # it's ok that it expired. It could be that it was never registered.
        end
        register(values)
      end
      
      def self.register(values = {})
        tuple = build_tuple(values)
        ring_server.write(tuple.to_array, ::Rinda::SimpleRenewer.new)
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
      
      def self.read(values = {})
        tuple = build_tuple(values)
        results = ring_server.read(tuple.to_array, tuple.timeout)
        tuple = Distribunaut::Tuple.from_array(results)
        tuple.object
      end
      
      private
      def self.build_tuple(values = {})
        return values if values.is_a?(Distribunaut::Tuple)
        Distribunaut::Tuple.new({:timeout => configatron.distribunaut.timeout}.merge(values))
      end
      
    end
  end
end