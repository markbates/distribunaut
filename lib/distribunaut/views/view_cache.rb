module Distribunaut
  module Distributed
    class ViewCache < Cachetastic::Caches::Base
      
      class << self
        include Distribunaut::ViewHelpers
      
        def get(path)
          if configatron.mack.distributed.enable_view_cache
            raw = super(path) do
              get_raw_data(path, true)
            end 
          else
            raw = get_raw_data(path, false)
          end
          
          return raw
        end # def get
        
        private
        def get_raw_data(path, cache_data = true)
          if File.exists?(path)
            raw = File.read(path)

            # preprocess the raw content so we can resolve css/javascript/image path
            arr = raw.scan(/<%=.*?%>/)
            arr.each do |scriptlet|
              if scriptlet.match(/stylesheet/) or scriptlet.match(/javascript/) or scriptlet.match(/image/)
                res = ERB.new(scriptlet).result(binding)
                raw.gsub!(scriptlet, res)
              end 
            end # if arr.each
          end # if File.exists?
          
          set(path, raw) if cache_data
          raw
        end # get_raw_data
      end # class << self
      
    end # ViewCache
  end # Distributed
end # Distribunaut