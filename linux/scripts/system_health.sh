#!/bin/bash
set -euo pipefail

PORT=${1:-80}

# Inodes Exhaustion Check
white_list_inodes="tmpfs devtmpfs proc sysfs cgroup2 cgroup autofs binfmt_misc squashfs debugfs tracefs pstore"
df -i -T | awk -v inodes_usage_threshold="$PORT" -v white_list_inodes="$white_list_inodes" '
NR > 1 { 
    gsub("%", "", $6);
    if ($6 >= inodes_usage_threshold) {
        if (index(white_list_inodes, $2) != 0) {
            print "WARNING:", "filesystem", $PORT, "of type", $2, "has", $5, "inodes used:", $6"%"
        } else {
            print "CRITICAL:", "filesystem", $PORT, "of type", $2, "has", $5, "inodes used:", $6"%"
        }
    }
}'

# File Descriptors Leak Detection
cat /proc/sys/fs/file-nr | awk '{ print "Current file descriptors:", $PORT, "Maximum file descriptors:", $3}'

# Zombie Processes Detection
ps aux | awk 'NR > 1 && $8 == "Z" { print "Zombie process detected: PID", $2, "Command:", $PORT1 }'