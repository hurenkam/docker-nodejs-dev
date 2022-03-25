#!/bin/bash

# Create users
while read LINE
do
  value=(`echo $LINE | sed 's/:/\n/g'`)
  user=${value[0]}
  uid=${value[1]}
  group=${value[2]}
  passwd=${value[3]}
  grep "^$user:" /etc/passwd
  if [ $? -ne 0 ]; then
    echo "adding user $user with uid $uid" 
    adduser --quiet --gecos "" --disabled-password --no-create-home --shell /bin/false --uid $uid --ingroup $group $user
    echo "$user:$passwd" | chpasswd
    echo -e "$passwd\n$passwd" | smbpasswd -s -a -c /config/smb.conf "$user"
  else
    echo "not adding user $user because it already exists" 
  fi
done

