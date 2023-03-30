alter table azavea.neighborhoods
alter column the_geog type geography
using ST_Transform(the_geog::geometry, 4269);

WITH
  neighborhoods AS (
    SELECT
      name,
      the_geog as geog
    FROM azavea.neighborhoods
  ),
  bus_stops AS (
    SELECT
      stop_id,
      stop_name,
      ST_SetSRID(ST_MakePoint(stop_lon, stop_lat), 4269)::geography AS geog,
      wheelchair_boarding
    FROM septa.bus_stops
  ),
  neighborhood_bus_stops AS (
    SELECT
      neighborhoods.name AS neighborhood,
      COUNT(*) AS num_stops_wheelchair_accessible,
      ST_Area(neighborhoods.geog) AS area,
      ST_Union(bus_stops.geog::geometry) AS all_stops_geog
    FROM neighborhoods
    JOIN bus_stops ON ST_Intersects(neighborhoods.geog, bus_stops.geog)
    WHERE bus_stops.wheelchair_boarding = 1
    GROUP BY neighborhoods.name, neighborhoods.geog
  )
  
SELECT
  neighborhood,
  num_stops_wheelchair_accessible / area AS bus_stop_accessibility_density
FROM neighborhood_bus_stops
ORDER BY bus_stop_accessibility_density DESC;
