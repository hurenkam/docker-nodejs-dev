#!/bin/bash

# Create groups
cat /config/groups.conf | while read LINE
do
  value=(`echo $LINE | sed 's/:/\n/g'`)
  group=${value[0]}
  gid=${value[1]}
  echo "adding group $group with gid $gid" 
  addgroup --gid $gid $group
done

# Create users
cat /config/users.conf | while read LINE
do
  value=(`echo $LINE | sed 's/:/\n/g'`)
  user=${value[0]}
  uid=${value[1]}
  group=${value[2]}
  passwd=${value[3]}
  echo "adding user $user with uid $uid and password $passwd" 
  adduser -D -H -s /bin/false -u $uid -G $group $user
  echo "$user:$passwd" | chpasswd
  echo -e "$passwd\n$passwd" | smbpasswd -s -a -c /config/smb.conf "$user"
done

# Need to copy exports, since nfs-server can not be started with arbitrary config file
cp /config/exports /etc/exports

# run CMD
exec "${@}"

