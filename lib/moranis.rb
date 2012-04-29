require 'capistrano'
require 'yaml'

require_relative 'moranis/key_master'
require_relative 'moranis/remote_run'

module Moranis
  
  key_master = Moranis::KeyMaster.new( File.join(File.dirname(__FILE__), "../config/config.yml") )
  key_master.groups.each do |group|
          
    #key_master.run_for_group(group)
    key_master.revert_for_group(group)
  end
    
end
