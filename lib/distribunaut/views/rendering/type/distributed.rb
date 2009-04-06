module Distribunaut
  module Rendering
    module Type
      class Distributed < Distribunaut::Rendering::Type::Base

        # render(:distributed, "distributed://host/resource")
        def render
            uri = Addressable::URI.parse(self._render_value)
            raise InvalidAddressableURIFormat.new("#{self._render_value}") if uri.host.nil? or uri.path.nil?
            
            app_name = uri.host
            resource = File.join("app", "views", uri.path)
            
            data = Distribunaut::Distributed::View.ref(app_name)
            if data
              raw = ""
              Distribunaut::Rendering::Engine::Registry.engines[:distributed].each do |e|
                @engine = find_engine(e).new(self.view_template)

                view_path = "#{resource}.#{self._options[:format]}.#{@engine.extension}"
                raw = data.get(view_path)
                break if !raw.nil?
              end
              
              raise Distribunaut::Errors::ResourceNotFound.new("#{self._options[:distributed]}") if raw.nil?
              
              old_render_value = self.view_template._render_value.dup
              self.view_template._render_value = raw
              Distribunaut::Rendering::Type::Inline.new(self.view_template).render
              # self.view_template.render_value = old_render_value
            end
        end
      end
    end
  end
end

Distribunaut::Rendering::Engine::Registry.register(:distributed, :builder)
Distribunaut::Rendering::Engine::Registry.register(:distributed, :erubis)
