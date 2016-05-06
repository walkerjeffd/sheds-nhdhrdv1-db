DROP TABLE IF EXISTS catchment_huc12;

CREATE TABLE catchment_huc12 AS
  SELECT c.featureid, w.huc12 as huc12
  FROM catchments c, wbdhu12 w
  WHERE ST_Contains(w.geom, ST_Centroid(c.geom));

ALTER TABLE catchment_huc12
  ADD CONSTRAINT catchment_huc12_featureid_fkey
  FOREIGN KEY (featureid) REFERENCES catchments (featureid);

CREATE INDEX catchment_huc12_huc12_idx ON catchment_huc12 (huc12);
CREATE INDEX catchment_huc12_huc8_idx ON catchment_huc12 (substr(huc12, 1, 8));
