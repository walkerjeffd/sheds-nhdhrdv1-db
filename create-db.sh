#!/bin/bash
# Create NHDHRDV1 database
# usage: ./create-db.sh <dbname>

set -eu
set -o pipefail

DB=$1

echo Creating database "$DB"...
createdb "$DB"

echo Activating PostGIS...
psql -d "$DB" -c "CREATE EXTENSION postgis;"

