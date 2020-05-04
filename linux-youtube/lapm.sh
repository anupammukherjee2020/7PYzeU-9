#!/bin/bash

##LAMP install with phpmyadmin

echo "welcome to edifying "

sleep 5

##update system 

apt update

##install apache2 for web server -y

sudo apt install apache2

##install mysql 
echo "NOTE :mysql installer asking for root password"
sleep 5

apt install mysql-server -y 

#install php 

sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql -y

##install phpmyadmin

echo "NOTE :phpmyadmin installer asking for mysql root password"
sleep 5
sudo apt-get install phpmyadmin -y
sudo apt-get install  php-mbstring php-gettex -y

echo "please check your web server and phpmyadmin"
sleep 4
echo "Thank you"

