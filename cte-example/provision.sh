#!/bin/bash

# ----------------------------
# CONFIG
# ----------------------------
echo "[PROVISIONING CONFIGURATION] ***************************************************"

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

cp /vagrant/conf/postgresql.conf /etc/postgresql/9.1/main/postgresql.conf
chown postgres.postgres /etc/postgresql/9.1/main/postgresql.conf

# restarting services
service postgresql restart

# checking services
service postgresql status

# ----------------------------
# DATABASE
# ----------------------------
echo "[PROVISIONING DATABASE] **************************************************"

psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"
psql -U postgres -c "REVOKE ALL ON DATABASE postgres from PUBLIC;"

# cleaning older databases
psql -U postgres -c "DROP DATABASE IF EXISTS totvs_example;"

# creating new ones
psql -U postgres -c "CREATE DATABASE totvs_example WITH OWNER postgres;"
psql -U postgres -c "REVOKE ALL ON DATABASE totvs_example from PUBLIC;"

# provisioning use case database
psql -U postgres -d totvs_example -f /vagrant/database/totvs-example-schema.sql
psql -U postgres -d totvs_example -f /vagrant/database/totvs-example-data.sql
