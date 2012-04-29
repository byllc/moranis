#Moranis

Centralized Public Key management for small teams with lots of servers 

##Why?
 
Because my team has many servers, many developers and few system administrators and LDAP is great but it adds more overhead.
This project currently only support SSH1/openSSH1 because in practice I have yet to need support for the second generation variants
and did not want to have to write out two different key file formats but adding support should not be difficult

##How?

The basic idea is that anyone on the team who already has key based access as a specific user can be trusted to grant that same access
to others. You or your system administrator may disagree but in practice this makes sense for small to medium sized teams.

The idea is pretty simple:
  Keep a local list of users and public keys that can be sync'd to many hosts that contain those users.

I recommend not using this for root accounts. Basically always make sure there is an account that you can access to revert any
rogue changes that render an account non accessible. The revert feature will fall back to root if the original user is not accessible.
This means that a team member with root access may need to perform the revert for a user that does not have that access
 
* Connect to each host in the host list for a given user
* Write out the new authorized_keys.tmp file based on the locally enabled keys
* Test the new key file
* If any errors were encountered the old key file remains in place

##Usage

###Standalone
A binary called key_master is installed with the gem. The binary accepts two required and one optional paramters
The action you want to take for the group, The group you want to sync the keys for, and a config file that contains the users
hosts and keys.  

The config file portion can be removed if you set MORANIS_CONFIG_PATH in your environment to the path to your config file or if your
present working directory is relative to the config file as ./config/moranis.yml


```bash
key_master sync group_name_1 ./config/config.yml

key_master sync group_name_1
````

The config file format is as follows

```haml

group_name_1:
  hosts:
    - host1.com
    - host2.com
  users: 
    - user1
    - user2
  keys:
    - ssh-dss key1abcdeif....
    - ssh-rsa key2abcdeif....


group_name_2:
  hosts:
    - host1a.com
    - host2a.com
  users:
    - user1a
    - user2a
  keys:
    - ...
 
````
###Use From your code
```ruby
require 'moranis'

key_master = Moranis::KeyMaster.new(config_path)

#sync the keys with the local configuration on the specified group
key_master.run_for_group(group)

#revert the keys fro the specified group to the most recent backup
key_master.revert_for_group(group)
````
##TODO
* Add support for a key database as well as the current yml file
* Add more fault tolerance and error handling, add checking to see if the root account is being synced and provide a warning
* Tests
* Support for ssh2/openssh2
 