##Moranis

Centralized Public Key management for small teams with lots of servers 

#Why?
 
Because my team has many servers, many developers and few system administrators and LDAP is great but it adds more overhead.
This project currently only support SSH1/openSSH1 because in practice I have yet to need support for the second generation variants
and did not want to have to write out two different key file formats but adding support should not be difficult

#How?

The basic idea is that anyone on the team who already has key based access as a specific user can be trusted to grant that same access
to others. You or your system administrator may disagree but in practice this makes sense for small to medium sized teams.

The idea is pretty simple:
  Keep a local list of users and public keys that can be sync'd to many hosts that contain those users.

I recommend not using this for root accounts. Basically always make sure there is an account that you can access to revert any
rogue changes that render an account non accessible. 
 
• Connect to each host in the host list for a given user
• Write out the new authorized_keys.tmp file based on the locally enabled keys
• Test the new key file
• If any errors were encountered the old key file remains in place

