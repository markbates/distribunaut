module Distribunaut
  module Rendering # :nodoc:
    module Type # :nodoc:
      class Layout
        
        alias_instance_method :render
        
        def render
          if !self._options[:layout].starts_with?("distributed")
            # this is the regular layout, so call the local_render method
            _original_render
          else
            uri = Addressable::URI.parse(self._options[:layout])
            raise InvalidAddressableURIFormat.new("#{self._options[:layout]}") if uri.host.nil? or uri.path.nil?
            
            app_name = uri.host
            resource = File.join("app", "views", "layouts", uri.path)

            data = Distribunaut::Distributed::View.ref(app_name)
            if data
              raw = ""
              Distribunaut::Rendering::Engine::Registry.engines[:layout].each do |e|
                @engine = find_engine(e).new(self.view_template)

                layout_path = "#{resource}.#{self._options[:format]}.#{@engine.extension}"
                raw = data.get(layout_path)
                break if !raw.nil?
              end

              raise Distribunaut::Errors::ResourceNotFound.new("#{self._options[:distributed]}") if raw.nil?

              old_render_value = self.view_template._render_value.dup
              self.view_template._render_value = raw
              Distribunaut::Rendering::Type::Inline.new(self.view_template).render
            end
          end
        end # render
        
      end # Layout
    end # Type
  end # Rendering
end # Distribunaut