![laravel-logo](/mini_project/img/laravel-logo.svg)
### Procedure

###### Install LAMP Stack on Debian 11
- Cloud Provider (Google Cloud)
- Virtual machine running Debian 11
- Git, Apache, Wget, Curl
- Php 8.1 and it's dependencies
- Mysql
- Composer

### Prerequisites to Install LAMP
- Knowledge of Configuration Manager (Ansible)
- Jinja Templating Engine
- Root access to your server or a sudo user
- Domain pointed to your server's IP


### 2. Install the following packages (Apache2, Wget, Git, Curl)

I wrote a task to install our web server Apache and the following packages on the server using the Ansible package module

```
- name: install apache2, curl, wget and git
      package:
        name:
          - apache2
          - git
          - curl
          - wget
        state: latest
```

### 3. Install PHP

###### Add the SURY PPA for PHP 8.1

I also wrote some tasks to install some software prerequisites and install the official security keys of PHP
into the remote host
```
- name: Install some prerequisites
    package:
    name:
        - ca-certificates
        - apt-transport-https
        - software-properties-common
    state: latest
    update_cache: yes

- name: Download Keys
      shell: wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

- name: Echo Keys to php
    shell: echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
```

I added the ppa:ondrej/php repo using the Ansible apt_repository module

```
- name: Add ppa:ondrej repo
      ignore_errors: true
      apt_repository:
        repo: ppa:ondrej/php
        state: present
        update_cache: yes
```

Update the packages and install PHP 8.1

I already updated cache from the last task, so I installed php8.1 and its dependencies on the remote host
```
- name: Install PHP8.1 and its core dependencies
      package:
        name:
          - php8.1
          - php8.1-fpm
          - libapache2-mod-php
        state: present

    - name: Install other php dependencies
      package:
        name:
          - php8.1-zip
          - php8.1-mysql
          - php8.1-xml
          - php8.1-curl
          - php8.1-mbstring
          - php8.1-memcache
          - php8.1-opcache
          - unzip
          - php8.1-oauth
          - php8.1-gd
          - php8.1-yaml
        state: present
        update_cache: yes
```


### 4. Install mySQL

The next step is to install our database server (mySQL 8.0) on my virtual machine (Debian 11)

I wrote a play that will install and configure mysql server

Task: To Install mysql
```
- name: Install MySql and dependencies
      package:
        name: "{{item}}"
        state: present
        update_cache: yes
      loop:
        - default-mysql-server
        - default-mysql-client
        - python3-mysqldb
        - default-libmysqlclient-dev

    - name: Start and Enable MySql service
      service:
        name: mysql
        state: started
        enabled: yes
```

I also enabled remote login on the virtual machine

```
 - name: Enable remote login
      lineinfile:
        path: /etc/mysql/mariadb.conf.d/50-server.cnf
        regexp: "^bind-address"
        line: "bind-address = 0.0.0.0"
        backup: yes
      notify:
        - Restart mysql
```

I created a new root password using the mysql ansible module
```
- include_vars: var/db_config.yaml
    - name: Creating remote Root user
      mysql_user:
        login_user: root
        login_password: "sheyudeywhineme"
        name: "{{ db_user }}"
        host_all: yes
        password: "{{ db_pass }}"
        priv: "*.*:ALL"
        host: "%"
        state: present
```

### 5. Create a Database
Login to mySQL and created a database using the Ansible, I used Jinja templating for better abstraction:
```
- include_vars: var/db_config.yaml
    - name: Creating MySql database
      mysql_db:
        login_user: root
        login_password: "sheyudeywhineme"
        name: "{{ db_name }}"
        state: present
```

### 6. Install Laravel 8 Using Composer 

Switch to apache's document root
```php
cd /var/www/
```

Create a directory to house my laravel project
```php
mkdir altschool
```

I cloned the repo to the folder housing the laravel application
```php
cd altschool
git clone https://github.com/f1amy/laravel-realworld-example-app.git
```

I renamed the cloned git repo to `laravel`
```php
mv laravel-realworld-example-app laravel
```

