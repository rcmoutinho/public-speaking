#!/bin/bash

# ----------------------------
# CONFIG
# ----------------------------
echo "[PROVISIONING CONFIGURATION] ***************************************************"

apt-get update

# check & install postgres
command -v psql &>/dev/null || {
  apt-get install postgresql postgresql-contrib -y
}

# cleanup
apt-get clean

# configuration to allow any connection (example/development purpose) - INSECURE
cp /vagrant/conf/pg_hba.conf /etc/postgresql/9.1/main/pg_hba.conf
chown postgres.postgres /etc/postgresql/9.1/main/pg_hba.conf

cp /vagrant/conf/postgresql.conf /etc/postgresql/9.1/main/postgresql.conf
chown postgres.postgres /etc/postgresql/9.1/main/postgresql.conf

# restarting & checking services
service postgresql restart
service postgresql status

# ----------------------------
# DATABASE
# ----------------------------
echo "[PROVISIONING DATABASE] **************************************************"

psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"
psql -U postgres -c "REVOKE ALL ON DATABASE postgres from PUBLIC;"

echo "[PROVISIONING PAGILA] ****************************************************"

# cleaning older databases
psql -U postgres -c "DROP DATABASE IF EXISTS pagila;"

# creating new ones
psql -U postgres -c "CREATE DATABASE pagila WITH OWNER postgres;"
psql -U postgres -c "REVOKE ALL ON DATABASE pagila from PUBLIC;"

# provisioning the database
psql -U postgres -d pagila -f /vagrant/database/pagila-schema.sql
psql -U postgres -d pagila -f /vagrant/database/pagila-data.sql
# psql -U postgres -d pagila -f /vagrant/database/pagila-insert-data.sql
