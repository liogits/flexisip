# Flexisip Docker-Compose

## Structure
1. Inside "dockerfiles" are all Files, needed to compose up a Container Stack serving Flexisip with MariaDB, Redis, phpMyAdmin and Flexisip Account Manager. WWW is served bei nginx.

2. This system is build on Ubuntu 20.04. Maybe needs adjustment on other OS. Especially with the shared folders.

## Set Up

#### Docker
1. Docker Engine and Docker Compose have to be installed and working.
2. Prepare intern network:
    docker network create --gateway 172.16.0.1 --subnet 172.16.0.0/24 flexisip-proxy
3. Prepare volumes for phpMyAdmin, MariaDB and letsencrypt
    docker volume create phpmyadmin
    docker volume create letsencrypt
    docker volume create mariadbdata

#### Redis
4. Generate ssl-Hash via
    openssl rand 60 | openssl base64 -A
5. Copy ssh-Hash into 'dockerfiles/redis/redis.conf' at config 'requirepass'
6. Later needed at flexisip.conf

#### MariaDB
7. Copy dockerfiles/.env.example into dockerfiles/.env an edit MariaDB Enviroment Variables into your own

#### Flexisip
8. Copy volumes/flexisip/config/example.flexisip.conf into flexisip.conf
9. Insert MariaDB Enviroment Variables into
    soci-connection-string
10. Insert openssl-hash from Redis at
    redis-auth-password
11. Setup the transports and auth-domains to your SIP-Domain. Reference https://wiki.linphone.org/xwiki/wiki/public/view/Flexisip/A.%20Configuration%20Reference%20Guide/master/

#### NGinx
 - The Nginx-Container uses FastCGI to host phpMyAdmin and the FlexiAPI
 - phpMyAdmin brings all the needed files inside its container.
 - phpMyAdmin is served at yourdomain.name/phpmyadmin

#### FlexiAPI
 - The FlexiAPI is used to first migrate and then edit MariaDB, hosting all the SIP-Users.
 - The API is based on the Laravel-Framework and has to be configured after installation.
 - Execute a Shell inside the "php-fpm-laravel" container via Docker Desktop or
    sudo docker exec -it php-fpm-laravel /bin/sh
 - WorkDir should be /var/www/html if not
    cd /var/www/html
 - <ls> should



