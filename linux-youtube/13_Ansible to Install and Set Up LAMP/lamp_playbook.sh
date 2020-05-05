link ::: https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-lamp-on-ubuntu-18-04


How to Use Ansible to Install and Set Up LAMP on Ubuntu 18.04


Prerequisites
What Does this Playbook Do?
How to Use this Playbook
The Playbook Contents
Conclusion
We are kicking off an initiative to help small businesses through a series of virtual presentations, panels, and live-coding sessions ❯
Products
Pricing
Docs
Sign in
Tutorials
Questions
Get Involved



 Search DigitalOcean /
Sign Up
Language: EN 
Related
How to Install and Use Composer on Ubuntu 20.04
TutorialTutorial
How To Install Linux, Nginx, MySQL, PHP (LEMP stack) on Ubuntu 20.04
TutorialTutorial
How to Use Ansible to Install and Set Up LAMP on Ubuntu 18.04
How to Use Ansible to Install and Set Up LAMP on Ubuntu 18.04
PostedDecember 17, 2019 18.1kviews APACHEPHPLAMP STACKANSIBLEAUTOMATED SETUPS

By Erika Heidi

Become an author

Not using Automated Ansible? Choose a different version:
CentOS 8
CentOS 7
Debian 9
Debian 8
Debian 10
Ubuntu 20.04
Ubuntu 18.04
Ubuntu 16.04
Ubuntu 14.04
Automated Docker
request
Automated Bash
request
View All
Introduction
Server automation now plays an essential role in systems administration, due to the disposable nature of modern application environments. Configuration management tools such as Ansible are typically used to streamline the process of automating server setup by establishing standard procedures for new servers while also reducing human error associated with manual setups.

Ansible offers a simple architecture that doesn’t require special software to be installed on nodes. It also provides a robust set of features and built-in modules which facilitate writing automation scripts.

This guide explains how to use Ansible to automate the steps contained in our guide on How To Install Linux, Apache, MySQL and PHP (LAMP) on Ubuntu 18.04. A “LAMP” stack is a group of open-source software that is typically installed together to enable a server to host dynamic websites and web apps. This term is actually an acronym which represents the Linux operating system, with the Apache web server. The site data is stored in a MySQL database, and dynamic content is processed by PHP.

Prerequisites
In order to execute the automated setup provided by the playbook we’re discussing in this guide, you’ll need:

One Ansible control node: an Ubuntu 18.04 machine with Ansible installed and configured to connect to your Ansible hosts using SSH keys. Make sure the control node has a regular user with sudo permissions and a firewall enabled, as explained in our Initial Server Setup guide. To set up Ansible, please follow our guide on How to Install and Configure Ansible on Ubuntu 18.04.
One or more Ansible Hosts: one or more remote Ubuntu 18.04 servers previously set up following the guide on How to Use Ansible to Automate Initial Server Setup on Ubuntu 18.04.
Before proceeding, you first need to make sure your Ansible control node is able to connect and execute commands on your Ansible host(s). For a connection test, please check step 3 of How to Install and Configure Ansible on Ubuntu 18.04.

What Does this Playbook Do?
This Ansible playbook provides an alternative to manually running through the procedure outlined in our guide on How To Install Linux, Apache, MySQL and PHP (LAMP) on Ubuntu 18.04.

Running this playbook will perform the following actions on your Ansible hosts:

Install aptitude, which is preferred by Ansible as an alternative to the apt package manager.
Install the required LAMP packages.
Create a new Apache VirtualHost and set up a dedicated document root for that.
Enable the new VirtualHost.
Disable the default Apache website, when the disable_default variable is set to true.
Set the password for the MySQL root user.
Remove anonymous MySQL accounts and the test database.
Set up UFW to allow HTTP traffic on the configured port (80 by default).
Set up a PHP test script using the provided template.
Once the playbook has finished running, you will have a web PHP environment running on top of Apache, based on the options you defined within your configuration variables.

How to Use this Playbook
The first thing we need to do is obtain the LAMP playbook and its dependencies from the do-community/ansible-playbooks repository. We need to clone this repository to a local folder inside the Ansible Control Node.

