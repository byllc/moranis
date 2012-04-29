module Moranis
  class KeyMaster
    
    #TODO: move this in to a configuration object
    #typical file is either authorized_keys, #authorized_keys2 or authorized depending on ssh version
    #I only needed ssh1 support for my situation but this is here for convenience and can be changed 
    #by setting Moranis::Keymaster::KEY_FILE = "authorized_keys2"
    #given that we have not yet added support for ssh2 in the output file format this is probably not particularly useful yet
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
          remote_run.commands << "touch ~/.ssh/#{KEY_FILE}.tmp"
          
          #make sure the permissions are set up properly
          remote_run.commands << "chmod 600 ~/.ssh/#{KEY_FILE}.tmp"
          
          #clear the temporary key file
          remote_run.commands << "cat /dev/null > ~/.ssh/#{KEY_FILE}.tmp"
          
          #append the keys to the file
          keys.each do |key|
            remote_run.commands << "echo \"#{key}\" >> ~/.ssh/#{KEY_FILE}.tmp"
          end
          
          #swap the key files
          remote_run.commands << "mv ~/.ssh/#{KEY_FILE} ~/.ssh/#{KEY_FILE}.bak"
          remote_run.commands << "mv ~/.ssh/#{KEY_FILE}.tmp ~/.ssh/#{KEY_FILE}"
          
          begin
            remote_run.execute 
          rescue Net::SSH::AuthenticationFailed 
            puts "You do not have access to #{user} on #{host}"
          end
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
            remote_run.commands << "if [ -f ~/.ssh/#{KEY_FILE}.bak  ] then mv ~/.ssh/#{KEY_FILE}.bak ~/.ssh/#{KEY_FILE} fi"
            remote_run.execute
          rescue
            #we tried as the user, the keys file may be messed up or our key does not exist in the list any longer
            # lets try as root
            root_remote_run = Moranis::RemoteRun.new(host,"root")
            root_remote_run.commands << "su - #{user}"
            root_remote_run.commands << "if [ -f ~/.ssh/#{KEY_FILE}.bak  ] then mv ~/.ssh/#{KEY_FILE}.bak ~/.ssh/#{KEY_FILE} fi"
            root_remote_run.execute rescue Net::SSH::AuthenticationFailed (puts "You may not have access to root on #{host}")
          end
        end
      end
      
    end
    
  end
end