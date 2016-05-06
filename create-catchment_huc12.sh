#!/bin/bash
# Creates the catchment_huc12 table in public schema
# usage: ./create-catchment_huc12.sh <dbname>

DB=$1

echo Creating catchment_huc12 table...
psql -d $DB -f catchment_huc12.sql
