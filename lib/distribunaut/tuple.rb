module Distribunaut # :nodoc:
  class Tuple
    
    attr_accessor :app_name
    attr_accessor :space
    attr_accessor :object
    attr_accessor :description
    attr_accessor :timeout
    
    def initialize(values = {})
      values.each do |k, v|
        self.send("#{k}=", v)
      end
    end
    
    def to_array
      [self.app_name, self.space, self.object, self.description]
    end
    
    def to_search_array
      [self.app_name, self.space, nil, nil]
    end
    
    def to_s
      self.to_array.inspect
    end
    
    class << self
      
      def from_array(ar)
        tuple = Distribunaut::Tuple.new
        tuple.app_name = ar[0]
        tuple.space = ar[1]
        tuple.object = ar[2]
        tuple.description = ar[3]
        return tuple
      end
      
    end
      
  end # Tuple
end # Distribunaut