module Distribunaut
  module Utils # :nodoc:
    module Rinda
      
      class << self
        
        def register_or_renew(values = {})
          tuple = build_tuple(values)
          begin
            ring_server.take(tuple.to_search_array, tuple.timeout)
          rescue ::Rinda::RequestExpiredError => e
            # it's ok that it expired. It could be that it was never registered.
          end
          register(values)
        end
      
        def register(values = {})
          tuple = build_tuple(values)
          ring_server.write(tuple.to_array, ::Rinda::SimpleRenewer.new)
        end
      
        def ring_server
          if configatron.distribunaut.retrieve(:acl, nil)
            acl = ACL.new(configatron.distribunaut.acl)
            DRb.install_acl(acl)
          end
          ::DRb.start_service
          rs = ::Rinda::RingFinger.primary
          rs
        end
      
        def read(values = {})
          tuple = build_tuple(values)
          results = ring_server.read(tuple.to_array, tuple.timeout)
          tuple = Distribunaut::Tuple.from_array(results)
          tuple.object
        end
        
        def borrow(values = {}, &block)
          tuple = build_tuple(values)
          results = ring_server.take(tuple.to_array, tuple.timeout)
          tuple = Distribunaut::Tuple.from_array(results)
          tuple.space = "#{tuple.space}-onloan-#{Time.now}".to_sym
          register(tuple)
          begin
            yield tuple if block_given?
          rescue Exception => e
            raise e
          ensure
            # (.+)-onloan-.+$
            tuple.space.to_s.match(/(.+)-onloan-.+$/)
            tuple.space = $1.to_sym
            register(tuple)
          end
        end
      
        def available_services
          ring_server = self.ring_server
          all = ring_server.read_all([nil, nil, nil, nil])
          services = []
          all.each do |service|
            services << Distribunaut::Tuple.from_array(service)
          end
          services
        end
        
        def remove_all_services!
          available_services.each do |service|
            ring_server.take(service.to_array)
          end
        end
      
        private
        def build_tuple(values = {})
          return values if values.is_a?(Distribunaut::Tuple)
          Distribunaut::Tuple.new({:timeout => configatron.distribunaut.timeout}.merge(values))
        end
      
      end # class << self
      
    end
  end
end