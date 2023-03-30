WITH

parcels AS (
    SELECT
      geog,
      address
    FROM phl.pwd_parcels
  ),

bus_stops AS (
    SELECT
      stop_id,
      stop_name,
      geog
    FROM septa.bus_stops
  ),
  
closest_bus_stop AS (
    SELECT DISTINCT ON (p.address)
      p.address,
      bs.stop_name,
      ST_Distance(p.geog, bs.geog) AS distance
    FROM parcels p
    JOIN bus_stops bs ON ST_Distance(p.geog, bs.geog) < 800 
    ORDER BY p.address, ST_Distance(p.geog, bs.geog)
  )
  
SELECT
  cb.address,
  cb.stop_name,
  cb.distance
FROM closest_bus_stop cb
ORDER BY cb.distance DESC;