#!/usr/bin/env bash

bundle check || bundle install

# Start apache
#service apache2 start
#source /etc/apache2/envvars
#apache2 -D FOREGROUND

pm2-docker start all