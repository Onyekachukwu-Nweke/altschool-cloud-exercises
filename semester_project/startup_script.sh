#!/usr/bin/env bash

sudo apt update -y && sudo apt upgrade -y

#Prerequisites
sudo apt install ca-certificates apt-transport-https software-properties-common -y

sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

#Adding ppa:ondrej repo
sudo add-apt-repository -y ppa:ondrej/php

#Update remote server
sudo apt update -y

#Installation of php8.1
sudo apt install php8.1 -y

sudo apt install php8.1-fpm

#Install a few dependencies
sudo apt install php8.1-{gd,zip,mysql,oauth,yaml,mbstring,memcache,opcache,xml} unzip -y

sudo apt upgrade -y

#Install composer
curl -sS https://getcomposer.org/installer | php

#move composer.phar file
sudo mv composer.phar /usr/local/bin/composer
