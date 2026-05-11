# Notes

1. Create a repo a defined a structured:
    - linux/logs kubernetes/manifests cicd/scripts
2. Create a dummy logs file and put some template logs:
    - practice with grep, awk, sed

2.1 
    - grep: text filtering, by default case sensetive
        if insensetive use: -i
        e.g:
            grep "ERROR" linux/logs/app.log
            grep -i "ERROr" linux/logs/app.log
    Useful for filtering text files, logs.

    - awk: text processing tool; it reads the input line by line; can filter, tranform, print data
        e.g:
            awk '{print $2}' test.txt
            grep "ERROR" linux/logs/app.log | awk '{print $4}' --> prints only all data under column 4
                output:
                    user=456
                    user=123
                    user=456
    - sed: reads the input (STDIN or file) as a stream, transforms it and prints the results (STDOUT or file).
        e.g:
            grep -i "Error" linux/logs/app.log | awk '{print $4}' | sed 's/user=//'
                output:
                    456
                    123
                    456
            or
            grep -i "Error" linux/logs/app.log | awk '{print $4}' | sed 's/user=/id=/'
                output:
                    id=456
                    id=123
                    id=456
        where syntax:
            sed 's/old/new/'
                s = substitute
                old = pattern to find
                new = replacement
            sed 's/old/new/g -> all matches per line                

What does the pipe ("|") actually do? - it connects the output of the previous program to the input of the next one. Where the bash itself plays role as an orhestrator, connects them as a chain. The shell connects programs via STDIN/STDOUT using pipes; each program is unaware of the others

Note: Linux commands split by
    - Shell executed commands (cd, echo, etc) - part of the shell process.
    - External commands (grep, ls, vim, etc) - separated process (self executed applications) started by the shell. 

Why need 3 tools, while the sed can do all as grep and awk do.
Each tool does one thing well:
    grep → select. Use grep when you just need to find
    sed → transform. Use sed when you just need to edit
    awk → analyze. Use awk when you need logic, structure, or computation
Chaining them makes pipelines easier to reason about and debug.

2.2. How to read CLI manuals (man page)
    Always split into:
        What is required?
        What is optional? ([])
        What repeats? (...)
    Pattern example [OPTION]... PATTERNS [FILE]...
        means:
            options → optional, many allowed
            pattern → required
            file → optional, many allowed

3. Learned about inodes and disk full concept. 
4. Learned file descriptors
   - /proc/<PID>/fd
live view of all file descriptors currently open by that process.

What causes a new FD to appear?
A process gets a new FD when it opens things like:
    a file (open())
    a network connection (socket(), connect())
    a pipe
    a device
    a database connection
    another process communication channel


5. Learned Zombie process
6. Learned on set -euo pipefail
    is a common safety setting in Bash scripts. It turns on three options that make scripts fail fast and avoid subtle bugs:
        -e (errexit): exit immediately if any command returns a non-zero (error) status.
        → Prevents the script from continuing after a failure.
        -u (nounset): treat use of undefined variables as an error and exit.
        → Catches typos or missing inputs (e.g., $foo when foo isn’t set).
        -o pipefail: makes a pipeline (cmd1 | cmd2 | cmd3) fail if any command in it fails, not just the last one.
        → Without this, only the exit status of the last command is checked.

So, basically set -euo pipefail helps to prevent undesired continuation of the script if failed on the step, interept the process if variable is not defined or pipe is silently failed.
    Examples:
    1:
        set -e
            cp important.txt /backup/   # fails → script stops
            rm important.txt            # never runs
    2: 
        -u (undefined variables)
            echo "$PORT"
            Without -u: prints empty string (bug hidden)
            With -u: script exits immediately (bug visible)
    3: 
        cat missing.txt | grep foo
            Without pipefail: may succeed if grep runs → error hidden
            With pipefail: fails properly if cat fails
7. Learned on default variable set
1. :- (most common)
${VAR:-default}

👉 Uses default if VAR is:

unset or
empty ("")
2. - (without colon)
${VAR-default}

👉 Uses default only if VAR is unset,

8. Learned on lsof (LiSt Open Files)
On Unix/Linux systems, “everything is a file” — including:

regular files
directories
network sockets
devices
pipes

Example: sudo lsof -i -P -n | head -n 20

lsof → list open files
-i → show network-related files/connections
-P → show port numbers instead of service names
-n → don't resolve IPs to hostnames (faster)
| head -n 20 → only display the first 20 lines

Typical use cases:

find what process uses a port
inspect active network connections
debug servers/services

Try example:
   - Run simple http server: python3 -m http.server 8080 &
   - Check network connections: lsof -i ; try with ports mapping now lsof -i -P
   - Find it in the processes now by PID or generally in list:
        ps -fp 8069 or just ps; where -f, full formating string and -p, process select by PID.

ps → “What processes exist?”
lsof → “What files/resources are opened by processes?”

So lsof can show: open files, directories, pipes, devices, TCP/UDP sockets

while ps focuses on: process state, CPU/memory usage, parent/child,relationships, command lines, scheduling info

- readlink -f /proc/$PID/exe
    /proc/<PID>/exe points to the executable binary currently running for that process.

    Means, as example, the PID which is running needs the environment like JRE or Python, thus it will show the path where the runtime environment is present. 

`
ps
8069 pts/0    00:00:00 python3

lsof -i
COMMAND  PID           USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
python3 8069 oleksiiakishev    3u  IPv4  62676      0t0  TCP *:http-alt (LISTEN)

 readlink -f /proc/8069/exe
 /usr/bin/python3.12
`

