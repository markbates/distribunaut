module DRb # :nodoc:
  class DRbObject # :nodoc:

    alias_method :_original_inspect, :inspect unless method_defined?(:_original_inspect)
    
    def inspect
      "#{_original_inspect}|#{method_missing(:inspect)}"
    end
    
    undef :id if method_defined?(:id)
    
  end
end