----------------------------------------------------
--[SECTION ONE]-------------------------------------
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (id INTEGER PRIMARY KEY AUTOINCREMENT, n integer);
WITH RECURSIVE
  cnt(x) AS (
     SELECT 1
     UNION ALL
     SELECT x+1 FROM cnt
      LIMIT 10000
  )
INSERT INTO numbers (n)
SELECT x FROM cnt;


DROP TABLE IF EXISTS bike_network_merge;
CREATE TABLE bike_network_merge (id INTEGER PRIMARY KEY AUTOINCREMENT, facilities integer);
SELECT AddGeometryColumn('bike_network_merge','geom',32188,'MULTILINESTRING','XYZM'); 

INSERT INTO bike_network_merge (facilities, geom) 
SELECT facilities, CastToMultiLinestring(ST_LineMerge(ST_Collect(geom))) FROM bike_network
GROUP BY facilities;

--[SECTION TWO]-------------------------------------
DROP TABLE IF EXISTS bike_network_merge_dissolve;
CREATE TABLE bike_network_merge_dissolve (id INTEGER PRIMARY KEY AUTOINCREMENT, n integer, facilities integer);
SELECT AddGeometryColumn('bike_network_merge_dissolve','geom',32188,'LINESTRING','XYZM');

--[SECTION THREE]-------------------------------------
INSERT INTO bike_network_merge_dissolve (n, facilities, geom)
SELECT l.n, r.facilities,ST_GeometryN(r.geom,l.n)
FROM numbers l
JOIN bike_network_merge r
ON l.n <= ST_NumGeometries(r.geom);

--[SECTION FOUR]-------------------------------------
-- create table with start points and endpoints of merged polylines
-- and create 2 meters and 5 meters buffer along startpoints and endpoints of merged polylines
DROP TABLE IF EXISTS bike_network_merge_points;
CREATE TABLE bike_network_merge_points (id INTEGER PRIMARY KEY AUTOINCREMENT, id_link, facilities integer);
SELECT AddGeometryColumn('bike_network_merge_points','geom_point',32188,'POINT','XYZM');
SELECT AddGeometryColumn('bike_network_merge_points','geom_point_buffer_2m',32188,'POLYGON','XYZM'); 
SELECT AddGeometryColumn('bike_network_merge_points','geom_point_buffer_5m',32188,'POLYGON','XYZM');

INSERT INTO bike_network_merge_points (id_link, facilities, geom_point, geom_point_buffer_2m, geom_point_buffer_5m)
SELECT id, facilities, ST_StartPoint(geom) as geom_point, 
ST_Buffer (ST_StartPoint(geom),2) as geom_point_buffer_2m, 
ST_Buffer (ST_StartPoint(geom),5) as geom_point_buffer_5m
FROM bike_network_merge_dissolve;

INSERT INTO bike_network_merge_points (id_link, facilities, geom_point, geom_point_buffer_2m, geom_point_buffer_5m)
SELECT id, facilities, ST_EndPoint(geom) as geom_point, 
ST_Buffer (ST_EndPoint(geom),2) as geom_point_buffer_2m,
ST_Buffer (ST_EndPoint(geom),5) as geom_point_buffer_5m
FROM bike_network_merge_dissolve;

--[SECTION FIVE]----------------------------------------
-- spatial intersection between 2 meters buffers and bike network to see if there is another facility inside the buffer

DROP TABLE IF EXISTS bike_network_merge_dissolve_within_2m;
CREATE TABLE bike_network_merge_dissolve_within_2m AS 
SELECT b.id_link as id_link, b.geom_point as geom_point, count(b.id_link) as frequency
FROM 
(SELECT l.id_link, l.geom_point, r.id  FROM
bike_network_merge_points l
LEFT JOIN
bike_network_merge_dissolve r
ON ST_Intersects(l.geom_point_buffer_2m, r.geom)
AND l.id_link != r.id) b
WHERE b.id IS NULL
GROUP BY b.id_link;

SELECT RecoverGeometryColumn('bike_network_merge_dissolve_within_2m', 'geom_point', 32188, 'POINT', 'XYZM');

--[SECTION SIX]----------------------------------------
-- spatial intersection between 5 meters buffers and bike network to see if there is another facility (but with a different type) inside the buffer

DROP TABLE IF EXISTS bike_network_merge_dissolve_within_5m;
CREATE TABLE bike_network_merge_dissolve_within_5m AS 
SELECT b.id_link as id_link, b.geom_point as geom_point, count(b.id_link) as frequency
FROM 
(SELECT l.id_link, l.geom_point FROM
bike_network_merge_points l,
bike_network_merge_dissolve r
WHERE ST_Intersects(l.geom_point_buffer_5m, r.geom)
AND l.id_link != r.id
AND l.facilities != r.facilities) b
GROUP BY b.id_link;

SELECT RecoverGeometryColumn('bike_network_merge_dissolve_within_5m', 'geom_point', 32188, 'POINT', 'XYZM');

---------------------------------------
---------------------------------------
