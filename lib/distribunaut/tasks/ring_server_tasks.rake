require 'rinda/ring'
namespace :distribunaut do
  namespace :ring_server do
    
    desc "Start the Rinda ring server"
    task :start do
      `distribunaut_ring_server start`
    end
    
    desc "Stop the Rinda ring server"
    task :stop do
      `distribunaut_ring_server stop`
    end
    
    desc "Restart the Rinda ring server"
    task :restart => [:stop, :start]
    
    namespace :services do
      
      desc "Lists all services on the ring server"
      task :list do
        require 'distribunaut'
        puts "Services on #{Distribunaut::Utils::Rinda.ring_server.__drburi}"
        services = Distribunaut::Utils::Rinda.available_services
        services.each do |service|
          # puts "#{service[0]}: #{service[1]} on #{service[2].__drburi} - #{service[3]}"
          puts "#{service.app_name}: #{service.space} on #{service.object.__drburi} - #{service.description}"
        end
      end
      
    end # services
    
  end # ring_server
end # distribunaut