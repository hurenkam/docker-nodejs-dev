#!/bin/bash

# Create groups
while read LINE
do
  value=(`echo $LINE | sed 's/:/\n/g'`)
  group=${value[0]}
  gid=${value[1]}
  grep "^$group:" /etc/group
  if [ $? -ne 0 ]; then
    echo "adding group $group with gid $gid" 
    #addgroup --gid $gid $group
  else
    echo "group $group already exists, skipping"
  fi 
done

