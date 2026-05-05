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