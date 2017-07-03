#!/usr/bin/env bash

bundle check || bundle install

pm2 start config/containers/test.json

# service apache2 start
source /etc/apache2/envvars
apache2 -D FOREGROUND

