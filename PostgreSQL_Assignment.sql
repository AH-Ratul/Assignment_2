CREATE TABLE rangers (
	ranger_id SERIAL PRIMARY KEY, 
	"name" varchar(100) NOT NULL, 
	region varchar(100) NOT NULL
	);

CREATE TABLE species (
	species_id SERIAL PRIMARY KEY, 
	common_name varchar(100) NOT NULL, 
	scientific_name varchar(150) NOT NULL, 
	discovery_date DATE,
	conservation_status varchar(50)
	);

CREATE TABLE sightings (
	sighting_id SERIAL PRIMARY KEY, 
	ranger_id INT REFERENCES rangers(ranger_id),
	species_id INT REFERENCES species(species_id),
	sighting_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	"location" varchar(150),
	notes TEXT
	);

INSERT INTO rangers ("name", region)
	VALUES ('Alice Green', 'Northern Hills'),
	('Bob White', 'River Delta'),
	('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
	VALUES ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
	('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
	('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
	('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings(ranger_id, species_id,"location", sighting_time, notes)
	VALUES (1,1,'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
	(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'), 
	(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
	(2, 1, 'Snowfall Pass', '2024-05-18 18:30:00', null);


-- Problem 1  
INSERT INTO rangers("name", region) VALUES('Derek Fox', 'Coaster Plains');

-- Problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- Problem 3
SELECT * FROM sightings WHERE "location" LIKE '%Pass';

-- Problem 4
SELECT "name", COUNT(ranger_id) AS total_sightings FROM sightings 
	JOIN rangers USING(ranger_id) GROUP BY ranger_id, "name";

-- Problem 5
SELECT common_name FROM species LEFT JOIN sightings si 
	USING(species_id) WHERE si.species_id IS NULL;

-- Problem 6
SELECT common_name, sighting_time, "name" FROM sightings si 
	JOIN species USING(species_id) JOIN rangers USING(ranger_id)
		ORDER BY si.sighting_time DESC LIMIT 2;

-- Problem 7
UPDATE species SET conservation_status = 'Historic' WHERE discovery_date < '1800-01-01';

-- Problem 8
SELECT sighting_id,
	CASE
		WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS time_of_day
FROM sightings;

-- Problem 9
DELETE FROM rangers WHERE ranger_id NOT IN (
	SELECT DISTINCT ranger_id FROM sightings
	);
