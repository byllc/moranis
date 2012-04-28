#add moranis to capistrano
Capistrano::Configuration.instance.load do
  namespace :moranis do  
    keymaster = Moranis::Keymaster.new("../../config/config.yml"))
    
    namespace :sync do
      
      #read in key configuration file and generate task for each
      keymaster.groups do |group|
        desc "Sync task for #{group} group"
        task group.to_sym do
          
        end
      end
      
    end
    
  end
end