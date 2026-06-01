#!/bin/bash
set -e

if ["$EUID" -ne 0]; then
    echo "Please run as root"
    exit 1
fi


# Task 1: Text Processing & Archiving
# Check for log files in /tmp/ with the specified patterns
patterns=("/tmp/"*_logs.txt "/tmp/"*.log "/tmp/"*tar.bz2 "/tmp/"all_system_setuid_files.txt)
for pattern in "${patterns[@]}"; do
    if compgen -G "$pattern" > /dev/null; then
        echo "$pattern: OK"
    else
        echo "$pattern: NOT FOUND"
    fi
done

# Task 2: User & Group Management
groups=("sysadmin")
users=("alex" "sarah")

for group in "${groups[@]}"; do
    if getent group "$group" > /dev/null; then
        echo "Group '$group': OK"
    else
        echo "Group '$group': NOT FOUND"
    fi
done

for user in "${users[@]}"; do
    if getent passwd "$user" > /dev/null; then
        echo "User '$user': OK"
    else
        echo "User '$user': NOT FOUND"
    fi
done

if getent passwd sarah | grep 'nologin' > /dev/null; then
    echo "User 'sarah' with nologin shell: OK"
else
    echo "User 'sarah' with nologin shell: KO"
fi

if chage -l bob | grep 'password must be changed' > /dev/null; then
    echo "User 'bob' password must be changed: OK"
else
    echo "User 'bob' password must be changed: KO"
fi

# Task 3: User & Group Management
if [[ -d "/tmp/shared" ]]; then
    echo "Directory '/tmp/shared': OK"
else
    echo "Directory '/tmp/shared': NOT FOUND"
fi

if [ "$(stat -c %G /tmp/shared)" = "${groups[0]}" ]; then
        echo "Directory '/tmp/shared' ${groups[0]} group ownership: OK"
else
        echo "Directory '/tmp/shared' ${groups[0]} group ownership: KO"
fi

mode=$(stat -c %a /tmp/shared)
special_permission=${mode:0:1}

if (( special_permission & 2 )); then
    echo "setgid: YES"
else
    echo "setgid: NO"
fi

if (( special_permission & 1 )); then
    echo "sticky bit: YES"
else
    echo "sticky bit: NO"
fi