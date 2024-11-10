CREATE EXTENSION postgis;

-- Zadanie 1
SELECT polygon_id
FROM (
	SELECT n.polygon_id, ST_EQUALS(n.geom, e.geom) 
	FROM t2019_kar_germany AS n
	JOIN t2018_kar_germany AS e 
	ON n.polygon_id = e.polygon_id
) AS p
WHERE st_equals != true

UNION

SELECT n.polygon_id FROM t2019_kar_germany AS n
LEFT join t2018_kar_germany AS e 
ON n.polygon_id = e.polygon_id
WHERE e.polygon_id IS NULL;

-- Zadanie 2
WITH new_build AS (
    SELECT geom AS geom
    FROM (
        SELECT n.polygon_id, n.geom AS geom, ST_Equals(n.geom, e.geom) AS geom_equals 
        FROM t2019_kar_germany AS n
        JOIN t2018_kar_germany AS e ON n.polygon_id = e.polygon_id
    ) AS p
    WHERE geom_equals != true

    UNION

    SELECT n.geom AS geom
    FROM t2019_kar_germany AS n
    LEFT JOIN t2018_kar_germany AS e ON n.polygon_id = e.polygon_id
    WHERE e.polygon_id IS NULL
),

new_points AS (
	SELECT n.poi_id, n.geom AS geom, n.type
	FROM t2019_kar_poi_table AS n
	LEFT join t2018_kar_poi_table AS e ON
	n.poi_id = e.poi_id
	WHERE e.poi_id IS NULL
),
buffor AS (
    SELECT ST_Buffer(geom, 0.005) AS geom
    FROM new_build
)

SELECT p.type, COUNT(p.poi_id) AS poi_count
FROM new_points AS p 
JOIN buffor AS b ON ST_Intersects(p.geom, b.geom)
GROUP BY p.type;

-- Zadanie 3

UPDATE streets_reprojected
SET geom = ST_SetSRID(geom, 3068)
WHERE geom IS NOT NULL;

-- Zadanie 4

CREATE TABLE input_points (
	id SERIAL PRIMARY KEY,
	geom GEOMETRY(Point)
);

INSERT INTO input_points VALUES (1, ST_GeomFromText('POINT(8.36093 49.03174)'));
INSERT INTO input_points VALUES (2, ST_GeomFromText('POINT(8.39876 49.00644)'));

-- Zadanie 5

UPDATE input_points
SET geom = ST_SetSRID(geom, 3068)
WHERE geom IS NOT NULL;


-- Zadanie 6

UPDATE T2019_KAR_STREET_NODE
SET geom = ST_SetSRID(geom, 3068)
WHERE geom IS NOT NULL;

WITH line AS (
	SELECT ST_Buffer(ST_MakeLine(geom), 200) as geom 
	FROM input_points 
)

SELECT DISTINCT(n.node_id) AS node_id
FROM T2019_KAR_STREET_NODE AS n
CROSS JOIN line AS l
WHERE ST_intersects(l.geom, n.geom);

-- Zadanie 7

SELECT COUNT(s.poi_id)
FROM T2019_KAR_POI_TABLE as s
JOIN T2019_KAR_LAND_USE_A AS p
ON ST_Intersects(s.geom, ST_Buffer(p.geom, 0.003))
WHERE s.type = 'Sporting Goods Store';

-- Zadanie 8

CREATE TABLE T2019_KAR_BRIDGES (
	id SERIAL PRIMARY KEY,
	geom GEOMETRY(Point)
);

INSERT INTO T2019_KAR_BRIDGES (geom)
SELECT ST_Intersection(r.geom, w.geom) AS geom
FROM T2019_KAR_RAILWAYS AS r
JOIN T2019_KAR_WATER_LINES AS w
ON ST_Intersects(r.geom, w.geom)
WHERE ST_GeometryType(ST_Intersection(r.geom, w.geom)) = 'ST_Point';

SELECT * FROM T2019_KAR_BRIDGES;