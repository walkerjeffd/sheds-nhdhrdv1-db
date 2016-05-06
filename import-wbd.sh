#!/bin/bash
# downloads WBD geodatabase and imports HUC layers to postgresql
# saves only HUC4-HUC12 layers and reprojects to WGS84
# usage: ./import-wbd.sh <db name> <working directory>

set -eu
set -o pipefail

URL="ftp://rockyftp.cr.usgs.gov/vdelivery/Datasets/Staged/WBD/FileGDB101/WBD_National.gdb.zip"

DB=$1
DIR=$2

NAME=$(basename $URL)

if [ ! -e "$DIR" ]; then
  echo Creating directory "$DIR"...
  mkdir "$DIR"
fi

if [ -e $DIR/$NAME ]; then
  echo "$DIR/$NAME" already exists, not downloading
else
  echo Downloading "$DIR/$NAME"...
  curl -f -# --output "$DIR/$NAME-tmp" "$URL" && mv "$DIR/$NAME-tmp" "$DIR/$NAME"
fi

if [ -e $DIR/WBD_National.gdb ]; then
  echo $DIR/WBD_National.gdb already exists, not extracting
else
  echo Extracting $DIR/$NAME...
  7z -y -o$DIR x "$DIR/$NAME" | grep Extracting || true
fi

echo Importing WBD_National.gdb HUC layers to database $DB...
ogr2ogr -f PostgreSQL "PG:dbname=$DB host=localhost" -t_srs "EPSG:4326" $DIR/WBD_National.gdb WBDHU4 WBDHU6 WBDHU8 WBDHU10 WBDHU12 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geom -lco DIM=2 -lco FID=fid -lco PG_USE_COPY=YES
