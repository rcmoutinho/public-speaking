#!/bin/bash

# ----------------------------
# CONFIG
# ----------------------------
echo "[PROVISIONING CONFIGURATION] ***************************************************"

apt-get update
apt-get install postgresql postgresql-contrib -y

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

echo "[PROVISIONING WORLD-1.0] *************************************************"

psql -U postgres -c "CREATE DATABASE world WITH OWNER postgres;"
psql -U postgres -c "REVOKE ALL ON DATABASE world from PUBLIC;"

psql -U postgres -d world -f /vagrant/database/world-1.0.sql
