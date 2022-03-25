#!/bin/bash

# Delete users
while read LINE
do
  value=(`echo $LINE | sed 's/:/\n/g'`)
  user=${value[0]}
  grep "^$user:" /etc/passwd
  if [ $? -ne 1 ]; then
    echo "removing user $user" 
    #deluser $user
    #smbpasswd -s -x -c /config/smb.conf "$user"
  else
    echo "user $user not found, skipping" 
  fi
done