In case you have cloned this repository before while following a different guide, access your existing ansible-playbooks copy and run a git pull command to make sure you have updated contents:

cd ~/ansible-playbooks
git pull
If this is your first time using the do-community/ansible-playbooks repository, you should start by cloning the repository to your home folder with:

cd ~
git clone https://github.com/do-community/ansible-playbooks.git
cd ansible-playbooks
The files we’re interested in are located inside the lamp_ubuntu1804 folder, which has the following structure:

lamp_ubuntu1804
├── files
│   ├── apache.conf.j2
│   └── info.php.j2
├── vars
│   └── default.yml
├── playbook.yml
└── readme.md
Here is what each of these files are:

files/info.php.j2: Template file for setting up a PHP test page on the web server’s root
files/apache.conf.j2: Template file for setting up the Apache VirtualHost.
vars/default.yml: Variable file for customizing playbook settings.
playbook.yml: The playbook file, containing the tasks to be executed on the remote server(s).
readme.md: A text file containing information about this playbook.
We’ll edit the playbook’s variable file to customize the configurations of both MySQL and Apache. Access the lamp_ubuntu1804 directory and open the vars/default.yml file using your command line editor of choice:

cd lamp_ubuntu1804
nano vars/default.yml
This file contains a few variables that require your attention:

vars/default.yml
---
mysql_root_password: "mysql_root_password"
app_user: "sammy"
http_host: "your_domain"
http_conf: "your_domain.conf"
http_port: "80"
disable_default: true
The following list contains a brief explanation of each of these variables and how you might want to change them:

mysql_root_password: The desired password for the root MySQL account.
app_user: A remote non-root user on the Ansible host that will be set as the owner of the application files.
http_host: Your domain name.
http_conf: The name of the configuration file that will be created within Apache.
http_port: HTTP port for this virtual host, where 80 is the default.
disable_default: Whether or not to disable the default website that comes with Apache.
Once you’re done updating the variables inside vars/default.yml, save and close this file. If you used nano, do so by pressing CTRL + X, Y, then ENTER.

You’re now ready to run this playbook on one or more servers. Most playbooks are configured to be executed on every server in your inventory, by default. We can use the -l flag to make sure that only a subset of servers, or a single server, is affected by the playbook. We can also use the -u flag to specify which user on the remote server we’re using to connect and execute the playbook commands on the remote hosts.

To execute the playbook only on server1, connecting as sammy, you can use the following command:

ansible-playbook playbook.yml -l server1 -u sammy
You will get output similar to this:

Output

PLAY [all] *********************************************************************************************************
TASK [Gathering Facts] *********************************************************************************************************ok: [server1]

TASK [Install prerequisites] *********************************************************************************************************ok: [server1] => (item=aptitude)

...

TASK [UFW - Allow HTTP on port 80] *********************************************************************************************************
changed: [server1]

TASK [Sets Up PHP Info Page] *********************************************************************************************************
changed: [server1]

RUNNING HANDLER [Reload Apache] *********************************************************************************************************
changed: [server1]

RUNNING HANDLER [Restart Apache] *********************************************************************************************************
changed: [server1]

PLAY RECAP *********************************************************************************************************
server1             : ok=15   changed=11   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


Note: For more information on how to run Ansible playbooks, check our Ansible Cheat Sheet Guide.

When the playbook is finished running, go to your web browser and access the host or IP address of the server, as configured in the playbook variables, followed by /info.php:

http://server_host_or_IP/info.php
You will see a page like this:

phpinfo page

Because this page contains sensitive information about your PHP environment, it is recommended that you remove it from the server by running an rm -f /var/www/info.php command once you have finished setting it up.

The Playbook Contents
You can find the LAMP server setup featured in this tutorial in the lamp_ubuntu1804 folder inside the DigitalOcean Community Playbooks repository. To copy or download the script contents directly, click the Raw button towards the top of each script.

The full contents of the playbook as well as its associated files are also included here for your convenience.

vars/default.yml
The default.yml variable file contains values that will be used within the playbook tasks, such as the password for the MySQL root account and the domain name to configure within Apache.

