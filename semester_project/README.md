![laravel-logo](/semester_project/img/laravel-logo.svg)
### Procedure

To access website
```php
www.onyekachukwuejiofornweke.me
```

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

I created a new root password using the mysql ansible module and also a db_config.yaml file that contains some variables
```
- include_vars: var/db_config.yaml
    - name: Creating remote Root user
      mysql_user:
        login_user: root
        login_password: "{{ db_pass }}"
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
        login_password: "{{ db_pass }}"
        name: "{{ db_name }}"
        state: present
```

### 6. Install Laravel 8 Using Composer 

Before I started this part of the exam, I setted some variables in place eg:
```
vars:
    repo_url: "https://github.com/f1amy/laravel-realworld-example-app.git"
    working_directory: "/var/www/html"
    new_folder: "laravel"
```

I cloned the repo to the folder that will house laravel application
```
- name: Pull changes from GitHub
      ignore_errors: true
      git:
        repo: "{{ repo_url }}"
        dest: "{{ working_directory }}/{{ new_folder }}"
        clone: false
```

I changed the folder ownership and modified some permissions using Ansible file module
```
- name: Change folder ownership and permissions
      file:
        path: "{{ working_directory }}/{{ new_folder }}"
        state: directory
        recurse: yes
        owner: www-data
        group: www-data
        mode: "0775"
```

### 7. Create a copy of your `.env` file

`.env` files are not generally committed to source control for security reasons.
So I wrote a Jinja template it can be seen in the files folder

```
- name: Configure .env file
      template:
        src: files/.env.j2
        dest: "{{ working_directory }}/{{ new_folder }}/.env.example"

    - name: Rename .env file
      shell: mv "{{ working_directory }}/{{ new_folder }}/.env.example" "{{ working_directory }}/{{ new_folder }}/.env"
```

> This will  rename the `.env.example` file in your project and name the copy simply `.env`

`Note`: I Configure  `.env.j2` file just as it is in the output below, I only made changes to the `DB_DATABASE` and `DB_PASSWORD` lines

```php
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=laraveldb
DB_USERNAME="{{ db_user }}"
DB_PASSWORD="{{ db_pass }}"
```

### 8. Install Composer

Composer is a dependency manager for PHP used for managing dependencies and libraries required for PHP applications. To install `composer` using Ansible run the following command: 

```
- name: Install Composer
      shell: curl -sS https://getcomposer.org/installer | php

- name: Move Composer
    shell: mv composer.phar /usr/local/bin/composer

- name: Make the composer file executable
    shell: chmod +x /usr/local/bin/composer
```

Next, move the downloaded binary to the system path and make it executable by everyone
```
- name: Move Composer
    shell: mv composer.phar /usr/local/bin/composer

- name: Make the composer file executable
    shell: chmod +x /usr/local/bin/composer
```


### 9. Install Composer Dependencies

This is what actually installs Laravel itself, among other necessary packages to get started. When we run composer, it checks the `composer.json` file which is submitted to the github repo and lists all of the composer (PHP) packages that your repo requires. Because these packages are constantly changing, the source code is generally not submitted to github, but instead we let composer handle these updates. So to install all this source code we run composer with the following command.

```
- name: Install dependencies with composer
      ignore_errors: true
      become: true
      become_user: root
      composer:
        command: install
        working_dir: "{{ working_directory }}/{{ new_folder }}"
        state: present
```

Generate the artisan key with the following command 
```
- name: Generate application key
      become: true
      command: php artisan key:generate
      args:
        chdir: "{{ working_directory }}/{{ new_folder }}"
```

To migrate Database + Seeding
```
- name: Configure Cache configuration
      become: true
      command: php artisan migrate:fresh
      args:
        chdir: "{{ working_directory }}/{{ new_folder }}"

- name: Run Migrations + Seeding
    become: true
    command: php artisan migrate --seed
    args:
    chdir: "{{ working_directory }}/{{ new_folder }}"
```

### 10. Configure Apache to Host Laravel 8

I created an Apache virtual host configuration file using a template file to host my Laravel application.
```php
- include_vars: var/apache_config.yaml
- name: Set up Apache virtual Host
    template:
    src: files/onyekachukwuejiofornweke.conf.j2
    dest: /etc/apache2/sites-available/{{ http_conf }}
```

In the template file that can be found in files folder, I added the following lines
```
<VirtualHost *:80>
    ServerAdmin admin@{{ httwqp_host }}
    ServerName {{ http_host }}
    ServerAlias www.{{ http_host }}
    DocumentRoot /var/www/html/laravel/public
    
    <Directory /var/www/html/laravel/public>
        Options Indexes MultiViews FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

I disabled the default apache site and then enable the Apache rewrite module and activate the Laravel virtual host with the following command using ansible: 

```
- include_vars: var/apache_config.yaml
- name: Enable Laravel application
    shell: /usr/sbin/a2ensite {{ http_conf }}
    notify: Reload Apache

- name: Disable default Apache site
    shell: /usr/sbin/a2dissite 000-default.conf
    when: disable_default
    notify: Reload Apache

