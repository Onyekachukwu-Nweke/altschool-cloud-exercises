#!/usr/bin/env bash

sudo apt update -y && sudo apt upgrade -y

#Prerequisites
#sudo apt install -y wget git apache2 curl

apt install ca-certificates apt-transport-https software-properties-common -y

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

#Adding ppa:ondrej repo
add-apt-repository -y ppa:ondrej/php

#Update remote server
apt update -y

#Installation of php8.1
apt install php8.1 -y

apt install php8.1-fpm

apt install php8.1-xml

apt install php8.1-zip

apt install libapache2-mod-php

#Install a few dependencies
apt install php8.1-{gd,zip,pgsql,oauth,yaml,mbstring,memcache,opcache} unzip -y

apt upgrade -y

# #Install composer
# curl -sS https://getcomposer.org/installer | php

# #move composer.phar file and make it executable
# mv composer.phar /usr/local/bin/composer
# chmod +x /usr/local/bin/composer
