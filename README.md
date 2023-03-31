# Assignment 02

**Due: 29 March 2023**

This assignment will work a bit differently than assignment #1. To complete this assigment you will need to do the following:
1.  Fork this repository to your own account.
2.  Clone your fork to your local machine.
3.  Complete the assignment according to the instructions below.
4.  Push your changes to your fork.
5.  Submit a pull request to the original repository. Opening your pull request will be equivalent to you submitting your assignment. You will only need to open one pull request for this assignment. **If you make additional changes to your fork, they will automatically show up in the pull request you already opened.** Your pull request should have your name in the title (e.g. `Assignment 02 - Mjumbe Poe`).

----------------

## Instructions<img width="703" alt="Screenshot 2023-03-30 at 3 14 52 PM" src="https://user-images.githubusercontent.com/75055449/228940504-2658dee1-ea1f-4d5f-985f-d4930485bbe3.png">


Write a query to answer each of the questions below.
* Your queries should produce results in the format specified by each question.
* Write your query in a SQL file corresponding to the question number (e.g. a file named _query06.sql_ for the answer to question #6).
* Each SQL file should contain a single query that retrieves data from the database (i.e. a `SELECT` query).
* Any SQL that does things other than retrieve data (e.g. SQL that creates indexes or update columns) should be in the _db_structure.sql_ file.
* Some questions include a request for you to discuss your methods. Update this README file with your answers in the appropriate place.

There are several datasets that are prescribed for you to use in this part. Your datasets tables be named:
*   `septa.bus_stops` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases) -- Use the file for February 26, 2023)
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_stops (
            stop_id TEXT,
            stop_name TEXT,
            stop_lat DOUBLE PRECISION,
            stop_lon DOUBLE PRECISION,
            location_type TEXT,
            parent_station TEXT,
            zone_id TEXT,
            wheelchair_boarding INTEGER
        );
        ```
*   `septa.bus_routes` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_routes (
            route_id TEXT,
            route_short_name TEXT,
            route_long_name TEXT,
            route_type TEXT,
            route_color TEXT,
            route_text_color TEXT,
            route_url TEXT
        );
        ```
*   `septa.bus_trips` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *  In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_trips (
            route_id TEXT,
            service_id TEXT,
            trip_id TEXT,
            trip_headsign TEXT,
            block_id TEXT,
            direction_id TEXT,
            shape_id TEXT
        );
        ```
*   `septa.bus_shapes` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_shapes (
            shape_id TEXT,
            shape_pt_lat DOUBLE PRECISION,
            shape_pt_lon DOUBLE PRECISION,
            shape_pt_sequence INTEGER
        );
        ```
*   `septa.rail_stops` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.rail_stops (
            stop_id TEXT,
            stop_name TEXT,
            stop_desc TEXT,
            stop_lat DOUBLE PRECISION,
            stop_lon DOUBLE PRECISION,
            zone_id TEXT,
            stop_url TEXT
        );
        ```
*   `phl.pwd_parcels` ([OpenDataPhilly](https://opendataphilly.org/dataset/pwd-stormwater-billing-parcels))
    *   In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln phl.pwd_parcels \
            -nlt MULTIPOLYGON \
            -t_srs EPSG:4326 \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "${DATA_DIR}/phl_pwd_parcels/PWD_PARCELS.shp"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_
*   `azavea.neighborhoods` ([Azavea's GitHub](https://github.com/azavea/geo-data/tree/master/Neighborhoods_Philadelphia))
    * In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln azavea.neighborhoods \
            -nlt MULTIPOLYGON \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "${DATA_DIR}/Neighborhoods_Philadelphia.geojson"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_
*   `census.blockgroups_2020` ([Census TIGER FTP](https://www2.census.gov/geo/tiger/TIGER2020/BG/) -- Each state has it's own file; Use file number `42` for PA)
    *   In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln census.blockgroups_2020 \
            -nlt MULTIPOLYGON \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "$DATADIR/census_blockgroups_2020/tl_2020_42_bg.shp"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_
  *   `census.population_2020` ([Census Explorer](https://data.census.gov/table?t=Populations+and+People&g=0500000US42101$1500000&y=2020&d=DEC+Redistricting+Data+(PL+94-171)&tid=DECENNIALPL2020.P1))  
      * In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE census.population_2020 (
            geoid TEXT,
            geoname TEXT,
            total INTEGER
        );
        ```
      * Note that the file from the Census Explorer will have more fields than those three. You may have to do some data preprocessing to get the data into the correct format.