- name: Enable Laravel application
    shell: /usr/sbin/a2enmod rewrite
    notify: Reload Apache
```

I pointed virtual domain to my IP address by editing the `/etc/hosts` file and adding your IP address and your desired `virtual domain name` which in my case is `onyekachukwuejiofornweke.me`.

```
- name: Put our IP address to point to our domain
  shell: echo "34.123.55.184    onyekachukwuejiofornweke.me" >> /etc/hosts
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
I did this particular task manually by ssh into the Virtual Machine

```
cd /var/www/html/laravel/routes
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

# Install SSL 
To install SSL certificate I used Let's encrypt using certbot

```
- name: Install Certibot
  ignore_errors: true
  package:
    name: python3-certbot-apache
    state: present

- name: Install SSL certificate using Let's Encrypt
    ignore_errors: true
    shell: certbot --apache -d onyekachukwuejiofornweke.me -d www.onyekachukwuejiofornweke.me -m nwekeejioforscheller@gmail.com --agree-tos
```

# To get all the API endpoints
I ran this task on ansible
```
vars:
    working_directory: "/var/www/html"
    new_folder: "laravel"
  tasks:
    - name: Get all API endpoints
      command: php artisan route:list
      args:
        chdir: "{{ working_directory }}/{{ new_folder }}"
      register: command_output

    - debug:
        var: command_output.stdout_lines
```

and I got this
```
GET|HEAD  / .............................................................................................................................................
  POST      _ignition/execute-solution ...................................... ignition.executeSolution › Spatie\LaravelIgnition › ExecuteSolutionController
  GET|HEAD  _ignition/health-check .................................................. ignition.healthCheck › Spatie\LaravelIgnition › HealthCheckController
  POST      _ignition/update-config ............................................... ignition.updateConfig › Spatie\LaravelIgnition › UpdateConfigController
  POST      api/articles ...................................................................... api.articles.create › Api\Articles\ArticleController@create
  GET|HEAD  api/articles .......................................................................... api.articles.list › Api\Articles\ArticleController@list
  GET|HEAD  api/articles/feed ..................................................................... api.articles.feed › Api\Articles\ArticleController@feed
  PUT       api/articles/{slug} ............................................................... api.articles.update › Api\Articles\ArticleController@update
  DELETE    api/articles/{slug} ............................................................... api.articles.delete › Api\Articles\ArticleController@delete
  GET|HEAD  api/articles/{slug} .................................................................... api.articles.get › Api\Articles\ArticleController@show
  POST      api/articles/{slug}/comments ............................................ api.articles.comments.create › Api\Articles\CommentsController@create
  GET|HEAD  api/articles/{slug}/comments ................................................. api.articles.comments.get › Api\Articles\CommentsController@list
  DELETE    api/articles/{slug}/comments/{id} ....................................... api.articles.comments.delete › Api\Articles\CommentsController@delete
  POST      api/articles/{slug}/favorite ................................................ api.articles.favorites.add › Api\Articles\FavoritesController@add
  DELETE    api/articles/{slug}/favorite .......................................... api.articles.favorites.remove › Api\Articles\FavoritesController@remove
  GET|HEAD  api/documentation ............................................................. l5-swagger.default.api › L5Swagger\Http › SwaggerController@api
  GET|HEAD  api/oauth2-callback .................................... l5-swagger.default.oauth2_callback › L5Swagger\Http › SwaggerController@oauth2Callback
  GET|HEAD  api/profiles/{username} ......................................................................... api.profiles.get › Api\ProfileController@show
  POST      api/profiles/{username}/follow ............................................................. api.profiles.follow › Api\ProfileController@follow
  DELETE    api/profiles/{username}/follow ......................................................... api.profiles.unfollow › Api\ProfileController@unfollow
  GET|HEAD  api/tags .............................................................................................. api.tags.list › Api\TagsController@list
  GET|HEAD  api/user .......................................................................................... api.users.current › Api\UserController@show
  PUT       api/user ......................................................................................... api.users.update › Api\UserController@update
  POST      api/users .................................................................................... api.users.register › Api\AuthController@register
  POST      api/users/login .................................................................................... api.users.login › Api\AuthController@login
  GET|HEAD  docs/asset/{asset} ................................................... l5-swagger.default.asset › L5Swagger\Http › SwaggerAssetController@index
  GET|HEAD  docs/{jsonFile?} ............................................................ l5-swagger.default.docs › L5Swagger\Http › SwaggerController@docs
  GET|HEAD  sanctum/csrf-cookie ............................................................................... Laravel\Sanctum › CsrfCookieController@show
```

I tested each endpoint using Postman

Now you should be able to view the default laravel page
### Rendered Page
![rendered-page-laravel](/semester_project/img/web.png)


## Configure Postgres

I wrote a playbook for configuring postgres
```
- name: To Configure PostgresSQL
  hosts: all
  ignore_errors:true
  become: true
  tasks:
    - name: Configure PostgresSQL 
      script: psql_script.sh
```
