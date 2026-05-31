#!/bin/bash
set -e

# Ask user to run as root
if ["$EUID" -ne 0]; then
   echo "Please run as root"
   exit 1
fi

# Clean up any traces from the log files (files, archives)
rm /tmp/*_logs.txt /tmp/*.log /tmp/*.tar.bz2 /tmp/all_system_setuid_files.txt

# Delete group and beloged users to it
userdel -r sarah
userdel -r alex
groupdel sysadmins

# Delete shared directory and all files inside it
rm -r /tmp/shared

echo "Cleanup successfully done"
