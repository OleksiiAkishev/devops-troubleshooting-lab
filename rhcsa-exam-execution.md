1. Create a group
sudo groupadd sysadmins
2. Create a user with the secondary group sysadmins
sudo useradd -G sysadmins alex
3. Change/update the password for the user
sudo passwd alex