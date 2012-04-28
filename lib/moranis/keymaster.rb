class Moranis::Keymaster
  def initialize(config_path)
    @config = YAML::load(File.open(config_path))
  end
  
  def groups
    @config[:groups]
  end
  
end