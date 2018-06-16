#!/bin/bash

apt-get update

# postgres
command -v psql &>/dev/null || {
  apt-get install postgresql postgresql-contrib -y
}

# cleanup
apt-get clean

# configuration to allow any connection (example/development purpose) - INSECURE
cp /vagrant/conf/pg_hba.conf /etc/postgresql/9.1/main/pg_hba.conf
chown postgres.postgres /etc/postgresql/9.1/main/pg_hba.conf

# restarting services
service postgresql restart

# checking services
service postgresql status
