#!/bin/bash

# Create groups
while read LINE
do
  value=(`echo $LINE | sed 's/:/\n/g'`)
  group=${value[0]}
  grep "^$group:" /etc/group
  if [ $? -ne 1 ]; then
    echo "deleting group $group" 
    delgroup $group
  else
    echo "group $group not found, skipping"
  fi 
done

