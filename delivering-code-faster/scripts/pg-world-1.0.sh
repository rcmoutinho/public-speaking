#!/bin/bash
set -e

DOCKER_SCRIPT_PATH=/var/app

DB_NAME=world
SQL_PATH=$DOCKER_SCRIPT_PATH/database/world-1.0.sql

# always using image's vars to execute commands
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  ALTER USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';
  REVOKE ALL ON DATABASE $POSTGRES_DB from PUBLIC;
  CREATE DATABASE $DB_NAME WITH OWNER $POSTGRES_USER;
  REVOKE ALL ON DATABASE $DB_NAME from PUBLIC;
EOSQL

# provisioning the database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DB_NAME" -f $SQL_PATH
