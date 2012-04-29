module Moranis
  class KeyMaster
  
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
          remote_run.commands << "if [ -f ~/.ssh/authorized_keys.bak  ] then mv ~/.ssh/authorized_keys.bak ~/.ssh/authorized_keys fi"
          remote_run.execute
        end
      end
      
    end
    
  end
end