vars/default.yml
---
mysql_root_password: "mysql_root_password"
app_user: "sammy"
http_host: "your_domain"
http_conf: "your_domain.conf"
http_port: "80"
disable_default: true
files/apache.conf.j2
The apache.conf.j2 file is a Jinja 2 template file that configures a new Apache VirtualHost. The variables used within this template are defined in the vars/default.yml variable file.

files/apache.conf.j2
<VirtualHost *:{{ http_port }}>
   ServerAdmin webmaster@localhost
   ServerName {{ http_host }}
   ServerAlias www.{{ http_host }}
   DocumentRoot /var/www/{{ http_host }}
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined

   <Directory /var/www/{{ http_host }}>
         Options -Indexes
   </Directory>

   <IfModule mod_dir.c>
       DirectoryIndex index.php index.html index.cgi index.pl  index.xhtml index.htm
   </IfModule>

</VirtualHost>
files/info.php.j2
The info.php.j2 file is another Jinja template, used to set up a test PHP script in the document root of the newly configured LAMP server.

files/info.php.j2
<?php
phpinfo();

playbook.yml
The playbook.yml file is where all tasks from this setup are defined. It starts by defining the group of servers that should be the target of this setup (all), after which it uses become: true to define that tasks should be executed with privilege escalation (sudo) by default. Then, it includes the vars/default.yml variable file to load configuration options.

playbook.yml

---
- hosts: all
  become: true
  vars_files:
    - vars/default.yml

  tasks:
    - name: Install prerequisites
      apt: name={{ item }} update_cache=yes state=latest force_apt_get=yes
      loop: [ 'aptitude' ]

  #Apache Configuration
    - name: Install LAMP Packages
      apt: name={{ item }} update_cache=yes state=latest
      loop: [ 'apache2', 'mysql-server', 'python3-pymysql', 'php', 'php-mysql', 'libapache2-mod-php' ]

    - name: Create document root
      file:
        path: "/var/www/{{ http_host }}"
        state: directory
        owner: "{{ app_user }}"
        mode: '0755'

    - name: Set up Apache virtualhost
      template:
        src: "files/apache.conf.j2"
        dest: "/etc/apache2/sites-available/{{ http_conf }}"
      notify: Reload Apache

    - name: Enable new site
      shell: /usr/sbin/a2ensite {{ http_conf }}
      notify: Reload Apache

    - name: Disable default Apache site
      shell: /usr/sbin/a2dissite 000-default.conf
      when: disable_default
      notify: Reload Apache

  # MySQL Configuration
    - name: Sets the root password
      mysql_user:
        name: root
        password: "{{ mysql_root_password }}"
        login_unix_socket: /var/run/mysqld/mysqld.sock

    - name: Removes all anonymous user accounts
      mysql_user:
        name: ''
        host_all: yes
        state: absent
        login_user: root
        login_password: "{{ mysql_root_password }}"

    - name: Removes the MySQL test database
      mysql_db:
        name: test
        state: absent
        login_user: root
        login_password: "{{ mysql_root_password }}"

  # UFW Configuration
    - name: "UFW - Allow HTTP on port {{ http_port }}"
      ufw:
        rule: allow
        port: "{{ http_port }}"
        proto: tcp

  # PHP Info Page
    - name: Sets Up PHP Info Page
      template:
        src: "files/info.php.j2"
        dest: "/var/www/{{ http_host }}/info.php"

  handlers:
    - name: Reload Apache
      service:
        name: apache2
        state: reloaded

    - name: Restart Apache
      service:
        name: apache2
        state: restarted
Feel free to modify these files to best suit your individual needs within your own workflow.

Conclusion
In this guide, we used Ansible to automate the process of installing and setting up a LAMP environment on a remote server. Because each individual typically has different needs when working with MySQL databases and users, we encourage you to check out the official Ansible documentation for more information and use cases of the mysql_user Ansible module.

If you’d like to include other tasks in this playbook to further customize your server setup, please refer to our introductory Ansible guide Configuration Management 101: Writing Ansible Playbooks.



