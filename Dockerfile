FROM ruby:2.1.5

MAINTAINER joeyap "joey@cybranding.com"

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# # Install essential Linux packages
RUN apt-get update && apt-get install -y build-essential git cron htop nano curl wget

# Define where our application will live inside the image
ENV RAILS_ROOT /opt/testapp

# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT


# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler

# Use an external directory for the bundle cache, so that it won't have to reinstall everything every time
ENV BUNDLE_PATH=/bundle

# Copy the Rails application into place
COPY . .

# BASH useful aliases
RUN echo 'alias ll="ls -l"' >> ~/.bashrc
RUN echo 'alias rc="bundle exec rails c testserver"' >> ~/.bashrc

# Install Apache
RUN apt-get install -y apache2

# Install Passenger
# Install our PGP key and add HTTPS support for APT
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN apt-get install -y apt-transport-https ca-certificates

# Add our APT repository
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
RUN apt-get update

RUN apt-get install -y libapache2-mod-passenger \
  && a2enmod passenger

# configure apache
COPY config/containers/testapp.conf /etc/apache2/sites-available/testapp.conf

RUN chown -R www-data:www-data $RAILS_ROOT && chmod -R 777 $RAILS_ROOT

RUN a2dissite 000-default \
  && a2ensite testapp \
  && service apache2 restart

EXPOSE 80

CMD ["config/containers/start.sh"]


