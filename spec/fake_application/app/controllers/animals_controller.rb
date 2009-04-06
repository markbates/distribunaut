class AnimalsController
  include Mack::Controller
  
  layout "distributed://foo_server/server_layout"
  
  def index
    @animals = []
    @var2 = "var2"
    @greetings = "Boo!"
  end
  
  def index2
    @greetings = "Boo!!"
    render(:action, "index2", :layout => "distributed://foo_server/server_layout2")
  end
  
  def index3
    render(:action, "index3", :layout => :application)
  end  
end
