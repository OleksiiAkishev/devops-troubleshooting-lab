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