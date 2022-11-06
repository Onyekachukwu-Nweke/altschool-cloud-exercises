#!/usr/bin/env bash

#Be a root user when running this script

sudo apt update && sudo apt upgrade

# install all required dependencies
apt-get install gnupg2 -y

#installing all the dependencies, add the PostgreSQL repository and GPG key
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Update the remote machine
apt-get update -y

# Install postgres 14
apt-get install postgresql-14 postgresql-client-14 postgresql-server-dev-14 libpq-dev -y

# Start Postgresql and enable on the host machine
systemctl start postgresql
systemctl enable postgresql
