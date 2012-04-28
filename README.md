##Moranis

Centralized Public Key management for small teams with lots of servers

#Why?
 
Because my team has many servers, many developers and few system administrators and LDAP is great but it adds more overhead.

#How?

The basic idea is that anyone on the team who already has key based access as a specific user can be trusted to grant that same access
to others. You or your system administrator may disagree but in practice this makes sense for small to medium sized teams.

The idea is pretty simple:
  Keep a local list of users, servers and keys. Any team member with key based access to a server can make changes to that server.
I recommend not using this for root accounts. 
• Connect to each host in the host list for a given user
• Write out the new authorized_keys.tmp file based on the locally enabled keys
• Test the new key file
• If any errors were encountered the old key file remains in place
• Otherwise the new key file remains in place

#Dependencies

• Capistrano

