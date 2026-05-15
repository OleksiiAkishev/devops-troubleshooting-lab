RHCSA (EX200) Preparation & Portfolio Plan
> **Status:** Active Plan (Week 1 Detailed)
> **Goal:** Pass the RHCSA purely through self-study, AI-generated practical drills, and local labs. Build portfolio artifacts along the way.
> **Philosophy:** RHCSA is 100% practical. No multiple-choice questions. You must configure, troubleshoot, and persist changes across reboots. Muscle memory is everything.
---
1. The Strategy: Can you do it without expensive courses?
Absolutely. The RHCSA is a test of knowing how to use standard Linux tools and man pages.
However, you cannot practice for the RHCSA in Docker containers. You need actual Virtual Machines because you will be messing with the bootloader (GRUB), kernel parameters, partitioning disks, and configuring network interfaces.
Your Environment Setup (Prerequisite):
Hypervisor: VirtualBox, VMware Player, or KVM.
VMs: Create 2 VMs using Rocky Linux 9, AlmaLinux 9, or the free RHEL Developer Subscription.
VM1 (server1): Main practice node (needs an extra 10-20GB virtual disk attached for LVM/Storage practice).
VM2 (server2): Client node (used later for testing SSH, NFS, AutoFS, and HTTP/Firewall rules).
---
2. Full Picture Roadmap (8-Week Curriculum)
Each week corresponds to major objective groups. You will store your practice scripts, notes, and "broken state" generators in `devops-troubleshooting-lab/rhcsa`.
Week	Focus Area	Core Topics & Commands	Portfolio Element
1	Essentials, Users & Permissions	File mgmt, `tar`, `grep`, Users/Groups, `chmod`, `chown`, ACLs, `setgid`.	User/Audit Automation: Script that audits `setuid` files and generates a locked-down project directory.
2	Operate Running Systems & Boot	`systemd`, `journalctl`, `tuned`, GRUB, root password reset, `kill`, `nice`.	System Recovery Lab: Documentation + script to break boot and recover from a lost root password.
3	Local Storage & File Systems	MBR/GPT, `fdisk`, `parted`, LVM (`pv`, `vg`, `lv`), `mkfs.xfs/ext4`, `mount`, `/etc/fstab`.	Storage Manager: Bash script automating zero-downtime LVM expansion and reporting.
4	Network Storage & AutoFS	NFS Server/Client, `autofs` direct and indirect maps.	NFS/Autofs Provisioner: Automated setup of dynamic home directories across 2 VMs.
5	Basic Networking & Security	`nmcli`, `hostnamectl`, `firewalld`, `ssh-keygen`, SELinux contexts, booleans.	Firewall & SELinux Hardening Script: A robust script adapting a system to strict network security.
6	Software & Containers	`dnf`, RPM, Flatpaks, Podman (run, volumes, systemd integration).	Containerized Service: Deploy an app via Podman and manage it persistently via `systemctl`.
7	Shell Scripting Mastery	`if/then`, `for` loops, arguments, variables, exit codes.	The "Grader" Script: A script that evaluates if a system passes specific RHCSA criteria.
8	Mock Exams (Speed Runs)	Full 2.5-hour simulated exams.	Exam Strategy Guide: Time management, verification checklist, reboot-survival tests.
---
3. WEEK 1: Essential Tools, Users, & Strict Permissions
3.1 Focus Brief
RHCSA starts with foundational skills. If you can't redirect text, compress files, or manage standard permissions, the rest of the exam is impossible.
Watch out for in the exam:
Persistence: If you create a user or change a permission, it must survive a reboot.
SetGID & Sticky Bit: Crucial for collaborative directories.
Redirection: Appending (`>>`) vs overwriting (`>`). Overwriting a critical file during the exam is an instant fail.
3.2 Daily Practice Tasks
Task 1: Text Processing & Archiving
Find all log messages in `/var/log` that contain the word "error" (case-insensitive) and save them to `/root/error_logs.txt`.
Archive and compress the `/etc` directory using `tar` and `bzip2` into `/tmp/etc_backup.tar.bz2`.
Find all files on the system with the `setuid` bit set and redirect the list to `/root/setuid_files.txt`.
Task 2: User & Group Management
Create a group called `sysadmins`.
Create a user `alex` with a secondary group `sysadmins`.
Create a user `sarah` with a non-interactive shell (`/sbin/nologin`).
Force user `alex` to change their password on the next login.
Task 3: Collaborative Permissions (Very frequent exam task)
Create a directory `/data/shared`.
Set the group ownership of `/data/shared` to `sysadmins`.
Configure permissions so that any new file created inside `/data/shared` automatically inherits the `sysadmins` group (hint: `setgid`).
Ensure that only the owner of a file can delete it within that directory (hint: sticky bit).
3.3 Hands-on Artifact (for `devops-troubleshooting-lab/`)
Create an Environment Generator & Validator.
Instead of just doing the tasks, write a script `rhcsa/week1_setup.sh` that creates a scenario for you to fix, and another script `rhcsa/week1_verify.sh` that checks if you did it right.
Portfolio Value: Proves you don't just know how to run commands, but you understand system state and Bash scripting well enough to audit a Linux environment.
3.4 Weekend Speed Drill (Mock Task)
Set a timer for 15 minutes. Start with a fresh VM snapshot.
Create group `devops`.
Create users `dev1` and `dev2`, assign them to `devops`.
Create `/opt/project_alpha`. Group owner: `devops`. Set `setgid`.
Ensure others have absolutely no access to `/opt/project_alpha`.
Find all files owned by `dev1` and copy them to `/root/dev1_files/`.
Reboot. Verify everything still works and permissions are exactly as requested.
3.5 Reflection (Checklist for success)
[ ] If I create a hard link, then delete the original file, does the hard link still work? Is it the same for a soft link?
[ ] What is the exact octal number to set read/write/execute for owner, read/execute for group, and set the SGID bit? (e.g., `chmod 2775`)
[ ] Can I use `grep` and `awk` together to parse the output of `ps` or `ls`?
