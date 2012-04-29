require "minitest/autorun"
require "moranis"

class TestKeyMaster < MiniTest::Unit::TestCase
  
  def setup 
    @config_data = { 'testers' => 
                      { 'users' => ['tester','tester2'], 
                        'public_keys' => ['key1','key2'], 
                        'hosts' => ['test1.com','test2.com']
                      } 
                   }
                 
    @keymaster = Moranis::KeyMaster.new(@config_data)
  end
  
  def test_invalid_configuration_error_is_raised
    assert_raises Moranis::NoValidConfigurationFoundError do
      Moranis::KeyMaster.new([])
    end
  end
  
  def test_groups_are_parsed_correctly
    assert_equal  ['testers'], @keymaster.groups
  end
  
  def test_public_keys_are_parsed_correctly
    assert_equal  ['key1','key2'], @keymaster.keys_for_group("testers")
  end
  
  def test_users_are_parsed_correctly
    assert_equal  ['tester','tester2'], @keymaster.users_for_group("testers")
  end
  
  def test_hosts_are_parsed_correctly
    assert_equal  ['test1.com','test2.com'], @keymaster.hosts_for_group("testers")
  end
  
end