#!/bin/bash
export PGPASSWORD=postgres
set -e

# Drop the local database, create a dump from the online database and restore it locally
echo "DROP DATABASE simracing;" | psql -h localhost -U postgres postgres
echo "CREATE DATABASE simracing
    WITH
    OWNER = simracing
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;" | psql -h localhost -U postgres postgres
ssh -i $HOME/.ssh/bauske.rsa -t david@bauske.org "pg_dump -U simracing simracing" | psql -h localhost -U postgres simracing

# Synchronize the uploaded files
rsync -a david@bauske.org:/var/www/simracing/backend/public/uploads/ /mnt/c/projects/simracing/backend/public/uploads
