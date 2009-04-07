module Distribunaut # :nodoc:
  module Distributed # :nodoc:
    
    # Looks up and tries to find the missing constant using the ring server.
    def self.const_missing(const)
      Distribunaut::Utils::Rinda.read(:space => "#{const}".to_sym)
    end
    
    # Allows for the specific lookup of services on the ring server
    # 
    # Examples:
    #   Distribunaut::Utils::Rinda.register_or_renew(:app_name => :app_1, :space => :Test, :object => "Hello World!")
    #   Distribunaut::Utils::Rinda.register_or_renew(:app_name => :app_2, :space => :Test, :object => "Hello WORLD!")
    #   Distribunaut::Distributed.lookup("distributed://app_1/Test") # => "Hello World!"
    #   Distribunaut::Distributed.lookup("distributed://app_2/Test") # => "Hello WORLD!"
    def self.lookup(address)
      uri = Addressable::URI.parse(address)
      path = uri.path[1..uri.path.size] # remove the first slash
      host = uri.host
      Distribunaut::Utils::Rinda.read(:space => path.to_sym, :app_name => host.to_sym)
    end
    
  end # Distributed
end # Distribunaut