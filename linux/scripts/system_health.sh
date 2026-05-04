#!/bin/bash

white_list_inodes="tmpfs devtmpfs proc sysfs cgroup2 cgroup autofs binfmt_misc squashfs debugfs tracefs pstore"
df -i -T | awk -v inodes_usage_threshold="$1" -v white_list_inodes="$white_list_inodes" '
NR > 1 { 
    gsub("%", "", $6);
    if ($6 >= inodes_usage_threshold) {
        if (index(white_list_inodes, $2) != 0) {
            print "WARNING:", "filesystem", $1, "of type", $2, "has", $5, "inodes used:", $6"%"
        } else {
            print "CRITICAL:", "filesystem", $1, "of type", $2, "has", $5, "inodes used:", $6"%"
        }
    }
}'