require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe "Distributed Views" do
  
  before(:all) do
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
    
    Distribunaut::Distributed::Utils::Rinda.register_or_renew(:space => :foo_server,
                                                      :klass_def => :distributed_views, 
                                                      :object => Distribunaut::Distributed::View.instance)
  end
  
  describe "Layout" do
    
    it "should handle globally set remote layout (i.e. set via layout method in controller level)" do
      get global_animals_url
      response.body.should match(/Distributed Layout/)
    end
    
    it "should handle locally set remote layout (i.e. passed into render method)" do
      get local_animals_url
      response.body.should match(/Distributed Layout 2/)
    end
    
    it "should use local layout if specified even if global layout is set" do
      get real_local_animals_url
      response.body.should match(/Local Layout/)
    end
    
    it "should use instance variable defined in local view when rendering remote layout" do
      get global_animals_url
      response.body.should match(/var1/)
    end
    
    it "should use instance variable defined in controller when rendering remote layout" do
      get global_animals_url
      response.body.should match(/var2/)
    end
    
    it "should be not cache layout if not told to" do
      configatron.temp do 
        configatron.mack.distributed.enable_view_cache = false
        get local_animals_url
        response.body.should match(/Distributed Layout 2/)
        
        path = Distribunaut::Paths.layouts("server_layout2.html.erb")
        old_data = File.read(path)
        new_data = old_data.gsub("Distributed Layout 2!", "Hey! I've just changed the layout!")
        File.open(path, "w") { |f| f.write(new_data) }
        get local_animals_url
        response.body.should match(/Hey! I've just changed the layout!/)
        
        File.open(path, "w") { |f| f.write(old_data) }
      end
    end
    
    it "should not reload layout content if cache is enabled" do
      configatron.temp do 
        configatron.mack.distributed.enable_view_cache = true
        
        get local_animals_url
        response.body.should match(/Distributed Layout 2/)
        
        path = Distribunaut::Paths.layouts("server_layout2.html.erb")
        old_data = File.read(path)
        new_data = old_data.gsub("Distributed Layout 2!", "Hey! I've just changed the layout!")
        File.open(path, "w") { |f| f.write(new_data) }
        get local_animals_url
        response.body.should match(/Distributed Layout 2/)
        
        File.open(path, "w") { |f| f.write(old_data) }
      end
    end
  end
  
  describe "View" do
    it "should render remote view" do
      get global_animals_url
      response.body.should match(/Hello from index2.html.erb/)
    end
    it "should use instance variable defined in local controller" do
      get global_animals_url
      response.body.should match(/Boo!/)
    end
  end
  
end