WITH 
    penn_boundary AS (
        SELECT ST_SetSRID(ST_MakeBox2D(
            ST_Point(-75.195232, 39.952129),  -- 38th and Walnut St.
            ST_Point(-75.189905, 39.951248)  -- 34th and Spruce St.
        )::geometry, 4269) AS geog
    ),
    block_groups AS (
        SELECT geoid
        FROM census.blockgroups_2020
        WHERE ST_Intersects(geog, (SELECT geog FROM penn_boundary))
    )
SELECT COUNT(*) AS count_block_groups
FROM block_groups;
