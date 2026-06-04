# Week 1

# Task 1
1. Find all logs in path for the specific match case.
    (sudo) grep -Ri "error" /var/log

2. Stream all logs in the specific file
    - Overwrite (create if missing)
        sudo grep -ri "error" /var/log > ~/error_logs.txt
    - Append
        sudo grep -ri "error" /var/log >> ~/error_logs.txt
2.1 Move the file into working folder
    With parent dir check and creation:
    mkdir -p ~/trainings/temp && mv ~/error_logs.txt ~/trainings/temp

3. Find and compress and archive the txt file, and put the archive in the desired location. 
    xz: best compression
        sudo tar -cJf ~/trainings/temp/error_logs.tar.xz ~/trainings/temp/error_logs.txt
    gzip: best spead
        sudo tar -czf ~/trainings/temp/error_logs.tar.gz ~/trainings/temp/error_logs.txt

3.1 Check file size
    human format:
        ls -lh filename
            Example:
                ls -lh ~/trainings/temp
                    total 52K
                    -rw-r--r-- 1 root           root           4.1K May 20 16:47 error_logs.tar.gz
                    -rw-r--r-- 1 root           root           3.7K May 20 16:49 error_logs.tar.xz
can see that xz did better compression.

3.2 Add a checksum for intergrity
    sha256sum ~/trainings/temp/error_logs.tar.xz > ~/trainings/temp/error_logs.tar.xz.sha256
    3.2.1 Check: cat ~/trainings/temp/erro
r_logs.tar.xz.sha256

4. Find files with the `setuid` bit set.

sudo find / -perm -4000 -type f 2>/dev/null

A file with the setuid bit set runs with the permissions of the file owner, not the user executing it.

# Task 2
1. Create a group
sudo groupadd sysadmins
2. Create a user with the secondary group sysadmins
sudo useradd -G sysadmins alex
3. Change/update the password for the user
sudo passwd alex
4. Check user switch (su: substitute user): 
    su - alex
    Output: promt for the passwd
5. Interactive/Non-interactive user creation.
    a. sudo useradd -m -s /bin/bash alice
       sudo passwd alice
    b. sudo useradd -m -s /sbin/nologin bob
        # optional: leave bob password unset/locked so no password login is possible:
        sudo passwd -l bob
            where:  
                    -m: create the user's home directory (usually /home/username) and populate it from skeleton files.
                    -s <shell>: set the user's login shell (what runs when they get an interactive session).
6. Force user to change the password on the next login
    Simple: sudo passwd -e bob
    When need additonal flags: 
        - passwd change: sudo chage -d 0 alex
        - info check: sudo chage -l alice

# Task 3
1. Directory creation
    /data/shared

2. Set the owner ship to the sysadmins
chgrp sysadmins /data/shared

3. Configure permission to any file inside /data/shared, automatically inherits the sysadmins group 
chmod g+s /tmp/shared or chmod 2775 /tmp/shared
NOte: to undo chmod g-s /tmp/shared or chmod 0755 /tmp/shared
TO not loose your existing permissions on the directory, it maybe needed to use command as:
chmod g+ws /tmp/shared

NOte: most probably the changes won't be taken into consideration, thus you need to do via sudo only.


3.1 Check if shared folder is open in write access to the group.
Note: make sure that the place where non root wants to create a file (even if it is a part of the specific group) has the right access to do so. 
Ex: namei -l /tmp/shared
f: /tmp/shared
dr-xr-xr-x root        root      /
drwxrwxrwt root        sysadmins tmp
drwxr-xr-x oleksii_ops sysadmins shared
    Where:
getent group sysadmins
sysadmins:x:1001:alex

The key problem that drwxr-xr-x oleksii_ops sysadmins shared has not write(w) access for the groups, the same case for the /
NOte: namei -l /tmp/shared; Breaks the full path into components and shows permissions for each part
3.2 Change the mode for the dedicated shared directory for sysadmins group. 
Ex: namei -l /tmp/shared
f: /tmp/shared
dr-xr-xr-x root        root      /
drwxrwxrwt root        sysadmins tmp
drwxr-xr-x oleksii_ops sysadmins shared

Then
chmod 775 /tmp/shared

# Week 2

# Task 1

httpd stands for HTTP Daemon. Turns your Linux machine into a web server. Perfect tool: to manage services, firewalls, permissions.

- daemon: something sits at the background
- install command: dnf install -y httpd
    where:
        dnf: red hat package manager
        -y: auto yes to all
        httpd: the Apache HTTP Server package

- verify if installed: 
        rpm -q httpd
- Start service immediaately and configure it to start automatically at boot: 
        sudo systemctl enable --now httpd
- Check if active: 
        systemctl status httpd
- check logs: 
        journactl -u httpd
- check current storage of the journal:
        sudo journalctl --disk-usage
  journal files maybe stored:
        /run/log/journal or /var/log/journal
- Configure the system journal to persist across reboots:
        mkdir -p /var/log/journal
        systemd-tmpfiles --create --prefix /var/log/journal
        systemctl restart systemd-journald
 verify: journalctl --list-boots

# Task 2

1. Create CPU intensive processes
Start background jobs:
    dd if=/dev/zero of=/dev/null &
Verify:
    jobs

2.Find the processes
    ps (processes status) or ps -ef
        where e: show every process
              f: full format listing
2.1 Check the CPU usage of the processes:
    ps -eo pid,pcpu,pmem,comm
        where:
              e: every process
              o: output format:
 
