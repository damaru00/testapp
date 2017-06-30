#!/usr/bin/env bash

bundle check || bundle install

# Start apache
/usr/sbin/apache2 -D FOREGROUND