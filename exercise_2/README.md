# Exercise 2

**Task:** <br />
Research online for 10 more linux commands aside the ones already mentioned in this module. Submit using your altschool-cloud-exercises project, explaining what each command is used for with examples of how to use each and example screenshots of using each of them.

## What is a Linux Command ?
Linux is a family of open-source Unix-like operating systems based on the Linux kernel. The Linux command is a utility of the Linux operating system. All basic and advanced tasks can be done by executing commands. The commands are executed on the Linux terminal. The terminal is a command-line interface to interact with the system, which is similar to the command prompt in the Windows OS. Commands in Linux are case-sensitive

## Types of Linux Commands
* Network Commands
* File Permission Commands
* User Management Commands
* Process Management Commands
* Search/Filter Commands etc.

There are many more these ones are discussed in this repository

### Network Commands

1. ``` $ ping [host] ```: <br />
This is a network command used to send Internet Control Message Protocol(ICMP) echo request to host for checking connection between two servers
<br />

**_Usage:_**
![ping](/exercise_2/images/ping.png)
<br />

2. ``` $ wget [File_To_Be_Downloaded] ```: <br />
This command is also a network command used to download a file over the internet
<br />

**_Usage:_**
![wget](/exercise_2/images/wget.png)
<br />

3. ``` $ netstat -nutlp ```: <br />
Display listening tcp and udp ports and corresponding
programs
<br />

### File Permission Commands
Every file permission command start with ``` chmod ``` which means change modification
<br />

4. ``` $ chmod u+x [FILE] ```: <br />
This is a file permission command thats grant execute permission to a user
<br />

**_Usage:_**
![u](/exercise_2/images/u.png)
<br />

5. ``` $ chmod g+x [FILE] ```: <br />
This is a file permission command thats grant execute permission to a particular group the owner of the file is associated with.
<br />

**_Usage:_**
![g](/exercise_2/images/g.png)
<br />


### User Management Commands

6. ``` $ Last ```: <br />
This is a user management command that displays the last users who logged into the system
<br />

**_Usage:_**
![last](/exercise_2/images/last.png)
<br />

7. ``` $ w ```: <br />
This command shows who is logged in what they are doing
<br />

**_Usage:_**
![w](/exercise_2/images/w.png)
<br />

### Process Management Commands
Most process management commands starts

8. ``` ps -ef ```: <br />
This is a process management command that displays all the currently running processes on the system
<br />

**_Usage:_**
![ps](/exercise_2/images/ps.png)
<br />

### Search/Filter Commands

9. ``` $ grep [PATTERN] [FILE] ```: <br />
 grep searches for PATTERNS in each FILE.  PATTERNS is one or more patterns separated by newline characters, and grep prints each line that matches a pattern. Typically PATTERNS should be quoted when grep is used in a shell command.
 <br />

**_Usage:_**
![grep](/exercise_2/images/grep.png)
<br />

10. ``` $ locate [NAME] ```: <br />
Find files and directories by NAME
<br />

**_Usage:_**
![locate](/exercise_2/images/locate.png)
<br />