**Note, when tests aren't passing, I do take logic for solving problems into account _for partial credit_ when grading. When in doubt, write your thinking for solving the problem even if you aren't able to get a full response.**

## Questions

1.  Which **eight** bus stop have the largest population within 800 meters? As a rough estimation, consider any block group that intersects the buffer as being part of the 800 meter buffer.

The eight bus stops with the largest population:
"Lombard St & 18th St"
"Rittenhouse Sq & 18th St "
"Snyder Av & 9th St "
"Lombard St & 19th St"
"19th St & Lombard St "
"16th St & Locust St "
"Locust St & 16th St "
"South St & 19th St"

<img width="727" alt="Screenshot 2023-03-30 at 2 08 18 AM" src="https://user-images.githubusercontent.com/75055449/228744770-423f3c34-fef8-49c4-ada1-82c2a7944234.png">


2.  Which **eight** bus stops have the smallest population above 500 people _inside of Philadelphia_ within 800 meters of the stop (Philadelphia county block groups have a geoid prefix of `42101` -- that's `42` for the state of PA, and `101` for Philadelphia county)?

    **The queries to #1 & #2 should generate results with a single row, with the following structure:**

    ```sql
    (
        stop_name text, -- The name of the station
        estimated_pop_800m integer, -- The population within 800 meters
        geog geography -- The geography of the bus stop
    )
    ```

"Delaware Av & Venango St"
"Delaware Av & Tioga St"
"Delaware Av & Castor Av"
"Northwestern Av & Stenton Av"
"Stenton Av & Northwestern Av"
"Bethlehem Pk & Chesney Ln"
"Bethlehem Pk & Chesney Ln"
"Delaware Av & Wheatsheaf Ln"

<img width="758" alt="Screenshot 2023-03-30 at 2 21 51 AM" src="https://user-images.githubusercontent.com/75055449/228747383-7a32f2ba-20ff-4222-b042-139aa31ed99c.png">

3.  Using the Philadelphia Water Department Stormwater Billing Parcels dataset, pair each parcel with its closest bus stop. The final result should give the parcel address, bus stop name, and distance apart in meters. Order by distance (largest on top).

<img width="616" alt="Screenshot 2023-03-30 at 2 37 31 PM" src="https://user-images.githubusercontent.com/75055449/228932555-b2d21c7a-8193-4e83-a1ef-b3698456d741.png">

_Your query should run in under two minutes._

>_**HINT**: This is a [nearest neighbor](https://postgis.net/workshops/postgis-intro/knn.html) problem.


    **Structure:**
    ```sql
    (
        parcel_address text,  -- The address of the parcel
        stop_name text,  -- The name of the bus stop
        distance double precision  -- The distance apart in meters
    )
    ```

4.  Using the `bus_shapes`, `bus_routes`, and `bus_trips` tables from GTFS bus feed, find the **two** routes with the longest trips.

    _Your query should run in under two minutes._

    >_**HINT**: The `ST_MakeLine` function is useful here. You can see an example of how you could use it at [this MobilityData walkthrough](https://docs.mobilitydb.com/MobilityDB-workshop/master/ch04.html#:~:text=INSERT%20INTO%20shape_geoms) on using GTFS data. If you find other good examples, please share them in Slack._

    >_**HINT**: Use the query planner (`EXPLAIN`) to see if there might be opportunities to speed up your query with indexes. For reference, I got this query to run in about 15 seconds._

    >_**HINT**: The `row_number` window function could also be useful here. You can read more about window functions [in the PostgreSQL documentation](https://www.postgresql.org/docs/9.1/tutorial-window.html). That documentation page uses the `rank` function, which is very similar to `row_number`. For more info about window functions you can check out:_
    >*   📑 [_An Easy Guide to Advanced SQL Window Functions_](https://towardsdatascience.com/a-guide-to-advanced-sql-window-functions-f63f2642cbf9) in Towards Data Science, by Julia Kho
    >*   🎥 [_SQL Window Functions for Data Scientists_](https://www.youtube.com/watch?v=e-EL-6Vnkbg) (and a [follow up](https://www.youtube.com/watch?v=W_NBnkLLh7M) with examples) on YouTube, by Emma Ding

<img width="672" alt="Screenshot 2023-03-30 at 3 15 15 PM" src="https://user-images.githubusercontent.com/75055449/228940592-244c377e-accc-4da6-9b9a-b25d24c54aa8.png">

    **Structure:**
    ```sql
    (
        route_short_name text,  -- The short name of the route
        trip_headsign text,  -- Headsign of the trip
        shape_geog geography,  -- The shape of the trip
        shape_length double precision  -- Length of the trip in meters
    )
    ```

5.  Rate neighborhoods by their bus stop accessibility for wheelchairs. Use Azavea's neighborhood dataset from OpenDataPhilly along with an appropriate dataset from the Septa GTFS bus feed. Use the [GTFS documentation](https://gtfs.org/reference/static/) for help. Use some creativity in the metric you devise in rating neighborhoods.

    _NOTE: There is no automated test for this question, as there's no one right answer. With urban data analysis, this is frequently the case._

Total rows: 156 of 156
Query complete 00:00:01.951

"WASHINGTON_SQUARE"
"NEWBOLD"
"HAWTHORNE"
"FRANCISVILLE"
"SPRING_GARDEN"
"RITTENHOUSE"
"FAIRMOUNT"
"WALNUT_HILL"
"OLD_CITY"
"WEST_PASSYUNK"
"EAST_KENSINGTON"
"BELLA_VISTA"
"CENTER_CITY"
"PENNSPORT"
"GREENWICH"
"LUDLOW"
"LOGAN_SQUARE"
"GERMANTOWN_PENN_KNOX"
"FITLER_SQUARE"
"FRANKLINVILLE"
"SOCIETY_HILL"
"GRADUATE_HOSPITAL"
"LOWER_MOYAMENSING"
"PASSYUNK_SQUARE"
"POINT_BREEZE"
"CALLOWHILL"
"STRAWBERRY_MANSION"
"GIRARD_ESTATES"
"EAST_PASSYUNK"
"QUEEN_VILLAGE"
"EAST_POPLAR"
"FERN_ROCK"
"EAST_PARKSIDE"
"NORTH_CENTRAL"
"STANTON"
"WEST_POPLAR"
"EAST_OAK_LANE"
"HADDINGTON"
"YORKTOWN"
"OGONTZ"
"ROXBOROUGH"
"HAVERFORD_NORTH"
"HARTRANFT"
"GARDEN_COURT"
"MCGUIRE"
"GERMANTOWN_WESTSIDE"
"BELMONT"
"WEST_KENSINGTON"
"POWELTON"
"GERMANTOWN_WEST_CENT"
"NICETOWN"
"SUMMERDALE"
"DICKINSON_NARROWS"
"OLNEY"
"MILL_CREEK"
"SPRUCE_HILL"
"LOGAN"
"BREWERYTOWN"
"COBBS_CREEK"
"FISHTOWN"
"TIOGA"
"WHITMAN"
"FRANKFORD"
"MANTUA"
"GLENWOOD"
"ALLEGHENY_WEST"
"DUNLAP"
"CHINATOWN"
"GERMANTOWN_SOUTHWEST"
"NORTHERN_LIBERTIES"
"HUNTING_PARK"
"UNIVERSITY_CITY"
"GERMANTOWN_MORTON"
"CARROLL_PARK"
"WYNNEFIELD_HEIGHTS"
"GERMANTOWN_EAST"
"MAYFAIR"
"UPPER_KENSINGTON"
"GRAYS_FERRY"
"WEST_POWELTON"
"ELMWOOD"
"OXFORD_CIRCLE"
"WEST_OAK_LANE"
"OVERBROOK"
"OLD_KENSINGTON"
"CLEARVIEW"
"RHAWNHURST"
"MELROSE_PARK_GARDENS"
"JUNIATA_PARK"
"CEDAR_PARK"
"ASTON_WOODBRIDGE"
"CEDARBROOK"
"MOUNT_AIRY_EAST"
"HARROWGATE"
"FAIRHILL"
"BURHOLME"
"FELTONVILLE"
"LAWNDALE"
"NORTHWOOD"
"LEXINGTON_PARK"
"WYNNEFIELD"
"WEST_PARKSIDE"
"ACADEMY_GARDENS"
"PENROSE"
"MANAYUNK"
"FOX_CHASE"
"MORRELL_PARK"
"WISSAHICKON"
"MODENA"
"PENNYPACK_WOODS"
"WINCHESTER_PARK"
"SOUTHWEST_SCHUYLKILL"
"WISSINOMING"
"ROXBOROUGH_PARK"
"PASCHALL"
"WOODLAND_TERRACE"
"PARKWOOD_MANOR"
"RICHMOND"
"BUSTLETON"
"KINGSESSING"
"EAST_FALLS"
"WISSAHICKON_HILLS"
"SOMERTON"
"PENNYPACK"
"CRESCENTVILLE"
"TACONY"
"HOLMESBURG"
"MOUNT_AIRY_WEST"
"STADIUM_DISTRICT"
"RIVERFRONT"
"GERMANY_HILL"
"NORMANDY_VILLAGE"
"NORTHEAST_AIRPORT"
"WISTER"
"SHARSWOOD"
"TORRESDALE"
"EASTWICK"
"FRANKLIN_MILLS"
"CHESTNUT_HILL"
"BYBERRY"
"PACKER_PARK"
"ANDORRA"
"BRIDESBURG"
"MILLBROOK"
"PORT_RICHMOND"
"UPPER_ROXBOROUGH"
"EAST_PARK"
"WEST_PARK"
"WISSAHICKON_PARK"
"DEARNLEY_PARK"
"PENNYPACK_PARK"
"CRESTMONT_FARMS"
"INDUSTRIAL"
"AIRPORT"
"NAVY_YARD"
"WEST_TORRESDALE"


Discuss your accessibility metric and how you arrived at it below:

**Description:**  I am using the proportion of wheelchair accessible bus stops in the neighborhood to calculate the accessibility of bus stops in each neighborhood. I divided the count of wheelchair accessible bus stops in each neighborhood by the area of the neighborhood, resulting in a density of accessible bus stops per unit of area. So the accessibility metric the density of accessible bus stops. This metric assumes that the more wheelchair accessible bus stops a neighborhood has per unit, the more accessible it is for people with mobility disabilities who use wheelchairs to travel by bus.

6.  What are the _top five_ neighborhoods according to your accessibility metric?

<img width="732" alt="Screenshot 2023-03-30 at 6 06 42 PM" src="https://user-images.githubusercontent.com/75055449/228974601-c863b8f1-da61-46e4-8d9f-21f85f050bb4.png">

"WASHINGTON_SQUARE"
"NEWBOLD"
"HAWTHORNE"
"FRANCISVILLE"
"SPRING_GARDEN"


7.  What are the _bottom five_ neighborhoods according to your accessibility metric?

<img width="727" alt="Screenshot 2023-03-30 at 6 07 04 PM" src="https://user-images.githubusercontent.com/75055449/228974653-422b3476-88ac-437b-bf6a-54950aaf07ad.png">

"BARTRAM_VILLAGE"
"WEST_TORRESDALE"
"NAVY_YARD"
"AIRPORT"
"INDUSTRIAL"

    **Both #6 and #7 should have the structure:**
    ```sql
    (
      neighborhood_name text,  -- The name of the neighborhood
      accessibility_metric ...,  -- Your accessibility metric value
      num_bus_stops_accessible integer,
      num_bus_stops_inaccessible integer
    )
    ```

8.  With a query, find out how many census block groups Penn's main campus fully contains. Discuss which dataset you chose for defining Penn's campus.

<img width="204" alt="Screenshot 2023-03-31 at 12 19 14 AM" src="https://user-images.githubusercontent.com/75055449/229021693-8ff221cb-de03-4701-90a7-20214e9cc574.png">


    **Structure (should be a single value):**
    ```sql
    (
        count_block_groups integer
    )
    ```

    **Discussion: I defined a single polygon which fully contains the Penn's main campus by using `ST_MakeBox2D`. I chose two points at the corner, **

9. With a query involving PWD parcels and census block groups, find the `geo_id` of the block group that contains Meyerson Hall. `ST_MakePoint()` and functions like that are not allowed.

<img width="201" alt="Screenshot 2023-03-31 at 12 36 59 AM" src="https://user-images.githubusercontent.com/75055449/229023727-0aaff025-2aa8-444e-8547-9a3b2845a651.png">


    **Structure (should be a single value):**
    ```sql
    (
        geo_id text
    )
    ```

10. You're tasked with giving more contextual information to rail stops to fill the `stop_desc` field in a GTFS feed. Using any of the data sets above, PostGIS functions (e.g., `ST_Distance`, `ST_Azimuth`, etc.), and PostgreSQL string functions, build a description (alias as `stop_desc`) for each stop. Feel free to supplement with other datasets (must provide link to data used so it's reproducible), and other methods of describing the relationships. SQL's `CASE` statements may be helpful for some operations.

    **Structure:**
    ```sql
    (
        stop_id integer,
        stop_name text,
        stop_desc text,
        stop_lon double precision,
        stop_lat double precision
    )
    ```

   As an example, your `stop_desc` for a station stop may be something like "37 meters NE of 1234 Market St" (that's only an example, feel free to be creative, silly, descriptive, etc.)

   >**Tip when experimenting:** Use subqueries to limit your query to just a few rows to keep query times faster. Once your query is giving you answers you want, scale it up. E.g., instead of `FROM tablename`, use `FROM (SELECT * FROM tablename limit 10) as t`.
