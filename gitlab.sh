#!/bin/bash

# Prints out username:home_directory of all users
echo "Print out users:home_directory"

awk -F: '{print $1":"$6}' /etc/passwd
# Stores output into a variable
output="$(awk -F: '{print $1":"$6}' /etc/passwd)"
# Output is hashed using md5 and stored in directory /var/log/current_users
hashOutput="$(echo -n $output | md5sum)"
cat /dev/null > /tmp/tmpdata.txt
touch /tmp/tmpdata.txt && echo $hashOutput >> /tmp/tmpdata.txt
if [[ -f /var/log/current_users ]] && [[ -s /var/log/current_users ]]
then
  hashedVal="$(cat /var/log/current_users)"
  hashOutput="$(cat /tmp/tmpdata.txt)"
  if [[ $hashOutput != $hashedVal ]]
  then
          echo $hashOutput "is not equal to" $hashedVal
          newdate="$(date)"
          echo "Date: "$newdate "HashValue: "$hashedVal  >> /var/log/user_changes
          echo $hashedVal "audit record added to /var/log/user_changes"
          cat /dev/null > /var/log/current_users
          echo $hashOutput >> /var/log/current_users
          echo $hashOutput "added to file /var/log/current_users"
          unset hashOutput
  else
      echo "/var/log/current_users file exist!!!"
  fi
else
   echo "File /var/log/current_users does not exist, file /var/log/current_users created!"
   echo $hashOutput >> /var/log/current_users
   echo Hashed Output: $hashOutput
fi

# Command to run cron job
if [[ -f /etc/cron.hourly/gitlab.sh ]] && [[ -s /etc/cron.hourly/gitlab.sh ]]
then
    echo "Job file exists"
else 
    echo "Job file could not be found..."
    chmod +x /root/gitlab.sh
	yes | cp -rf /root/gitlab.sh /etc/cron.hourly
	echo "Job file created..."
fi
