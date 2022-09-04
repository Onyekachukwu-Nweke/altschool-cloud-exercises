![php](/exercise_4/img/PHP-logo.svg.png)

# Exercise 4

**Task**:<br/>
- Install PHP 7.4 on your local linux machine using the ppa:ondrej/php package repo.

**_Instruction:_**<br/>
- Learn how to use the add-apt-repository command
- Submit the content of /etc/apt/sources.list and the output of php -v command

## How to install an application using the ``` add-apt-repository ``` Command for Ubuntu linux user

There are several ways of installing applications in linux systems depending on the distribution you are using. But for this exercise I was told to use the PPA method to do the installation

### What is PPA ?
It stands for Personal Package Archives, they are software repositories designed for Ubuntu users and are easier to install than other Third-party repository.

### How to install using the PPA method
First, you add the repository to the Ubuntu machine
```
sudo add-apt-repository [options] repository
```

<br/>

For installation of **_PHP 7_** using PPA method
```
$ sudo add-apt-repository ppa:ondrej/php

Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
Get:2 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:3 http://ppa.launchpad.net/ondrej/php/ubuntu focal InRelease [23.9 kB]
Get:4 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:5 http://archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:6 http://ppa.launchpad.net/ondrej/php/ubuntu focal/main amd64 Packages [106 kB]
Get:7 http://ppa.launchpad.net/ondrej/php/ubuntu focal/main Translation-en [34.6 kB]
Fetched 500 kB in 12s (41.8 kB/s)
Reading package lists... Done
```
<br/>
Now the PPA repository of PHP has been added to the machine and now the PHP package can be installed using ``` apt ``` package manager.

<br/>

```
$ sudo apt-update

Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
Get:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:3 http://archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Hit:5 http://ppa.launchpad.net/ondrej/php/ubuntu focal InRelease
Fetched 336 kB in 25s (13.6 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
```

Now the PHP has been installed successfully

To check the Version of PHP

```
$ php -v
PHP 7.4.30 (cli) (built: Aug  1 2022 15:06:20) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
    with Zend OPcache v7.4.30, Copyright (c), by Zend Technologies
```