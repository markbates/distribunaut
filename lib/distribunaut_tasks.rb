# load tasks
Dir.glob(File.join(File.dirname(__FILE__), 'distribunaut', 'tasks', '*.rake')).each do |f|
  load(f)
end