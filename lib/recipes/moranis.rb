#add moranis to capistrano
Capistrano::Configuration.instance.load do
  namespace :moranis do  
    task :sync do
      
    end
  end
end