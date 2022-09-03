# Exercise 3

**Task**: <br/>
- Create 3 groups – admin, support & engineering and add the admin group to sudoers. 
- Create a user in each of the groups. 
- Generate SSH keys for the user in the admin group

## How I created a User, Group and adding group to Sudoers + Generating SSH key
In the task we are to create three groups - admin, support and engineering and attaching a user to each of them

### Creating A Group
There are two methods of creating a group:

1. Becoming a root user and then create a group

```
$ sudo su
root@ubuntu:~$ groupadd [GROUP_NAME]
```

2. Leveraging root privileges using ```sudo``` and then create a group

```
$ sudo groupadd [GROUP_NAME]
```

*** For this exercise I used the second method ***

```
$ sudo groupadd admin
$ sudo groupadd support
$ sudo groupadd engineering
```

When I ran ```sudo groupadd admin``` the VM gave me a warning that admin already exists

```
$ cat /etc/group
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:syslog,ubuntu
tty:x:5:syslog
disk:x:6:
lp:x:7:
mail:x:8:
news:x:9:
uucp:x:10:
man:x:12:
proxy:x:13:
kmem:x:15:
dialout:x:20:ubuntu
fax:x:21:
voice:x:22:
cdrom:x:24:ubuntu
floppy:x:25:ubuntu
tape:x:26:
sudo:x:27:ubuntu
audio:x:29:ubuntu
dip:x:30:ubuntu
www-data:x:33:
backup:x:34:
operator:x:37:
list:x:38:
irc:x:39:
src:x:40:
gnats:x:41:
shadow:x:42:
utmp:x:43:
video:x:44:ubuntu
sasl:x:45:
plugdev:x:46:ubuntu
staff:x:50:
games:x:60:
users:x:100:
nogroup:x:65534:
systemd-journal:x:101:
systemd-network:x:102:
systemd-resolve:x:103:
systemd-timesync:x:104:
crontab:x:105:
messagebus:x:106:
input:x:107:
kvm:x:108:
render:x:109:
syslog:x:110:
tss:x:111:
uuidd:x:112:
tcpdump:x:113:
ssh:x:114:
landscape:x:115:
admin:x:116:
netdev:x:117:ubuntu
lxd:x:118:ubuntu
vagrant:x:1000:
systemd-coredump:x:999:
ubuntu:x:1001:
vboxsf:x:998:
support:x:1002:
engineering:x:1003:
```

### Creating A User
There are two methods of creating a user:

1. Becoming a root user and then create a user

```
$ sudo su
root@ubuntu:~$ useradd [USER_NAME]
```

2. Leveraging root privileges using ```sudo``` and then create a group

```
$ sudo useradd [USER_NAME]
```

*** For this exercise I used the second method ***

```
$ sudo useradd admin_onyeka
$ sudo useradd support_onyeka
$ sudo useradd engineer_onyeka
```

Check the content of the ```/etc/passwd```

```
$ cat /etc/passwd | tail -5
lxd:x:998:100::/var/snap/lxd/common/lxd:/bin/false
vboxadd:x:997:1::/var/run/vboxadd:/bin/false
admin_onyeka:x:1002:1004::/home/admin_onyeka:/bin/sh
support_onyeka:x:1003:1005::/home/support_onyeka:/bin/sh
engineer_onyeka:x:1004:1006::/home/engineer_onyeka:/bin/sh
```

### How to add a group to Sudoers
I used the ```sudo visudo``` to be able to modify this file

Then I found out that the user **_Admin_** has already been given root privileges

```
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
```

### How to add a user to a group

To add a user I used 

```
$ usermod -aG admin admin_onyeka
$ usermod -aG support support_onyeka
$ usermod -aG engineering engineer_onyeka
```

To check if a user is successfully added to a group

``` 
$ cat /etc/group | tail -15
tcpdump:x:113:
ssh:x:114:
landscape:x:115:
admin:x:116:admin_onyeka
netdev:x:117:ubuntu
lxd:x:118:ubuntu
vagrant:x:1000:
systemd-coredump:x:999:
ubuntu:x:1001:
vboxsf:x:998:
support:x:1002:support_onyeka
engineering:x:1003:engineer_onyeka
admin_onyeka:x:1004:
support_onyeka:x:1005:
engineer_onyeka:x:1006:
```

### How to generate a SSH key

To generate ssh key for admin_onyeka

I set a password for admin and then logged into the group<br/>
I used ```sudo``` because admin_onyeka is associated to the admin group which has root privileges

```
$ sudo passwd admin_onyeka
New password:
Retype new password:
passwd: password updated successfully
$ sudo su admin_onyeka
``` 

To generate ssh-key we use the command:
```
ssh-keygen
```
And specify were the key will be stored