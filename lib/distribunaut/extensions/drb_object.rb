module DRb # :nodoc:
  class DRbObject # :nodoc:

    alias_method :_original_inspect, :inspect unless method_defined?(:_original_inspect)
    
    def inspect
      "#{_original_inspect}|#{method_missing(:inspect)}"
    end
    
    undef :id if method_defined?(:id)
    undef :kind_of? if method_defined?(:kind_of?)
    undef :is_a? if method_defined?(:is_a?)
    
  end
end