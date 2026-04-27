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