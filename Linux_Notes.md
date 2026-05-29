1. Permissins in Linux

In Linux every file/dir has permissions for:
owner | group | others

Example: drwxrwxr-x

Splits into:
d rwx rwx r-x
  --- --- ---
   7   7   5

How the chars are defined?
Permission	Meaning
r	open/read
w	modify
x	execute
Directories
Permission	Meaning
r	list names
w	create/delete
x	enter/traverse

1.1 How the numbers are defined?
| Permissions | Number |
| ----------- | ------ |
| `---`       | 0      |
| `--x`       | 1      |
| `-w-`       | 2      |
| `-wx`       | 3      |
| `r--`       | 4      |
| `r-x`       | 5      |
| `rw-`       | 6      |
| `rwx`       | 7      |

1.2 Normal 3-digit chmod
Ex: chmod 775 file

It means a standard Unix permission model:
owner | group | others

1.3 Why sometimes there are 4 digits?
Sometimes there are special permissions:

Special Permission Digits Cheat Sheet
| First Digit | Name       | Symbol Appears As  | Typical Use                          | Important Notes                       |
| ----------- | ---------- | ------------------ | ------------------------------------ | ------------------------------------- |
| `1`         | Sticky Bit | `t`                | Shared writable directories (`/tmp`) | Users can delete only their own files |
| `2`         | Setgid     | `s` in group field | Team/shared directories              | New files inherit directory group     |
| `4`         | Setuid     | `s` in owner field | Special executables (`passwd`)       | Program runs as file owner            |

Then an extra digit is added in front. 
Ex: chmod 2775 dir ; where:
                            2 = setgid
                            775 = normal permissions
Or Ex: chmod 3775 /shared
    The special permission also can be added between each others. 


1.4 Core Linux Permissions Cheat Sheet
 
| Mode   | Symbolic    | Typical Use                                       | Important Notes                  |
| ------ | ----------- | ------------------------------------------------- | -------------------------------- |
| `644`  | `rw-r--r--` | Normal files                                      | Most common file permission      |
| `600`  | `rw-------` | Private/sensitive files                           | SSH keys, secrets                |
| `400`  | `r--------` | Read-only sensitive file                          | Rare but important               |
| `755`  | `rwxr-xr-x` | Executable files, system dirs                     | Most common directory permission |
| `700`  | `rwx------` | Private directories/scripts                       | User-only access                 |
| `775`  | `rwxrwxr-x` | Team shared directories                           | Group collaboration              |
| `777`  | `rwxrwxrwx` | Everyone full access                              | Usually BAD practice             |
| `1777` | `rwxrwxrwt` | Public writable dirs                              | `/tmp` standard                  |
| `2775` | `rwxrwsr-x` | Shared team directory with inherited group        | VERY RHCSA-relevant              |
| `3775` | `rwxrwsr-t` | Shared dir + inherited group + protected deletion | Advanced shared collaboration    |

1.5 How do the Special Permissions and PErmissions work together?
Permissions and special bits are different things.

Normal permissions
These apply separately to:
    - owner
    - group
    - others
Example:
rwxr--rwx
means:
    - owner → rwx
    - group → r--
    - others → rwx

Special permissions

Example: 1 (sticky bit) 
drwxr--rwt

It affects the whole directory behavior.
It affects the whole directory behavior.
Means:
Interpretation:
owner → rwx
group → r--
others → rwx
sticky bit enabled
Sticky bit still affects everyone:
owner
group users
others
It is NOT limited to others.

Example: 2 (Set gid)
rwxrwsr-x
Displayed in group execute position:
BUT:
setgid affects file group inheritance globally
not just group users

Example: 3 (Set uid)
rwsr-xr-x
Displayed in owner execute position:
BUT:
affects how the program runs
not only owner behavior

To sum up: The location where s or t is displayed is mostly a visual convention/history thing, not “scope of effect”.

1.6 How to use chmod with character and not numbers. 
The chmod 1755 it is the same as chmod +t
The chmod 2755 it is the same as chmod g+s
The chmod 4755 it is the same as chmod u+s 
