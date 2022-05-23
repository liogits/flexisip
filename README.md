# Flexisip Docker-Compose

## Structure
1. Inside "dockerfiles" are all Files, needed to compose up a Container Stack serving Flexisip with MariaDB, Redis, phpMyAdmin and Flexisip Account Manager. WWW is served bei nginx.

2. In the same folder as dockerfile will be generated an folder called "volumes" giving access to all relevant logs and configs. Essential configs will be served from "dockerfiles" while composing and could be prepared beforehand or edited after. Every time these files changes, composing will COPY the edited file inside the volume. So all confs could be edited inside "dockerfiles"

## Set Up

#### Docker
1. Docker Engine and Docker Compose have to be installed and working.
2. Prepare intern network:
    docker network create --gateway 172.10.0.1 --subnet 172.10.0.1/24 flexisip-proxy
3. Prepare volumes for phpMyAdmin and letsencrypt
    docker volume create phpmyadmin
    docker volume create letsencrypt

#### Redis
4. Generate ssl-Hash via
    openssl rand 60 | openssl base64 -A
5. Copy ssh-Hash into 'dockerfiles/redis/redis.conf' at config 'requirepass'

#### MariaDB
6. Copy .env.example into .env an edit MariaDB Enviroment Variables into your own
