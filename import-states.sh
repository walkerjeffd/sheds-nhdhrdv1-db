#!/bin/bash
# downloads state borders from census.gov and imports to postgresql
# usage: $ ./import-states.sh <db name> <path to states working directory>

set -eu
set -o pipefail

URL="http://www2.census.gov/geo/tiger/GENZ2015/shp"

DB=$1
DIR=$2

BASENAME=cb_2015_us_state_500k
ZIP=$BASENAME.zip
SHP=$BASENAME.shp
URL=$URL/$ZIP

if [ ! -e $DIR ]; then
 echo Creating $DIR...
 mkdir $DIR
fi

if [ -e $DIR/$ZIP ]; then
 echo $DIR/$ZIP already exists, not downloading
else
 echo Downloading $URL...
 wget -nv -O "$DIR/$ZIP-tmp" "$URL" && mv "$DIR/$ZIP-tmp" "$DIR/$ZIP"
fi

if [ -e $DIR/$SHP ]; then
 echo $DIR/$SHP already exists, not extracting
else
 echo Extracting $DIR/$ZIP...
 unzip "$DIR/$ZIP" -d $DIR
fi

echo Importing $DIR/$SHP to $DB...
ogr2ogr -f PostgreSQL "PG:dbname=$DB host=localhost" -t_srs "EPSG:4326" $DIR/$SHP -lco OVERWRITE=YES -lco GEOMETRY_NAME=geom -lco DIM=2 -lco PG_USE_COPY=YES -nlt MULTIPOLYGON -nln states
