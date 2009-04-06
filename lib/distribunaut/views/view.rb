module Distribunaut
  module Distributed
    class View
      
      include Singleton
      include DRbUndumped
      
      def get(resource)
        path = File.join(Distribunaut.root, resource)
        raw = Distribunaut::Distributed::ViewCache.get(path)
        return raw
      end
      
      class << self
        def register
          if configatron.mack.distributed.share_views
            raise Distribunaut::Distributed::Errors::ApplicationNameUndefined.new if configatron.mack.distributed.app_name.nil?
            # Distribunaut.logger.info "Registering Distribunaut::Distributed::View for '#{app_config.mack.distributed_app_name}' with Rinda"
            
            Distribunaut::Distributed::Utils::Rinda.register_or_renew(:space => configatron.mack.distributed.app_name.to_sym,
                                                              :klass_def => :distributed_views, 
                                                              :object => Distribunaut::Distributed::View.instance)
          end
        end
        
        def ref(app_name)          
          begin
            obj = Distribunaut::Distributed::Utils::Rinda.read(:space => app_name.to_sym, 
                                                       :klass_def => :distributed_views)
            return obj
          rescue Rinda::RequestExpiredError => er
            Distribunaut.logger.warn(er)
          end
          
          return nil
        end
      end
      
    end # View
  end # Distributed
end # Distribunaut