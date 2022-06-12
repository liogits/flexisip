# Flexisip Docker-Compose

## Structure
1. Inside "dockerfiles" are all Files, needed to compose up a Container Stack serving Flexisip with MariaDB, Redis, phpMyAdmin and Flexisip Account Manager. Web is served bei NGINX.

2. This system is build on Ubuntu 20.04. Maybe needs adjustment on other OS. Especially with the shared folders and different line endings between Unix and Windows

## Set Up

#### Docker
 - Docker Engine and Docker Compose have to be installed and working.
 - Prepare intern network:

        docker network create --gateway 172.16.0.1 --subnet 172.16.0.0/24 flexisip-proxy

 - Prepare volumes for phpMyAdmin, MariaDB, letsencrypt and FlexiAPI

        docker volume create phpmyadmin

        docker volume create letsencrypt

        docker volume create mariadbdata

        docker volume create flexiapi

#### Redis
 - Generate ssl-Hash via

        openssl rand 60 | openssl base64 -A

 - Copy ssl-Hash into `dockerfiles/redis/redis.conf` at config `requirepass`
 - The ssl-hash is later needed at flexisip.conf

#### MariaDB
 - Copy `dockerfiles/.env.example` into `dockerfiles/.env` and edit MariaDB enviroment variables into your own

#### Flexisip
 - Copy `volumes/flexisip/config/example.flexisip.conf` into flexisip.conf
 - Insert MariaDB Enviroment Variables into

        soci-connection-string

 - Insert openssl-hash from Redis at

        redis-auth-password

 - Setup the transports and auth-domains to your SIP-Domain. Reference https://wiki.linphone.org/xwiki/wiki/public/view/Flexisip/A.%20Configuration%20Reference%20Guide/master/

#### NGINX
 - The NGINX-Container uses FastCGI to host phpMyAdmin and the FlexiAPI
 - phpMyAdmin brings all the needed files inside its container.
 - phpMyAdmin is served at yourdomain.name/phpmyadmin

#### FlexiAPI
 - The FlexiAPI is used to first migrate and then edit MariaDB, storing all the SIP-Users.
 - The API is based on the Laravel-Framework and has to be configured after installation.
 - All the API files are loaded into the `flexiapi`-volume at composing. That is why the config has to be done inside the running container.
 - Execute a Shell inside the "php-fpm-laravel" container via Docker Desktop or

        sudo docker exec -it php-fpm-laravel /bin/sh

 - WorkDir should be /var/www/html if not

        cd /var/www/html

 - Inside this directory:

        chown -R www-data:www-data ./

        chmod -R 755 ./

 - To install the API:

        composer install --no-dev

        cp example.env .env

        php artisan key:generate   # This will generate the APP_KEY

 - Edit all env-variables in .env with

        nano .env

 - You will have to set:
     - `APP_URL, APP_SIP_DOMAIN, ACCOUNT_PROXY_REGISTRAR_ADRESS`
     - All the DB_-variables, `DB_HOST` should be `flexisip-mariadb`
     - All Mail_-variables
     - If you want to use Phone number registration, all the OVH_-data
     - `NOCAPTCHA_SECRET, NOCAPTCHA_SITEKEY`

 - You will need a Mail-Server and reCAPTCHA
    
     - Insert the login data from your SMTP-server. It is used for sending the verification mails to user registring via FlexiAPI
     - It is an v2 reCAPTHA from Google. Config at `https://www.google.com/recaptcha/admin/`

 - To migrate the Database:

        php artisan migrate

#### Network

 - When your behind a NAT and/or Firewall, you must open all the needed ports for serving globally.
 - NGINX uses `80/TCP, 443/TCP`
 - Flexisip uses `5060, 5061, 3478` both UDP and TCP. Depending on what Protcols you want to use for signaling.

### Current Tasks

 [ ] Fixing .css not loading with FlexiAPI
 [ ] using letsencrypt for TLS

#### Disclaimer

This Set-Up is based upon the Article at https://ficus.myvnc.com/en/Blog/Flexisip-SIP-Server-on-Ubuntu-2004-Docker-Compose~b1214 (touched 31.05.2022).
It is fitted to work for me. I had problems, running the flexisip container on windows machines because of there different line endings. The Entrypoints could not be loaded, even if the line endings were in "LF" format. I did not figure out why.




