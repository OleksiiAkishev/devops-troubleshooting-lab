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