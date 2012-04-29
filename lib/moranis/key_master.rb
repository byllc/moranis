module Moranis
  class KeyMaster
    
    #TODO: move this in to a configuration object
    #this file is either authorized_keys, authorized_keys2 or authorized depending on ssh version
    #I only needed ssh1 support for my situation but this is here for convenience and can be changed 
    #by setting Moranis::Keymaster::KEY_FILE = 
    KEY_FILE = "authorized_keys"
    
    def initialize(config_path)
      @config = YAML::load(File.open(config_path))
    end
    
    def groups
      @config.keys
    end
  
    def run_for_group(group)
      hosts = @config[group]["hosts"]
      keys  = @config[group]["keys"]
      users = @config[group]["users"]
      
      hosts.each do |host|
        users.each do |user|
          puts "Generating keys on #{host} for #{user}"
          remote_run = Moranis::RemoteRun.new(host,user)
          
          #make sure the temporary auth file exists
          remote_run.commands << "touch ~/.ssh/authorized_keys.tmp"
          
          #make sure the permissions are set up properly
          remote_run.commands << "chmod 600 ~/.ssh/authorized_keys.tmp"
          
          #clear the temporary key file
          remote_run.commands << "cat /dev/null > ~/.ssh/authorized_keys.tmp"
          
          #append the keys to the file
          keys.each do |key|
            remote_run.commands << "echo \"#{key}\" >> ~/.ssh/authorized_keys.tmp"
          end
          
          #swap the key files
          remote_run.commands << "mv ~/.ssh/authorized_keys ~/.ssh/authorized_keys.bak"
          remote_run.commands << "mv ~/.ssh/authorized_keys.tmp ~/.ssh/authorized_keys"
          
          puts remote_run.execute
        end
      end
    end
    
    def revert_for_group(group)
      hosts = @config[group]["hosts"]
      keys  = @config[group]["keys"]
      users = @config[group]["users"]
      
      hosts.each do |host|
        users.each do |user|
          remote_run = Moranis::RemoteRun.new(host,user)
          begin
            remote_run.commands << "if [ -f ~/.ssh/authorized_keys.bak  ] then mv ~/.ssh/authorized_keys.bak ~/.ssh/authorized_keys fi"
            remote_run.execute
          rescue
            #we tried as the user, the keys file may be messed up or our key does not exist in the list any longer
            # lets try as root
            root_remote_run = Moranis::RemoteRun.new(host,"root")
            root_remote_run = "su - #{user}"
            root_remote_run.commands << "if [ -f ~/.ssh/authorized_keys.bak  ] then mv ~/.ssh/authorized_keys.bak ~/.ssh/authorized_keys fi"
            root_remote_run.execute rescue "You may not have root priviledge for reversion"
          end
        end
      end
      
    end
    
  end
end