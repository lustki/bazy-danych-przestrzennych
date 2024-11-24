-- Zadanie 1
CREATE TABLE obiekty (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	geom GEOMETRY
);

INSERT INTO obiekty (name, geom) VALUES (
'obiekt1',
ST_Union(
	ST_GeomFromText('LINESTRING(0 1, 1 1)'),
		ST_Union(
		ST_LineToCurve(ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)')),
		ST_Union(
			ST_LineToCurve(ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)')),
			ST_GeomFromText('LINESTRING(5 1, 6 1)')
			)
		)
)
);

INSERT INTO obiekty (name, geom) VALUES (
'obiekt2',
ST_Union(
	ST_GeomFromText('LINESTRING(10 6, 14 6)'),
		ST_Union(
		ST_LineToCurve(ST_GeomFromText('CIRCULARSTRING(14 6, 16 4, 14 2)')),
		ST_Union(
			ST_LineToCurve(ST_GeomFromText('CIRCULARSTRING(14 2, 12 0, 10 2)')),
			ST_Union(
				ST_GeomFromText('LINESTRING(10 2, 10 6)'),
				ST_Union(
					ST_LineToCurve(ST_GeomFromText('CIRCULARSTRING(11 2, 12 3, 13 2)')),
					ST_LineToCurve(ST_GeomFromText('CIRCULARSTRING(13 2, 12 1, 11 2)'))
					)
				)
			)
		)
)
);

INSERT INTO obiekty (name, geom) VALUES (
'obiekt3',
ST_Union(
	ST_GeomFromText('LINESTRING(7 15, 10 17)'),
	ST_Union(
		ST_GeomFromText('LINESTRING(10 17, 12 13)'),		
		ST_GeomFromText('LINESTRING(12 13, 7 15)')
		)
	)
);

INSERT INTO obiekty (name, geom) VALUES (
'obiekt4',
ST_Union(
	ST_GeomFromText('LINESTRING(20 20, 25 25)'),
	ST_Union(
		ST_GeomFromText('LINESTRING(25 25, 27 24)'),
		ST_Union(
			ST_GeomFromText('LINESTRING(27 24, 25 22)'),
			ST_Union(
				ST_GeomFromText('LINESTRING(25 22, 26 21)'),
				ST_Union(
					ST_GeomFromText('LINESTRING(26 21, 22 19)'),
					ST_GeomFromText('LINESTRING(22 19, 20.5 19.5)')
					)
				)
			)
		)
	)
);

INSERT INTO obiekty (name, geom) VALUES (
'obiekt5',
ST_Union(
	ST_MakePoint(30, 30, 59),
	ST_MakePoint(38, 32, 234)
	)
);

INSERT INTO obiekty (name, geom) VALUES (
'obiekt6',
ST_Union(
	ST_GeomFromText('LINESTRING(1 1, 3 2)'),
	ST_Point(4, 2)
	)
);

-- Zadanie 2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(o1.geom, o2.geom), 5))
FROM obiekty o1, obiekty o2
WHERE o1.name='obiekt3' and o2.name='obiekt4';

-- Zadanie 3
UPDATE obiekty
SET geom = ST_LineMerge(geom)
WHERE name='obiekt4';

UPDATE obiekty
SET geom = ST_MakePolygon(ST_AddPoint(geom, ST_StartPoint(geom)))
WHERE name='obiekt4';

-- Zadanie 4
INSERT INTO obiekty (name, geom) SELECT
'obiekt7',
ST_Union(o1.geom, o2.geom)
FROM obiekty o1, obiekty o2
WHERE o1.name='obiekt3' and o2.name='obiekt4';

-- Zadanie 5
SELECT SUM(ST_Area(ST_Buffer(geom, 5)))
FROM obiekty
WHERE NOT ST_HasArc(geom);