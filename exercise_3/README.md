# Exercise 3

**Task**: <br/>
- Create 3 groups – admin, support & engineering and add the admin group to sudoers. 
- Create a user in each of the groups. 
- Generate SSH keys for the user in the admin group

## How I created a User, Group and adding group to Sudoers + Generating SSH key
In the task we are to create three groups - admin, support and engineering and attaching a user to each of them

### Creating A Group
There are two ways of creating a group:

1. Becoming a root user and then create a group

```
$ sudo su
root@ubuntu:~$ groupadd [GROUP_NAME]
```

2. Leveraging root privileges using ```sudo``` and then create a group

```
$ sudo groupadd [GROUP_NAME]
```