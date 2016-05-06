#!/bin/bash
# imports catchments shapefile to table gis.catchments

# usage: $ ./import_catchments.sh <db name> <path to catchments folder>

set -eu

DB=$1
WD=$2

TABLE=catchments

FILE=$WD/NortheastHRD_AllCatchments.shp
FILE_WGS=$WD/NortheastHRD_AllCatchments_wgs84.shp

if [ ! -e $FILE ]; then
  echo Could not find input shapefile: $FILE
  exit 1
fi

# convert shapefile from EPSG:5070 (NAD83 Albers) to EPSG:4326
if [ ! -e $FILE_WGS ]; then
  echo Converting $FILE to WGS84
  ogr2ogr -f "ESRI Shapefile" $FILE_WGS $FILE -s_srs EPSG:5070 -t_srs EPSG:4326 -select "OBJECTID,HydroID,GridID,NextDownID,RiverOrder,FEATUREID,AreaSqKM,Source"
else
  echo WGS84 file already exists: $FILE_WGS
fi

echo Importing catchments layer to database $DB...
shp2pgsql -s 4326:4326 -g geom -I -c -t 2D $FILE_WGS $TABLE | psql -d $DB -q

echo Adding unique index on featureid...
psql -d $DB -c "ALTER TABLE "$TABLE" ADD CONSTRAINT featureid_idx UNIQUE (featureid);"
