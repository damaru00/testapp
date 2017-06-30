#!/usr/bin/env bash

bundle check || bundle install

# Start apache
service apache2 start