Switch to your projects directory
```php
cd laravel 
```

### 7. Create a copy of your `.env` file

`.env` files are not generally committed to source control for security reasons.

```php
cp .env.example .env
```

> This will create a copy of the `.env.example` file in your project and name the copy simply `.env`

Next, edit the `.env` file and define your database:
```
nano .env
```

`Note`: I Configure your `.env` file just as it is in the output below, only make changes to the `DB_DATABASE` and `DB_PASSWORD` lines

```php
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=newlaravel
DB_USERNAME=root
DB_PASSWORD=yourNewPass
```
After updating your .env file, press CTRL+X, Y, and Enter key to save the .env file.

Next, change the permission and ownership of `laravel` directory
```php
chown -R www-data:www-data /var/www/html/laravel
chmod -R 775 /var/www/html/laravel
chmod -R 775 /var/www/html/laravel/storage
chmod -R 775 /var/www/html/laravel/bootstrap/cache
```

### 8. Install Composer

Composer is a dependency manager for PHP used for managing dependencies and libraries required for PHP applications. To install `composer` run the following command: 

```php
curl -sS https://getcomposer.org/installer | php
```

You should get the following output
```php
All settings correct for using Composer
Downloading...
Composer (version 2.4.3) successfully installed to: /root/composer.phar
Use it: php composer.phar 
```

Next, move the downloaded binary to the system path and make it executable by everyone
```php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
```

Next, verify the Composer version using the following command 
```php
composer --version
```

You should see the following output 
```php
Composer version 2.4.3 2022-10-14 17:11:08
```


### 9. Install Composer Dependencies

This is what actually installs Laravel itself, among other necessary packages to get started. When we run composer, it checks the `composer.json` file which is submitted to the github repo and lists all of the composer (PHP) packages that your repo requires. Because these packages are constantly changing, the source code is generally not submitted to github, but instead we let composer handle these updates. So to install all this source code we run composer with the following command.

```php
composer install
```

Generate the artisan key with the following command 
```php
php artisan key:generate
```

To migrate Database
```php
php artisan migrate
```

### 10. Configure Apache to Host Laravel 8

I created an Apache virtual host configuration file to host my Laravel application.
```php
nano /etc/apache2/sites-available/altschool.conf
```

Add the following lines
```php
<VirtualHost *:80>
    ServerAdmin admin@onyekachukwuejiofornweke.me
    ServerName onyekachukwuejiofornweke.me
    ServerAlias www.onyekachukwuejiofornweke.me
    DocumentRoot /var/www/html/laravel/public
    
    <Directory /var/www/html/laravel/public>
        Options Indexes MultiViews
        AllowOverride None
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

I saved and close the file and then enable the Apache rewrite module and activate the Laravel virtual host with the following command: 

```
a2enmod rewrite
a2ensite altschool.conf
```

Finally, reload the Apache service to apply the changes

```
systemctl restart apache2
```

I pointed virtual domain to my IP address by editing the `/etc/hosts` file and adding your IP address and your desired `virtual domain name` which in my case is `onyekachukwuejiofornweke.me`.
```
nano /etc/hosts
```

> Also edit you host machines `etc/hosts` file and flush your `DNS cache` afterwards. Check the internet on how to do this for your specific OS

This is a sample
```
root@ubuntu:/# nano /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
35.225.104.78      onyekachukwuejiofornweke.me
```


### Access Laravel
<!-- Now, open your web browser and access the Laravel site by visiting your `virtual domain name` or `IP`. You will be redirected to the Laravel default page. If you get a `404 | not found` error, make sure to do the following...
- move to your `routes` directory in your project directory which in my case is `/var/www/altschool/laravel/routes` -->
```
cd /var/www/altschool/laravel/routes
```
- look for a file name `web.php` and remove the comments on the block of code which starts with `Routes::` it should look something like the file below
```
<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

/*Route::get('/', function () {
    return view('welcome');
});*/
```

##### When you are done editing the file it should now look like what I have below

```
<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
```

Now you should be able to view the default laravel page
### Rendered Page
![rendered-page-laravel]()
