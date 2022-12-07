#!/bin/bash

# Check if we are root privilage or not
if [[ "${UID}" -ne 0]]
then
    echo "Please run this script with sudo or as root"
    exit 1
fi

# Which files are we going to back up. Please make sure to exist /home/ec2-user/data file
backup_files="/home/ec2-user/data /etc /usr /opt"
# Where do we backup to. Please crete this file before execute this script
destination="/mnt/backup"
# Create archive filename based on time
time=$(date +"%Y_%m_%d_%I_%M_%p")
hostname=$(hostname -s)
archive_file="${hostname}-${time}.tgz"

# Print start status message.
echo "We will backup ${backup_files} to ${destination}/${archive_file}"
date
echo
# Backup the files using tar.
tar czf ${destination}/${archive_file} ${backup_files}
# Print end status message.
echo 
echo "Congratulations! Your backup is ready!"
date
# Long listing of files in $dest to check file sizes.
ls -lh ${destination}
