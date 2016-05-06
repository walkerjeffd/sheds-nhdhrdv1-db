NHDHRDV1 Database
=================

[Jeffrey D Walker, PhD](http://walkerenvres.com)

This repo contains a series of scripts for creating a PostgreSQL database containing the National Hydrography Dataset High Resolution Delineation Version 1 (NHDHRDV1). Version 1 is now deprecated and all current future projects should use [Version 2](https://github.com/Conte-Ecology/shedsGisData/tree/master/NHDHRDV2). This repo was created to support legacy projects that still depend on NHDHRDV1.

The scripts should be in run in order like this:

```sh
DBNAME=nhdhrdv1
./create-db.sh $DBNAME
./import-states.sh $DBNAME /path/to/states
./import-catchments.sh $DBNAME /path/to/catchments
./import-wbd.sh $DBNAME /path/to/wbd
psql -d $DBNAME -c "VACUUM ANALYZE;"  # clean up
./create-catchment_huc12.sh
```

The `states` and `wbd` datasets will be downloaded automatically from the web to their respective folders.

The `catchments` script assumes the catchments folder contains the NHDHRDV1 shapefile named `NortheastHRD_AllCatchments.shp`.

All shapefiles will be converted to WGS84 (EPSG:4326) before being imported.

All tables will be created within the `public` schema.
