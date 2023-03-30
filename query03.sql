alter table phl.pwd_parcels
alter column geog type geography
using ST_Transform(geog::geometry, 4269);

alter table septa.bus_stops
alter column geog type geography
using ST_Transform(geog::geometry, 4269);

WITH

parcels AS (
    SELECT
      geog,
      address
    FROM phl.pwd_parcels
    WHERE ST_Intersects(geog, ST_MakeEnvelope(-75.3, 39.9, -74.9, 40.2, 4269))
  ),

bus_stops AS (
    SELECT
      stop_id,
      stop_name,
      geog
    FROM septa.bus_stops
  ),
  
closest_bus_stop AS (
    SELECT DISTINCT ON (parcels.address)
      parcels.address,
      bus_stops.stop_name,
      ST_Distance(parcels.geog, bus_stops.geog) AS distance
    FROM parcels 
    JOIN bus_stops ON ST_DWithin(parcels.geog, bus_stops.geog, 800) 
    ORDER BY parcels.address, ST_Distance(parcels.geog, bus_stops.geog)
  )
  
SELECT
  cb.address,
  cb.stop_name,
  cb.distance
FROM closest_bus_stop cb
ORDER BY cb.distance DESC;