or

`
ps
    PID TTY          TIME CMD
    373 pts/0    00:00:00 bash

# Check by whom the bash process is ran

readlink /proc/373/exe
/usr/bin/bash
`

To sum up: /proc/8069/exe is called a symlink, created by the kernel. Where symlink is a shortcut or reference to another file.

# Check the command line arguments used to start the process.

- /proc/8069/cmdline , contains those arguments
    - The thing is that they are stored in a special format:    
            arguments separated by NULL bytes (\0) and not normal spaces/newlines.
So, the final command: tr '\0' ' ' < /proc/<PID>/cmdline; echo
    tr
        → translate characters
    '\0'
        → replace NULL bytes
    ' '
        → with spaces
    echo
        → adds a final newline because cmdline usually doesn’t end with one.

# Check the list of FDs of the PID
- sudo ls -l /proc/<PID>/fd
    0 -> /dev/pts/0
    1 -> /dev/pts/0
    2 -> /dev/pts/0
    3 -> 'socket:[62676]'
The number (62676) is a kernel socket inode number.
Linux treats sockets like files in the kernel. So it needs:
a way to track them internally
a unique identifier per socket object

Model:
FD (3)
  ↓
socket object
  ↓
inode (62676)
  ↓
real TCP connection (IP:port)

# Take socket:[62676] and find the exact remote IP and port it is connected to

1. Check inode number of the socket object:
    ls -l /proc/8069/fd

2. Find which socket it is
ss -e -p -a | grep <inode_socket>

ss → socket statistics tool
-e → extended info (includes inode)
-p → show process info
-a → include everything (listening + active + idle)

Example of output:

`
ss -e -p -a | grep 62676
tcp   LISTEN  0      5                                                     0.0.0.0:http-alt                 0.0.0.0:*          users:(("python3",pid=8069,fd=3)) uid:1000 ino:62676 sk:b4 cgroup:/init.scope <->
`

---

## 1. `lsof` view (process-centered)

```text id="l1a9qz"
python3 8069 user 3u IPv4 62676 0t0 TCP *:8080 (LISTEN)
```

### How to read it:

* `python3` → process name
* `8069` → PID
* `3u` → file descriptor 3, opened for read/write (`u` = update)
* `IPv4` → socket type
* `62676` → kernel socket inode
* `*:8080` → listening on all interfaces, port 8080
* `(LISTEN)` → server waiting for connections

### Mental model:

```text id="k8q1mv"
"process 8069 is holding FD 3,
which is a socket listening on port 8080"
```

So `lsof` answers:

> “What does this process have open?”

---

## 2. `ss` view (network-centered)

```text id="s9x2pl"
tcp LISTEN 0 5 0.0.0.0:http-alt 0.0.0.0:* users:(("python3",pid=8069,fd=3)) uid:1000 ino:62676 sk:b4 cgroup:/init.scope
```

This is richer but more abstract.

---

### Break it down:

#### a) Socket state

```text id="a1k7vx"
LISTEN
```

Same meaning: waiting for connections.

---

#### b) Queues

```text id="q3m9nx"
0 5
```

* `0` → number of pending received connections
* `5` → maximum backlog queue size

👉 Think: how many incoming connections are waiting before accept() handles them.

---

#### c) Address binding

```text id="d7m2qp"
0.0.0.0:http-alt
```

* `0.0.0.0` → all network interfaces
* `http-alt` → service name for port 8080

So:

```text id="w4n1kq"
listening on all IPs, port 8080
```

---

#### d) Remote side

```text id="r8p3lx"
0.0.0.0:*
```

Meaning:

* no client connected yet
* it's a server socket

---

#### e) Process info

```text id="p6x1mv"
users:(("python3",pid=8069,fd=3))
```

Same mapping as `lsof`.

---

#### f) inode match

```text id="i9q4nz"
ino:62676
```

This is the same kernel socket object you saw earlier.

---

## 3. Key difference in mindset

### `lsof`

```text id="m1v8qz"
Process → what resources it opened
```

### `ss`

```text id="n7k2xp"
Network system → what sockets exist and who owns them
```

---

## 4. Why `ss` feels more confusing

Because it includes extra networking concepts:

* backlog queues
* interface binding (`0.0.0.0`)
* service name resolution (`http-alt`)
* kernel socket metadata (`sk:b4`, `cgroup:/init.scope`)

It is closer to:

```text id="c3m8vz"
kernel networking internals
```

while `lsof` is:

```text id="t9p2qx"
process view of resources
```

---

## 5. Simple mental mapping

Your example:

```text id="x7n9mv"
python3 (PID 8069)
   ↓
FD 3
   ↓
socket inode 62676
   ↓
TCP LISTEN on port 8080
```

Both tools show the same chain, just from opposite ends:

| Tool   | Perspective      |
| ------ | ---------------- |
| `lsof` | process → socket |
| `ss`   | socket → process |

---

## 6. One-line intuition

If you want to remember it simply:

```text id="v5k9mx"
lsof = “what does this process use?”
ss   = “what sockets exist on the system?”
```

---

Full model:
process (PID 8069)
   ↓
file descriptor (FD 3)
   ↓
/proc/8069/fd/3
   ↓
socket:[62676]
   ↓
kernel socket object
   ↓
TCP connection
   ↓
192.168.1.10:52344 → 142.250.74.14:443
