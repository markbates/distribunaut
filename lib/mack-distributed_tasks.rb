require File.join(File.dirname(__FILE__), 'gems')

# load tasks
Dir.glob(File.join(File.dirname(__FILE__), 'mack-distributed', 'tasks', '*.rake')).each do |f|
  load(f)
end